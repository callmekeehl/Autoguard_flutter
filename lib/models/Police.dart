import 'package:autoguard_flutter/models/utilisateur.dart';

class Police extends Utilisateur {
  final int policeId;
  final int utilisateurId;
  final String nomDepartement;
  final String adresseDepartement;

  Police({
    required this.policeId,
    required this.utilisateurId,
    required String nom,
    required String prenom,
    required String email,
    required String adresse,
    required String telephone,
    required String type,
    required this.nomDepartement,
    required this.adresseDepartement,
  }) : super(
          utilisateurId: utilisateurId,
          nom: nom,
          prenom: prenom,
          email: email,
          adresse: adresse,
          telephone: telephone,
          type: type,
        );

  // Factory method pour créer une instance de Police à partir de JSON
  factory Police.fromJson(Map<String, dynamic> json) {
    return Police(
      policeId: json['policeId'],
      utilisateurId: json['utilisateurId'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      type: json['type'],
      nomDepartement: json['nomDepartement'],
      adresseDepartement: json['adresseDepartement'],
    );
  }

  // Méthode pour convertir une instance de Police en JSON
  @override
  Map<String, dynamic> toJson() {
    final data =
        super.toJson(); // Appel à la méthode toJson de la classe parente
    data['policeId'] = policeId;
    data['utilisateurId'] = utilisateurId;
    data['nomDepartement'] = nomDepartement;
    data['adresseDepartement'] = adresseDepartement;
    return data;
  }
}
