import 'package:flutter/foundation.dart';

class Config {
  final String domain;
  final bool encryption;

  const Config.all({required this.domain, this.encryption = !kDebugMode});

  static Config _instance = Config.all(
    domain: 'http://127.0.0.1:8080',
    encryption: false,
  );

  factory Config() => _instance;

  static set(Config config) {
    _instance = config;
  }
}
