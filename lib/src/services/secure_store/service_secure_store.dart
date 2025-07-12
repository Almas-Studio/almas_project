import 'dart:developer';
import 'dart:math' hide log;

import 'package:almas_project/src/config.dart';
import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage_x/flutter_secure_storage_x.dart';
import 'package:hash/hash.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:prefman/prefman.dart';

import '../service.dart';
import 'prefman_hive_driver.dart';
import 'secure_box.dart';

export 'secure_box.dart';
export 'secure_box_lazy.dart';

class SecureStoreService extends AppService {
  late Encrypter _keyEncrypter;
  late HiveCipher? _boxEncryption;

  @override
  Future<void> run(ServiceContainer services) async {
    await Hive.initFlutter();
    final appKey = await _getAppKey();
    final dataKey = _generateSecureStoreKey(appKey, [15, 32, 45, 87]);

    _keyEncrypter = Encrypter(AES(Key.fromUtf8(appKey), mode: AESMode.ecb));
    _boxEncryption = Config.get().encryption ? HiveAesCipher(dataKey) : null;

    PrefMan.setDriver(HivePrefManDriver(await getBox('prefman')));
  }

  List<int> _generateSecureStoreKey(String seedKey, List<int> salt) {
    final encryption = SHA256();
    encryption.update(seedKey.codeUnits);
    encryption.update(salt);
    encryption.update([Random(salt[0]).nextInt(salt[3])]);
    final key = encryption.digest().toList();
    return key;
  }

  Future<SecureBox> getBox(
    String namespace, {
    bool encrypted = true,
  }) async {
    late Box box;
    final boxName = 'memebox.$namespace${encrypted ? '.encrypted' : ''}';
    try {
      box = await Hive.openBox(boxName, encryptionCipher: encrypted ? _boxEncryption : null);
    } catch (e) {
      await Hive.deleteBoxFromDisk(boxName);
      box = await Hive.openBox(boxName, encryptionCipher: encrypted ? _boxEncryption : null);
      log('open error');
    }
    return SecureBox(
      store: box,
      keyEncryptor: _keyEncrypter,
      encryptKeys: encrypted && Config.get().encryption,
    );
  }

  String _generateRandomKey(int length) {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    final rnd = Random.secure();
    return String.fromCharCodes(
      Iterable.generate(
        length,
        (_) => chars.codeUnitAt(
          rnd.nextInt(chars.length),
        ),
      ),
    );
  }

  Future<String> _getAppKey() async {
    final key = String.fromCharCodes(
        [101, 110, 99, 114, 121, 112, 116, 105, 111, 110, 95, 107, 101, 121]);
    const fss = FlutterSecureStorage(
      aOptions: AndroidOptions(dataStore: true),
    );

    if (await fss.containsKey(key: key)) {
      return await fss.read(key: key).then((v) => v ?? key);
    }

    final baseKey = _generateRandomKey(32);
    await fss.write(key: key, value: baseKey);
    return baseKey;
  }
}
