import 'package:fpdart/fpdart.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

/// Cas d'utilisation pour la connexion d'un utilisateur.
/// Contient la logique métier pure et appelle le repository.
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<Either<String, User>> call(String email, String password) async {
    // Logique métier : validations primaires
    if (email.isEmpty || !email.contains('@')) {
      return left('Veuillez entrer un email valide.');
    }
    if (password.isEmpty) {
      return left('Le mot de passe ne peut pas être vide.');
    }
    if (password.length < 6) {
      return left('Le mot de passe doit contenir au moins 6 caractères.');
    }

    // Appel au repository pour la suite du traitement
    return await repository.login(email, password);
  }
}
