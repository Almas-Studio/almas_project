import 'package:flutter/foundation.dart';

class Config {
  final String deepLinkDomain;
  final bool encryption;

  const Config.all({required this.deepLinkDomain, this.encryption = !kDebugMode});

  static Config _instance = Config.all(
    deepLinkDomain: 'undefined.app',
    encryption: false,
  );

  factory Config() => _instance;

  static set(Config config) {
    _instance = config;
  }
}
