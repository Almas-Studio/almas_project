import 'model_jsonable.dart';

abstract class Pagination<T extends Jsonable>{
  bool get hasNextPage;
  List<T> get data;
  String? get next;

  const Pagination();
}