import 'package:json_annotation/json_annotation.dart';
import 'model_jsonable.dart';

typedef JsonFactory<T> = T Function(Map<String, dynamic> json);

class GenericConverter<T extends Jsonable>
    extends JsonConverter<T, Map<String, dynamic>> {
  const GenericConverter();

  static Map<Type, JsonFactory>? _convertors;
  static setConversions(Map<Type, JsonFactory> convertors){
    _convertors = convertors;
  }

  @override
  T fromJson(Map<String, dynamic> json) {
    if(_convertors == null){
      throw 'GenericConverter: Converters not set!';
    }
    final converter = _convertors![T];
    if(converter == null){
      throw 'Generic Converter: Converter for type $T not found!';
    }
    return converter(json);
  }

  @override
  Map<String, dynamic> toJson(T object) => object.toJson();
}
