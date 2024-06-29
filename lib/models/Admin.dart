import 'package:autoguard_flutter/models/utilisateur.dart';

class Admin extends Utilisateur {
  final int adminId;

  Admin({
    required this.adminId,
    required int utilisateurId,
    required String nom,
    required String prenom,
    required String email,
    required String adresse,
    required String telephone,
    required String type,
  }) : super(
          utilisateurId: utilisateurId,
          nom: nom,
          prenom: prenom,
          email: email,
          adresse: adresse,
          telephone: telephone,
          type: type,
        );

  // Factory method pour créer une instance de Admin à partir de JSON
  factory Admin.fromJson(Map<String, dynamic> json) {
    return Admin(
      adminId: json['adminId'],
      utilisateurId: json['utilisateurId'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      type: json['type'],
    );
  }

  // Méthode pour convertir une instance de Admin en JSON
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['adminId'] = adminId;
    return data;
  }
}
