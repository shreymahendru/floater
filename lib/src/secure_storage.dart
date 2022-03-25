import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'defensive.dart';
import 'extensions.dart';

/// Secure Storage
///
/// Used to [store] file, [retrieve] file, [delete] file and check a specific file belongs using [contains].
/// All these are done by passing the [key].
///
/// [FlutterSecureStorage] is implemented in [SecureStorageService] for additional security,
///  which encrypts and saves the [key] with the given [value].

abstract class SecureStorageService {
  Future<void> store(String key, String value);
  Future<String?> retrieve(String key);
  Future<void> delete(String key);
  Future<bool> contains(String key);
}

class FloaterSecureStorageService implements SecureStorageService {
  final _secureStorage = const FlutterSecureStorage();

  @override
  Future<void> store(String key, String value) async {
    given(key, "key").ensure((t) => key.isNotEmptyOrWhiteSpace);
    // given(value, "value").ensureHasValue();

    await this._secureStorage.write(key: key.trim(), value: value);
  }

  @override
  Future<String?> retrieve(String key) async {
    given(key, "key").ensure((t) => key.isNotEmptyOrWhiteSpace);

    return await this._secureStorage.read(key: key.trim());
  }

  @override
  Future<void> delete(String key) async {
    given(key, "key").ensure((t) => key.isNotEmptyOrWhiteSpace);

    await this._secureStorage.delete(key: key.trim());
  }

  Future<bool> contains(String key) async {
    given(key, "key").ensure((t) => key.isNotEmptyOrWhiteSpace);

    return this._secureStorage.containsKey(key: key);
  }
}
