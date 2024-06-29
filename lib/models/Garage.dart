// Classe Garage qui étend Utilisateur
import 'package:autoguard_flutter/models/utilisateur.dart';

class Garage extends Utilisateur {
  final int garageId;
  final String nomGarage;
  final String adresseGarage;

  Garage({
    required this.garageId,
    required int utilisateurId,
    required String nom,
    required String prenom,
    required String email,
    required String adresse,
    required String telephone,
    required String type,
    required this.nomGarage,
    required this.adresseGarage,
  }) : super(
          utilisateurId: utilisateurId,
          nom: nom,
          prenom: prenom,
          email: email,
          adresse: adresse,
          telephone: telephone,
          type: type,
        );

  // Factory method pour créer une instance de Garage à partir de JSON
  factory Garage.fromJson(Map<String, dynamic> json) {
    return Garage(
      garageId: json['garageId'],
      utilisateurId: json['utilisateurId'],
      nom: json['nom'],
      prenom: json['prenom'],
      email: json['email'],
      adresse: json['adresse'],
      telephone: json['telephone'],
      type: json['type'],
      nomGarage: json['nomGarage'],
      adresseGarage: json['adresseGarage'],
    );
  }

  // Méthode pour convertir une instance de Garage en JSON
  @override
  Map<String, dynamic> toJson() {
    final data = super.toJson();
    data['garageId'] = garageId;
    data['nomGarage'] = nomGarage;
    data['adresseGarage'] = adresseGarage;
    return data;
  }
}
