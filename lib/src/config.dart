import 'package:flutter/foundation.dart';

class Config {
  final bool encryption;

  const Config.all({this.encryption = !kDebugMode});

  static Config _instance = Config.all(
    encryption: false,
  );

  factory Config() => _instance;

  static set(Config config) {
    _instance = config;
  }
}
