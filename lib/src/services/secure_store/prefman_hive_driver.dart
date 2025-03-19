import 'package:prefman/prefman.dart';

import 'secure_box.dart';

class HivePrefManDriver extends PrefManDriver {
  final SecureBox _store;

  HivePrefManDriver(this._store);

  @override
  T? get<T>(String key) {
    return _store.get(key, defaultValue: null);
  }

  @override
  Future<bool> remove(String key) async {
    await _store.delete(key);
    return true;
  }

  @override
  Future<bool> set(String key, value) async {
    await _store.put(key, value);
    return true;
  }
}
