import 'dart:async';
import 'dart:developer';

import 'package:almas_project/src/services/api/api_controller.dart';
import 'package:almas_project/src/services/api/api_repository_cached.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

import 'model_jsonable.dart';
import 'model_next_page.dart';
import 'pagination.dart';

abstract class PaginatedRepository<T extends Jsonable, P>
    extends CachedRepository<T, P> with ChangeNotifier {
  NextPage nextPage;

  PaginatedRepository({
    required super.cache,
    required this.nextPage,
  });

  var _hasMore = true;

  final fetching = ValueNotifier<bool>(false);

  final hasError = ValueNotifier<bool>(false);

  P? _lastParam;

  var _lastResponse = DateTime(0);

  bool get hasMore => _hasMore;

  Set<T> _data = <T>{};

  List<T> get data => List.unmodifiable(_data);

  int get count => _data.length;

  P? get lastParam => _lastParam;

  bool get isNotEmpty => _data.isNotEmpty;

  bool get isEmpty => _data.isEmpty;

  Future<Response<Pagination<T>>> request(P param);

  Future<bool> shouldUpdateCache(P param) async => true;

  Future<void> fetchMore(P param) async {
    if (fetching.value) return;
    try {
      fetching.value = true;
      hasError.value = false;
      if (_lastParam != null &&
          param == _lastParam &&
          !_hasMore &&
          DateTime.now().difference(_lastResponse) >
              const Duration(seconds: 2)) {
        return;
      }

      if (param != _lastParam) {
        // parameter changed -> reset
        _lastParam = param;
        _data.clear();
        _reset();
      }
      if (nextPage.firstPage) {
        restore(param);
      }
      if (await shouldUpdateCache(param)) {
        if (hasMore) {
          final response = await request(param);
          if (response.isSuccessful) {
            final pagination = response.data!;
            if (nextPage.firstPage) {
              _data.clear();
            }
            _hasMore = pagination.hasNextPage;
            nextPage = nextPage.next(pagination.next);
            _data.addAll(pagination.data);
            await saveToCache(_data.toList(), param);
            _lastResponse = DateTime.now();
          } else {
            hasError.value = true;
            return Future.error(response.statusMessage.toString());
          }
        }
      }
    } catch (e, s) {
      if(e.toString().contains("Map<String, dynamic>")){
        throw Error();
      }
      log('PaginatedRepository: $e');
      hasError.value = true;
    } finally {
      fetching.value = false;
      notifyListeners();
    }
  }

  // restore from Cache
  Future<void> restore(P param) async {
    try {
      final cacheData = await retrieveFromCache(param);
      if (cacheData.isNotEmpty) {
        _data
          ..clear()
          ..addAll(cacheData);
      }
    } catch (e) {}
    notifyListeners();
  }

  Future<void> refresh(P param) async {
    try {
      fetching.value = true;
      hasError.value = false;
      notifyListeners();
      if (await shouldUpdateCache(param)) {
        _reset();
        final response = await request(param);
        if (response.isSuccessful) {
          final pagination = response.data!;
          nextPage = nextPage.next(pagination.next);
          _hasMore = pagination.hasNextPage;
          _data
            ..clear()
            ..addAll(pagination.data);
          await saveToCache(_data.toList(), param);
        } else {
          hasError.value = true;
          return Future.error(response.statusMessage.toString());
        }
      }
    } catch (e) {
      hasError.value = true;
    } finally {
      fetching.value = false;
      notifyListeners();
    }
  }

  void insert(T datum) {
    _data.add(datum);
    notifyListeners();
  }

  void replace(T datum) {
    final dataList = _data.toList();
    final index = dataList.indexOf(datum);
    dataList.replaceRange(index, index + 1, [datum]);
    _data = dataList.toSet();
    notifyListeners();
  }

  void removeWhere(bool Function(T) test) {
    _data.removeWhere(test);
    notifyListeners();
  }

  void _reset() {
    nextPage = nextPage.reset();
    _hasMore = true;
  }

  Future<void> reloadLastPage(P param) {
    if (nextPage.previous == null) {
      return refresh(param);
    }
    nextPage = nextPage.previous!;
    _hasMore = true;
    return fetchMore(param);
  }
}
