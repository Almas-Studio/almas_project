import 'package:copy_with_extension/copy_with_extension.dart';
import 'package:flutter/foundation.dart';

part 'config.g.dart';

@CopyWith()
class Config {
  final String deepLinkDomain;
  final bool encryption;

  const Config({
    required this.deepLinkDomain,
    this.encryption = !kDebugMode,
  });

  static Config _instance = Config(
    deepLinkDomain: 'undefined.app',
    encryption: false,
  );

  factory Config.get() => _instance;

  static set(Config config) {
    _instance = config;
  }
}
