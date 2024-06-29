class Rdv {
  final int rdvId;
  final int utilisateurId;
  final int policeId;
  final DateTime date;
  final String motif;

  Rdv({
    required this.rdvId,
    required this.utilisateurId,
    required this.policeId,
    required this.date,
    required this.motif,
  });

  // Factory method pour créer une instance de Rdv à partir de JSON
  factory Rdv.fromJson(Map<String, dynamic> json) {
    return Rdv(
      rdvId: json['rdvId'],
      utilisateurId: json['utilisateurId'],
      policeId: json['policeId'],
      date: DateTime.parse(
          json['date']), // Parsing la date depuis une chaîne JSON
      motif: json['motif'],
    );
  }

  // Méthode pour convertir une instance de Rdv en JSON
  Map<String, dynamic> toJson() {
    return {
      'rdvId': rdvId,
      'utilisateurId': utilisateurId,
      'policeId': policeId,
      'date': date
          .toIso8601String(), // Convertir DateTime en ISO 8601 string pour JSON
      'motif': motif,
    };
  }
}
