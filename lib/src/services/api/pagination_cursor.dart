import 'package:json_annotation/json_annotation.dart';

import 'api_converter.dart';
import 'model_jsonable.dart';
import 'pagination.dart';

part 'pagination_cursor.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class CursorPagination<T extends Jsonable> implements Pagination<T> {
  final String? nextCursor;
  final String? prevCursor;
  final int perPage;
  final String path;
  final String? nextPageUrl;
  final String? prevPageUrl;
  @override
  @GenericConverter()
  final List<T> data;

  const CursorPagination({
    required this.nextCursor,
    required this.prevCursor,
    required this.perPage,
    required this.path,
    required this.data,
    required this.nextPageUrl,
    required this.prevPageUrl,
  });

  static const fromJson = _$CursorPaginationFromJson;

  @override
  bool get hasNextPage => nextPageUrl != null;

  Map<String, dynamic> toJson() => _$CursorPaginationToJson(this);

  @override
  String? get next => nextCursor;
}
