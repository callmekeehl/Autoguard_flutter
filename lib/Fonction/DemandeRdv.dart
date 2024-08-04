import 'package:autoguard_flutter/Constant.dart';
import 'package:autoguard_flutter/Utilisateur/Home.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class DemandeRdv extends StatefulWidget {
  @override
  _DemandeRdvState createState() => _DemandeRdvState();
}

class _DemandeRdvState extends State<DemandeRdv> {
  int? userId;
  String? nom;
  String? prenom;
  String? email;
  String? adresse;
  String? telephone;
  final _formKey = GlobalKey<FormState>();
  TextEditingController _motifController = TextEditingController();

  Future<void> _submitForm() async {
    if (_formKey.currentState?.validate() ?? false) {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? token = prefs.getString('authToken');

      if (token == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
              content: Text(
                  'Vous devez être connecté pour soumettre une demande de rendez-vous.')),
        );
        return;
      }

      String motif = _motifController.text;

      final response = await http.post(
        Uri.parse('$url/api/motifs'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'utilisateurId': userId,
          'motifDescription': motif,
        }),
      );

      if (response.statusCode == 201) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Demande de rendez-vous soumise avec succès.'),
            backgroundColor: Colors.green,
          ),
        );
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Home()));
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
                'Erreur lors de la soumission de la demande de rendez-vous.'),
            backgroundColor: Colors.red.shade500,
          ),
        );
      }
    }
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userId = (prefs.getInt('utilisateurId') ?? 'Non disponible') as int?;
      nom = prefs.getString('userNom') ?? 'Non disponible';
      prenom = prefs.getString('userPrenom') ?? 'Non disponible';
      email = prefs.getString('userEmail') ?? 'Non disponible';
      adresse = prefs.getString('userAdresse') ?? 'Non disponible';
      telephone = prefs.getString('userTelephone') ?? 'Non disponible';
    });
  }

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.blue.shade800,
                Colors.blue.shade400,
              ],
              begin: Alignment.topLeft,
              end: Alignment.centerRight,
            ),
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                    vertical: 36.0, horizontal: 24.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Demande de Rendez-vous",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32.0,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    SizedBox(height: 9.0),
                    Text(
                      "Remplissez le formulaire pour continuer",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15.0,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextFormField(
                          controller: _motifController,
                          decoration: InputDecoration(
                            labelText: 'Motif',
                            icon: Icon(Icons.note),
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Veuillez entrer un motif';
                            }
                            return null;
                          },
                        ),
                        SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: _submitForm,
                          child: Text(
                            'Soumettre la demande',
                            style: TextStyle(color: Colors.white),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
