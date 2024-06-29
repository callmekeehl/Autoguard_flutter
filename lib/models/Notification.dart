class Notification {
  final int notificationId;
  final int utilisateurId;
  final String message;
  final DateTime dateEnvoi;
  final bool lu;

  Notification({
    required this.notificationId,
    required this.utilisateurId,
    required this.message,
    required this.dateEnvoi,
    required this.lu,
  });

  // Factory method pour créer une instance de Notification à partir de JSON
  factory Notification.fromJson(Map<String, dynamic> json) {
    return Notification(
      notificationId: json['notificationId'],
      utilisateurId: json['utilisateurId'],
      message: json['message'],
      dateEnvoi: DateTime.parse(json[
          'dateEnvoi']), // Conversion de la date de chaîne ISO 8601 en DateTime
      lu: json['lu'],
    );
  }

  // Méthode pour convertir une instance de Notification en JSON
  Map<String, dynamic> toJson() {
    return {
      'notificationId': notificationId,
      'utilisateurId': utilisateurId,
      'message': message,
      'dateEnvoi': dateEnvoi
          .toIso8601String(), // Conversion de DateTime en chaîne ISO 8601 pour JSON
      'lu': lu,
    };
  }
}
