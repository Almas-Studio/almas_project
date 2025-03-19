// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pagination_cursor.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CursorPagination<T> _$CursorPaginationFromJson<T extends Jsonable>(
  Map<String, dynamic> json,
) => CursorPagination<T>(
  nextCursor: json['next_cursor'] as String?,
  prevCursor: json['prev_cursor'] as String?,
  perPage: (json['per_page'] as num).toInt(),
  path: json['path'] as String,
  data:
      (json['data'] as List<dynamic>)
          .map((e) => GenericConverter<T>().fromJson(e as Map<String, dynamic>))
          .toList(),
  nextPageUrl: json['next_page_url'] as String?,
  prevPageUrl: json['prev_page_url'] as String?,
);

Map<String, dynamic> _$CursorPaginationToJson<T extends Jsonable>(
  CursorPagination<T> instance,
) => <String, dynamic>{
  'next_cursor': instance.nextCursor,
  'prev_cursor': instance.prevCursor,
  'per_page': instance.perPage,
  'path': instance.path,
  'next_page_url': instance.nextPageUrl,
  'prev_page_url': instance.prevPageUrl,
  'data': instance.data.map(GenericConverter<T>().toJson).toList(),
};
