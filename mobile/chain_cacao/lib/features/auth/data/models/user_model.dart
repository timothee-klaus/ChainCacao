import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.userId,
    required super.email,
    required super.telephone,
    required super.nomAffiche,
    required super.roles,
    super.actorId,
    required super.statut,
    required super.dateCreation,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      userId: json['userId'] as String,
      email: json['email'] as String,
      telephone: json['telephone'] as String,
      nomAffiche: json['nomAffiche'] as String,
      roles: List<String>.from(json['roles'] as List),
      actorId: json['actorId'] as String?,
      statut: json['statut'] as String,
      dateCreation: DateTime.parse(json['dateCreation'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'email': email,
      'telephone': telephone,
      'nomAffiche': nomAffiche,
      'roles': roles,
      'actorId': actorId,
      'statut': statut,
      'dateCreation': dateCreation.toIso8601String(),
    };
  }

  /// Convertit le modèle Data en Entité Domaine pure.
  User toEntity() {
    return User(
      userId: userId,
      email: email,
      telephone: telephone,
      nomAffiche: nomAffiche,
      roles: roles,
      actorId: actorId,
      statut: statut,
      dateCreation: dateCreation,
    );
  }
}
