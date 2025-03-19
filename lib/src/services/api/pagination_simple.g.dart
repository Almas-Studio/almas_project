// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_simple.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SimplePagination<T> _$SimplePaginationFromJson<T extends Jsonable>(
  Map<String, dynamic> json,
) => SimplePagination<T>(
  currentPage: (json['current_page'] as num).toInt(),
  from: (json['from'] as num?)?.toInt(),
  to: (json['to'] as num?)?.toInt(),
  perPage: (json['per_page'] as num).toInt(),
  path: json['path'] as String,
  data:
      (json['data'] as List<dynamic>)
          .map((e) => GenericConverter<T>().fromJson(e as Map<String, dynamic>))
          .toList(),
  nextPageUrl: json['next_page_url'] as String?,
);

Map<String, dynamic> _$SimplePaginationToJson<T extends Jsonable>(
  SimplePagination<T> instance,
) => <String, dynamic>{
  'current_page': instance.currentPage,
  'from': instance.from,
  'to': instance.to,
  'per_page': instance.perPage,
  'path': instance.path,
  'next_page_url': instance.nextPageUrl,
  'data': instance.data.map(GenericConverter<T>().toJson).toList(),
};
