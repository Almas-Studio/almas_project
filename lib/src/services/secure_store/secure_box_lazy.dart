import 'package:encrypt/encrypt.dart';
import 'package:hive/hive.dart';

class LazySecureBox<E> {
  final String namespace;
  final LazyBox<E> _store;
  final Encrypter _encryptor;

  LazySecureBox({
    required this.namespace,
    required LazyBox<E> store,
    required Encrypter encryptor,
  })  : _store = store,
        _encryptor = encryptor;

  String _encryptKey(String key) {
    return key
        .split('.')
        .map(_encryptor.encrypt)
        .map((e) => e.base64)
        .join('.');
  }

  Future<E?> get(String key, {E? defaultValue}) {
    return _store.get(_encryptKey('$namespace.$key'),
        defaultValue: defaultValue);
  }

  Future<void> put(String key, value) async {
    await _store.put(_encryptKey('$namespace.$key'), value);
  }

  Future<void> delete(String key) async {
    await _store.delete(_encryptKey('$namespace.$key'));
  }

  Future<void> clear() async {
    final strKeys = _store.keys.whereType<String>();
    final toClear = strKeys.where((k) => k.startsWith(_encryptKey(namespace)));
    await _store.deleteAll(toClear);
  }
}
