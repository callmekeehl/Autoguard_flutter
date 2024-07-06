import 'package:autoguard_flutter/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AccountInfo extends StatefulWidget {
  @override
  _AccountInfoState createState() => _AccountInfoState();
}

class _AccountInfoState extends State<AccountInfo> {
  String? nom;
  String? prenom;
  String? email;
  String? adresse;
  String? telephone;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear(); // Effacer toutes les informations de l'utilisateur

    // Naviguer vers l'écran de connexion
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => Login()),
    );
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nom = prefs.getString('userNom') ?? 'Non disponible';
      prenom = prefs.getString('userPrenom') ?? 'Non disponible';
      email = prefs.getString('userEmail') ?? 'Non disponible';
      adresse = prefs.getString('userAdresse') ?? 'Non disponible';
      telephone = prefs.getString('userTelephone') ?? 'Non disponible';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Informations du Compte',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Colors.blue[400],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUserInfoRow('Nom', nom),
            _buildUserInfoRow('Prénom', prenom),
            _buildUserInfoRow('Email', email),
            _buildUserInfoRow('Adresse', adresse),
            _buildUserInfoRow('Téléphone', telephone),
            SizedBox(height: 280),
            Center(
              child: ElevatedButton(
                onPressed: _logout,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[500],
                ),
                child: Text(
                  'Deconnexion',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildUserInfoRow(String label, String? value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        children: [
          Text(
            '$label: ',
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          Text(
            value ?? 'Non disponible',
            style: TextStyle(fontSize: 18, fontStyle: FontStyle.italic),
          ),
        ],
      ),
    );
  }
}
