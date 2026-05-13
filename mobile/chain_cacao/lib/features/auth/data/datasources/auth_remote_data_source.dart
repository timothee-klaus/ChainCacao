import 'package:dio/dio.dart';
import '../models/user_model.dart';

/// Source de données distante pour l'authentification.
abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final Dio dio;

  AuthRemoteDataSourceImpl(this.dio);

  @override
  Future<UserModel> login(String email, String password) async {
    try {
      final response = await dio.post('/auth/login', data: {
        'email': email,
        'password': password,
      });

      if (response.statusCode == 200) {
        return UserModel.fromJson(response.data as Map<String, dynamic>);
      } else {
        throw Exception('Identifiants invalides ou erreur serveur.');
      }
    } on DioException catch (e) {
      final message = e.response?.data?['detail'] ?? 'Erreur lors de la connexion au serveur.';
      throw Exception(message);
    }
  }
}
