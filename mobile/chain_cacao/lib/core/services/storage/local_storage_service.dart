import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Service de stockage sécurisé pour les données sensibles (Tokens, etc.)
class LocalStorageService {
  final FlutterSecureStorage _storage = const FlutterSecureStorage();

  static const String _tokenKey = 'auth_token';
  static const String _userKey = 'user_data';

  /// Sauvegarde du token JWT
  Future<void> saveToken(String token) async {
    await _storage.write(key: _tokenKey, value: token);
  }

  /// Récupération du token JWT
  Future<String?> getToken() async {
    return await _storage.read(key: _tokenKey);
  }

  /// Suppression du token (Logout)
  Future<void> deleteToken() async {
    await _storage.delete(key: _tokenKey);
  }

  /// Sauvegarde des données utilisateur (JSON string)
  Future<void> saveUserData(String userDataJson) async {
    await _storage.write(key: _userKey, value: userDataJson);
  }

  /// Récupération des données utilisateur
  Future<String?> getUserData() async {
    return await _storage.read(key: _userKey);
  }

  /// Suppression de toutes les données (Clean logout)
  Future<void> clearAll() async {
    await _storage.deleteAll();
  }
}

final localStorageServiceProvider = Provider<LocalStorageService>((ref) {
  return LocalStorageService();
});
