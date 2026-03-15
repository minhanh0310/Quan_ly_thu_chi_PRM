import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class RememberMeService {
  static const _emailKey = 'remember_me_email';
  static const _passwordKey = 'remember_me_password';
  static const _providerKey = 'remember_me_provider'; // 'email' or 'google'
  static const _googleEmailKey = 'remember_me_google_email';

  static final RememberMeService _instance = RememberMeService._internal();

  late final FlutterSecureStorage _secureStorage;

  RememberMeService._internal() {
    _secureStorage = const FlutterSecureStorage(
      aOptions: AndroidOptions(
        keyCipherAlgorithm:
            KeyCipherAlgorithm.RSA_ECB_OAEPwithSHA_256andMGF1Padding,
        storageCipherAlgorithm: StorageCipherAlgorithm.AES_GCM_NoPadding,
        resetOnError: true,
      ),
    );
  }

  factory RememberMeService() {
    return _instance;
  }

  /// Saves email and password securely for email/password auth
  Future<void> saveCredentials({
    required String email,
    required String password,
  }) async {
    try {
      await _secureStorage.write(key: _emailKey, value: email);
      await _secureStorage.write(key: _passwordKey, value: password);
      await _secureStorage.write(key: _providerKey, value: 'email');
    } catch (e) {
      print('Error saving credentials: $e');
      rethrow;
    }
  }

  /// Saves Google account email for Google Sign-In auth
  Future<void> saveGoogleAccount({required String email}) async {
    try {
      await _secureStorage.write(key: _googleEmailKey, value: email);
      await _secureStorage.write(key: _providerKey, value: 'google');
    } catch (e) {
      print('Error saving Google account: $e');
      rethrow;
    }
  }

  /// Retrieves saved credentials for email/password auth
  Future<({String email, String password})?> getCredentials() async {
    try {
      final email = await _secureStorage.read(key: _emailKey);
      final password = await _secureStorage.read(key: _passwordKey);

      if (email != null && password != null) {
        return (email: email, password: password);
      }
      return null;
    } catch (e) {
      print('Error retrieving credentials: $e');
      return null;
    }
  }

  /// Retrieves saved Google account email
  Future<String?> getGoogleAccountEmail() async {
    try {
      return await _secureStorage.read(key: _googleEmailKey);
    } catch (e) {
      print('Error retrieving Google account: $e');
      return null;
    }
  }

  /// Gets the auth provider type: 'email', 'google', or null
  Future<String?> getProviderType() async {
    try {
      return await _secureStorage.read(key: _providerKey);
    } catch (e) {
      print('Error retrieving provider type: $e');
      return null;
    }
  }

  /// Checks if credentials are saved
  Future<bool> hasCredentials() async {
    try {
      final email = await _secureStorage.read(key: _emailKey);
      final password = await _secureStorage.read(key: _passwordKey);
      return email != null && password != null;
    } catch (e) {
      print('Error checking credentials: $e');
      return false;
    }
  }

  /// Checks if Google account is saved
  Future<bool> hasGoogleAccount() async {
    try {
      final email = await _secureStorage.read(key: _googleEmailKey);
      return email != null;
    } catch (e) {
      print('Error checking Google account: $e');
      return false;
    }
  }

  /// Clears saved credentials
  Future<void> clearCredentials() async {
    try {
      await _secureStorage.delete(key: _emailKey);
      await _secureStorage.delete(key: _passwordKey);
      await _secureStorage.delete(key: _providerKey);
      await _secureStorage.delete(key: _googleEmailKey);
    } catch (e) {
      print('Error clearing credentials: $e');
      rethrow;
    }
  }
}
