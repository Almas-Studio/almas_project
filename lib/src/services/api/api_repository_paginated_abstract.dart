import 'model_jsonable.dart';
import 'api_repository_paginated.dart';
import 'api_repository.dart';
import 'package:dio/dio.dart';
import 'pagination.dart';
import 'model_next_page.dart';

class AbstractPaginationRepository<D extends Jsonable, P, C>
    extends PaginatedRepository<D, P>
    implements ApiRepository<C> {
  @override
  final C controller;
  final String Function(P p) keyBuilder;
  final Future<Response<Pagination<D>>> Function(
    C controller,
    P param,
    NextPage page,
  )
  onRequest;
  Future<bool> Function(C controller, P param, DateTime lastUpdate)?
  shouldRequest;

  AbstractPaginationRepository({
    required super.cache,
    required this.controller,
    required this.onRequest,
    required this.keyBuilder,
    this.shouldRequest,
    super.autoRefresh = true,
    super.nextPage = const NextPage.page(),
  });

  @override
  String getKey(P p) => keyBuilder(p);

  @override
  Future<Response<Pagination<D>>> request(P param) =>
      onRequest(controller, param, nextPage);

  @override
  Future<bool> shouldUpdateCache(P param) async {
    if (shouldRequest != null) {
      final cacheDate = await getLastCacheUpdate(param);
      return await shouldRequest!(controller, param, cacheDate);
    }
    return super.shouldUpdateCache(param);
  }
}
