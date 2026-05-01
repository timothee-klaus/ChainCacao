import 'package:fpdart/fpdart.dart';
import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_data_source.dart';

/// Implémentation du repository Auth.
/// Fait le pont entre la source de données (Data) et le contrat (Domain).
class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;

  AuthRepositoryImpl(this.remoteDataSource);

  @override
  Future<Either<String, User>> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      // Conversion transparente du modèle Data vers l'entité Domaine
      return right(userModel.toEntity());
    } catch (e) {
      // Gestion propre des erreurs remontées par la source de données
      return left(e.toString().replaceAll('Exception: ', ''));
    }
  }
}
