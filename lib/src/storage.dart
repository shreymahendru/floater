import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:meta/meta.dart';
import 'defensive.dart';

@sealed
abstract class StorageService {
  static final _instance = new _SecureStorageService();

  static StorageService get instance => _instance;

  Future<void> store(String key, String value);
  Future<String> retrieve(String key);
  Future<void> delete(String key);
}

class _SecureStorageService implements StorageService {
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> store(String key, String value) async {
    given(key, "key").ensureHasValue();
    given(value, "value").ensureHasValue();

    await this._secureStorage.write(key: key.trim(), value: value);
  }

  @override
  Future<String> retrieve(String key) async {
    given(key, "key").ensureHasValue();

    return await this._secureStorage.read(key: key.trim());
  }

  @override
  Future<void> delete(String key) async {
    given(key, "key").ensureHasValue();

    await this._secureStorage.delete(key: key.trim());
  }
}
