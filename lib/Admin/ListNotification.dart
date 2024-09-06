import 'package:flutter/material.dart';

class ListNotification extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Liste des Notifications'),
        backgroundColor: Colors.blue.shade400,
      ),
      body: ListView.builder(
        itemCount: 10, // Remplacez par le nombre réel de notifications
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(
                'Notification $index'), // Remplacez par les données réelles
            subtitle: Text(
                'Détails de la notification $index'), // Remplacez par les données réelles
          );
        },
      ),
    );
  }
}
