import 'dart:convert';
import 'package:almas_project/src/services/api/api_converter.dart';

import '../service_cache.dart';
import 'model_jsonable.dart';

abstract class CachedRepository<T extends Jsonable, P> {
  final CacheService cache;

  CachedRepository({
    required this.cache,
  });

  String getKey(P p) => '$T';

  Future<List<T>> retrieveFromCache(P p) async {
    final json = cache.get<String?>(getKey(p));
    if (json == null) return <T>[];
    T converter(j) => GenericConverter<T>().fromJson(j);
    final mapData = jsonDecode(json) as List;
    final data =
    mapData.cast<Map<String, dynamic>>().map(converter).toList().cast<T>();
    return data;
  }

  Future<void> saveToCache(List<T> data, P p) async {
    await cache.put(
        getKey(p), jsonEncode(data.map((e) => e.toJson()).toList()));
    await cache.put('time_${getKey(p)}', DateTime.now());
  }

  Future<DateTime> getLastCacheUpdate(P p) async =>
      (await cache.get('time_${getKey(p)}', defaultValue: DateTime(1)))!;
}