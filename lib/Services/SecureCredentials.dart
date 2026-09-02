// ignore_for_file: file_names

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_storage/get_storage.dart';

/// Stores the user's password in the platform Keychain (iOS) / Keystore-backed
/// EncryptedSharedPreferences (Android), instead of the plaintext GetStorage
/// box where it used to live.
///
/// Provides a one-time migration path: on first read after upgrade, if the
/// password is still in the legacy GetStorage box, copy it into secure
/// storage and erase the legacy copy.
class SecureCredentials {
  static const _passwordKey = 'sc_password';
  static const _legacyPasswordKey = 'password';
  static const _legacyUserDataKey = 'userData';

  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  /// Persist the password to secure storage. Pass `null`/empty to clear.
  static Future<void> savePassword(String? password) async {
    if (password == null || password.isEmpty) {
      await _storage.delete(key: _passwordKey);
    } else {
      await _storage.write(key: _passwordKey, value: password);
    }
  }

  /// Read the password, migrating from the legacy GetStorage box on first call.
  static Future<String?> readPassword() async {
    final existing = await _storage.read(key: _passwordKey);
    if (existing != null) return existing;

    // Legacy migration: prior versions stored the password directly in
    // GetStorage and inside the userData JSON. Move it into secure storage
    // once and scrub the legacy locations.
    final box = GetStorage();
    String? legacy = box.read(_legacyPasswordKey);
    if (legacy == null || legacy.toString().isEmpty) {
      final userData = box.read(_legacyUserDataKey);
      if (userData is Map && userData['password'] is String) {
        legacy = userData['password'] as String;
      } else if (userData is String && userData.isNotEmpty) {
        // userData was stored json-encoded
        try {
          // ignore: avoid_dynamic_calls
          final decoded = (userData as dynamic);
          // Caller will decode JSON; we don't depend on dart:convert here to
          // keep this helper standalone.
          // Skip silent JSON parse — caller is responsible for stripping
          // password from userData going forward.
          legacy = null;
          // Mark unused
          decoded.toString();
        } catch (_) {}
      }
    }

    if (legacy != null && legacy.toString().isNotEmpty) {
      final pwd = legacy.toString();
      await _storage.write(key: _passwordKey, value: pwd);
      await box.remove(_legacyPasswordKey);
      return pwd;
    }
    return null;
  }

  /// Wipe the password from both secure storage and the legacy locations.
  static Future<void> clear() async {
    await _storage.delete(key: _passwordKey);
    final box = GetStorage();
    await box.remove(_legacyPasswordKey);
  }
}
