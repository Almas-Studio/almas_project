import 'package:cross_file/cross_file.dart';
import 'package:dio/dio.dart';
import 'package:http_parser/http_parser.dart';
import 'package:uuid/uuid.dart';

typedef Rs<T> = Future<Response<T>>;

abstract class ApiController {
  final Dio client;
  final Uri base;

  const ApiController(this.client, this.base);

  Rs<T> get<T>({
    String path = '',
    Map<String, dynamic> query = const {},
  }) async {
    final res = await client.get<T>(
      base.path + path,
      queryParameters: _removeNull(query),
    );

    return res;
  }

  Rs<T> post<T>({
    String path = '',
    Map<String, dynamic> query = const {},
    Object? body,
  }) {
    return client.post<T>(
      base.path + path,
      queryParameters: _removeNull(query),
      data: body,
    );
  }

  Rs<T> multipart<T>({
    required String path,
    Map<String, dynamic> query = const {},
    required Map<String, dynamic> body,
    bool retry = false,
  }) async {
    // convert files & remove nulls
    final transformedBody = <String, dynamic>{};
    for (var key in body.keys) {
      final value = body[key];
      if (value case XFile file) {
        transformedBody[key] = MultipartFile.fromBytes(
          await file.readAsBytes(),
          filename: const Uuid().v4(),
          contentType: MediaType.parse(file.mimeType ?? '*/*'),
        );
      } else if (value != null) {
        transformedBody[key] = value;
      }
    }

    return await client.post<T>(
      base.path + path,
      options: Options(
        extra: {'retry': retry},
        receiveTimeout: const Duration(minutes: 10),
        sendTimeout: const Duration(minutes: 10),
      ),
      queryParameters: _removeNull(query),
      data: FormData.fromMap(transformedBody),
    );
  }

  Map<String, dynamic> _removeNull(Map<String, dynamic> map) {
    return Map<String, dynamic>.fromEntries(
      map.entries.where((entry) => entry.value != null),
    );
  }
}

extension Success<T> on Response<T> {
  bool get isSuccessful => (statusCode ?? 0) >= 200 && (statusCode ?? 0) < 300;
}
