class Declaration {
  final int declarationId;
  final int utilisateurId;
  final String nomProprio;
  final String prenomProprio;
  final String telephoneProprio;
  final String lieuLong;
  final String lieuLat;
  final String photoCarteGrise; // nullable, peut être null
  final String numChassis;
  final String numPlaque;
  final String marque;
  final String modele;
  final DateTime dateHeure;
  final int statut;

  // Constructeur
  Declaration({
    required this.declarationId,
    required this.utilisateurId,
    required this.nomProprio,
    required this.prenomProprio,
    required this.telephoneProprio,
    required this.lieuLong,
    required this.lieuLat,
    required this.photoCarteGrise,
    required this.numChassis,
    required this.numPlaque,
    required this.marque,
    required this.modele,
    required this.dateHeure,
    required this.statut,
  });

  // Factory method pour créer une instance de Declaration à partir de JSON
  factory Declaration.fromJson(Map<String, dynamic> json) {
    return Declaration(
      declarationId: json['declarationId'],
      utilisateurId: json['utilisateurId'],
      nomProprio: json['nomProprio'],
      prenomProprio: json['prenomProprio'],
      telephoneProprio: json['telephoneProprio'],
      lieuLong: json['lieuLong'],
      lieuLat: json['lieuLat'],
      photoCarteGrise: json['photoCarteGrise'],
      numChassis: json['numChassis'],
      numPlaque: json['numPlaque'],
      marque: json['marque'],
      modele: json['modele'],
      dateHeure: DateTime.parse(json[
          'dateHeure']), // Conversion de la date de chaîne ISO 8601 en DateTime
      statut: json['statut'],
    );
  }

  // Méthode pour convertir une instance de Declaration en JSON
  Map<String, dynamic> toJson() {
    return {
      'declarationId': declarationId,
      'utilisateurId': utilisateurId,
      'nomProprio': nomProprio,
      'prenomProprio': prenomProprio,
      'telephoneProprio': telephoneProprio,
      'lieuLong': lieuLong,
      'lieuLat': lieuLat,
      'photoCarteGrise': photoCarteGrise,
      'numChassis': numChassis,
      'numPlaque': numPlaque,
      'marque': marque,
      'modele': modele,
      'dateHeure': dateHeure
          .toIso8601String(), // Conversion de DateTime en chaîne ISO 8601 pour JSON
      'statut': statut,
    };
  }
}
