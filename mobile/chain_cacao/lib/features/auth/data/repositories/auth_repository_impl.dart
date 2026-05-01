import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import '../../../../core/services/storage/local_storage_service.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implémentation du repository Auth.
/// Fait le pont entre la source de données (Data) et le contrat (Domain).
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final LocalStorageService localStorageService;

  AuthRepositoryImpl(this.remoteDataSource, this.localStorageService);

  @override
  Future<Either<String, User>> login(String email, String password) async {
    try {
      final authResponse = await remoteDataSource.login(email, password);
      
      // Persistance du token et des données utilisateur pour l'auto-login
      await localStorageService.saveToken(authResponse.token);
      await localStorageService.saveUserData(jsonEncode(authResponse.user.toJson()));
      
      // Conversion transparente du modèle Data vers l'entité Domaine
      return right(authResponse.user.toEntity());
    } catch (e) {
      // Gestion propre des erreurs remontées par la source de données
      return left(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
