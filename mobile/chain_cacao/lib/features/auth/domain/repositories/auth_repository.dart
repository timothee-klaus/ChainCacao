import 'package:fpdart/fpdart.dart';
import '../entities/user.dart';

/// Interface abstraite définissant le contrat pour l'authentification.
/// Située dans le domaine, elle ne dépend d'aucune implémentation concrète.
abstract class AuthRepository {
  Future<Either<String, User>> login(String email, String password);
}
