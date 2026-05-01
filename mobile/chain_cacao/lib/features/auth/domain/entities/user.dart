class User {
  final String userId;
  final String email;
  final String telephone;
  final String nomAffiche;
  final List<String> roles;
  final String? actorId;
  final String statut;
  final DateTime dateCreation;

  const User({
    required this.userId,
    required this.email,
    required this.telephone,
    required this.nomAffiche,
    required this.roles,
    this.actorId,
    required this.statut,
    required this.dateCreation,
  });
}
