import 'package:json_annotation/json_annotation.dart';
import 'api_converter.dart';
import 'model_jsonable.dart';
import 'pagination.dart';

part 'pagination_simple.g.dart';

@JsonSerializable(fieldRename: FieldRename.snake)
class SimplePagination<T extends Jsonable> implements Pagination<T> {
  final int currentPage;
  final int? from;
  final int? to;
  final int perPage;
  final String path;
  final String? nextPageUrl;
  @override
  @GenericConverter()
  final List<T> data;

  const SimplePagination({
    required this.currentPage,
    required this.from,
    required this.to,
    required this.perPage,
    required this.path,
    required this.data,
    required this.nextPageUrl,
  });

  static const fromJson = _$SimplePaginationFromJson;

  @override
  bool get hasNextPage => nextPageUrl != null;

  Map<String, dynamic> toJson() => _$SimplePaginationToJson(this);

  @override
  String? get next => hasNextPage ? (currentPage + 1).toString() : null;
}
