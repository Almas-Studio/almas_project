import 'dart:convert';

import 'package:encrypt/encrypt.dart';
import 'package:hive/hive.dart';

class SecureBox {
  final Box _store;
  final Encrypter _encryptor;
  final bool encryptKeys;

  SecureBox({
    required Box store,
    required Encrypter keyEncryptor,
    required this.encryptKeys,
  })  : _store = store,
        _encryptor = keyEncryptor;

  String _encryptKey(String key) {
    if (!encryptKeys) {
      return key;
    }
    return key
        .split('.')
        .map(_encryptor.encrypt)
        .map((e) => e.base64)
        .join('.');
  }

  String _decryptKey(String key) {
    if (!encryptKeys) {
      return key;
    }
    return key
        .split('.')
        .map(base64Decode)
        .map((b) => Encrypted(b))
        .map(_encryptor.decrypt)
        .join('.');
  }

  T get<T>(String key, {T? defaultValue}) {
    return _store.get(
      _encryptKey(key),
      defaultValue: defaultValue,
    ) as T;
  }

  Iterable<String> keys() {
    return _store.keys.cast<String>().map(_decryptKey);
  }

  Future<void> put(String key, value) async {
    await _store.put(_encryptKey(key), value);
  }

  Future<void> delete(String key) async {
    await _store.delete(_encryptKey(key));
  }

  Future<void> clear() => _store.clear();
}
