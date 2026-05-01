import 'package:dio/dio.dart';
import '../models/auth_response.dart';
import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<AuthResponse> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<AuthResponse> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return AuthResponse.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Identifiants invalides ou erreur serveur.');
      }
    } on DioException catch (e) {
      // Gestion propre des erreurs Dio
      final message = e.response?.data?['detail'] ?? 'Erreur lors de la connexion au serveur.';
      throw Exception(message);
    }
  }
}

/// Implémentation Mock pour les tests sans Backend
class MockAuthRemoteDataSource implements AuthRemoteDataSource {
  @override
  Future<AuthResponse> login(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 1500));

    if (email.isNotEmpty && password.length >= 6) {
      return AuthResponse(
        token: 'mock_jwt_token_for_testing',
        user: UserModel(
          userId: '1',
          email: email,
          telephone: '+228 90 00 00 00',
          nomAffiche: 'Utilisateur Test',
          roles: ['Agriculteur'],
          statut: 'ACTIF',
          dateCreation: DateTime.now(),
        ),
      );
    } else {
      throw Exception('Identifiants invalides (Mock).');
    }
  }
}
