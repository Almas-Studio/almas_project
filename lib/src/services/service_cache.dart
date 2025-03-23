import 'package:almas_project/src/config.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:prefman/prefman.dart';
import 'secure_store/service_secure_store.dart';
import 'service.dart';

class CacheService extends AppService implements SecureBox {
  late final SecureBox _box;

  String get namespace => 'services.cache';

  final _version = Preference.integer(
    key: 'services.cache.version',
    defaultValue: 0,
  );

  @override
  Future<void> run(ServiceContainer services) async {
    final ss = services.get<SecureStoreService>();

    // get store
    _box = await ss.getBox(namespace);

    // check cache version
    if (await _hasJustUpdated()) {
      await clear();
      _updateCacheVersion();
    }
  }

  Future<bool> _hasJustUpdated() async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = int.parse(info.buildNumber);
    final cacheVersion = _version.get();
    return currentVersion > cacheVersion;
  }

  Future<void> _updateCacheVersion() async {
    final info = await PackageInfo.fromPlatform();
    final currentVersion = int.parse(info.buildNumber);
    _version.setValue(currentVersion);
  }

  @override
  T get<T>(String key, {T? defaultValue}) =>
      _box.get(key, defaultValue: defaultValue);

  @override
  Future<void> put(String key, value) => _box.put(key, value);

  @override
  Future<void> delete(String key) => _box.delete(key);

  @override
  Future<void> clear() async {
    await _box.clear();
  }

  @override
  Iterable<String> keys() => _box.keys();

  @override
  bool get encryptKeys => Config.get().encryption;
}
