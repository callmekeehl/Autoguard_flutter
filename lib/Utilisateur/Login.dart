import 'dart:convert';
import 'package:autoguard_flutter/Utilisateur/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../Clipper.dart';
import '../Colors_code.dart';
import '../Type.dart';
import '../Constant.dart';
import 'package:autoguard_flutter/Admin/HomeAdmin.dart';
import 'package:autoguard_flutter/Police/HomePolice.dart';
import 'package:autoguard_flutter/Garage/HomeGarage.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  // Fonction pour gérer la connexion
  Future<void> _login() async {
    final String email = emailController.text;
    final String password = passwordController.text;

    if (email.isEmpty || password.isEmpty) {
      _showErrorDialog("Veuillez remplir tous les champs.");
      return;
    }

    // URL du backend Flask
    const String _baseUrl = '$url/api/login';

    try {
      // Envoi de la requête HTTP POST pour l'authentification
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'motDePasse': password}),
      );

      if (response.statusCode == 200) {
        // Connexion réussie, stocker le token ou les informations de l'utilisateur
        final Map<String, dynamic> responseData = jsonDecode(response.body);

        // Vérifiez si le token est présent et non null
        final token = responseData['token'];
        if (token == null) {
          _showErrorDialog("Token absent dans la réponse.");
          return;
        }

        print(response.body); // Affiche la réponse brute de l'API
        print(responseData); // Affiche le mappage JSON décode
        print(token); // Affiche le token

        // Extraire les informations de l'utilisateur
        final user = responseData['user'];

        print(user); // Affiche les informations de l'utilisateur

        // Vérifier si l'objet 'user' est présent dans la réponse
        if (user == null) {
          _showErrorDialog(
              "Informations utilisateur absentes dans la réponse.");
          return;
        }

        // Enregistrer le token localement pour l'utiliser dans l'application
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('authToken', token);
        prefs.setString('userNom', user['nom'] ?? 'Non disponible');
        prefs.setString('userPrenom', user['prenom'] ?? 'Non disponible');
        prefs.setString('userEmail', user['email'] ?? 'Non disponible');
        prefs.setString('userAdresse', user['adresse'] ?? 'Non disponible');
        prefs.setString('userTelephone', user['telephone'] ?? 'Non disponible');

        // Ajout des champs pour le département et le garage
        prefs.setString(
            'nomDepartement', user['nomDepartement'] ?? 'Non disponible');
        prefs.setString('adresseDepartement',
            user['adresseDepartement'] ?? 'Non disponible');

        prefs.setString('nomGarage', user['nomGarage'] ?? 'Non disponible');
        prefs.setString(
            'adresseGarage', user['adresseGarage'] ?? 'Non disponible');

        // Afficher un message de succès (en bas de l'écran)
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Connexion Réussie!'),
          backgroundColor: Colors.green,
        ));

        // Naviguer vers l'écran principal
        // Vérifier le type de l'utilisateur et rediriger en conséquence
        switch (user['type']) {
          case 'admin':
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeAdmin()));
            break;
          case 'police':
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomePolice()));
            break;
          case 'garage':
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => HomeGarage()));
            break;
          default:
            Navigator.pushReplacement(
                context, MaterialPageRoute(builder: (_) => Home()));
        }
      } else {
        // Afficher une erreur si la connexion a échoué
        _showErrorDialog(
            "Erreur de connexion. Veuillez vérifier vos informations.");
      }
    } catch (e) {
      // Gérer toute autre exception possible
      _showErrorDialog("Une erreur est survenue: ${e.toString()}");
    }
  }

  // Fonction pour afficher une boîte de dialogue d'erreur
  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Erreur"),
        content: Text(message),
        actions: <Widget>[
          TextButton(
            child: Text("OK"),
            onPressed: () {
              Navigator.of(ctx).pop();
            },
          )
        ],
      ),
    );
  }

  // Widgets pour les champs de texte
  Widget _buildEmail() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez votre Email";
          }
          return null;
        },
        controller: emailController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.email_outlined), // Icone d'email
            hintText: "Entrer votre email"),
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
      child: TextFormField(
        obscureText: true, // Masquer le mot de passe
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez votre Mot de passe";
          }
          return null;
        },
        controller: passwordController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.lock_outline_rounded), // Icone de verrou
            hintText: "Entrer votre Mot de passe"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: Colors.blue.shade100,
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              children: [
                CustomPaint(
                  size: Size(media.width, 250),
                  painter: RPSCustomPainter(),
                ),
                Positioned(
                    top: 16,
                    right: -5,
                    child: CustomPaint(
                      size: Size(media.width, 250),
                      painter: PSCustomPainter(),
                    )),
                Positioned(
                    top: 220,
                    left: 30,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Connexion",
                          style: TextStyle(
                              fontWeight: FontWeight.w800, fontSize: 26),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          "Veuillez vous connecter pour continuer.",
                          style: TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 17),
                        )
                      ],
                    ))
              ],
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 25,
                  ),
                  _buildEmail(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildPassword(),
                  SizedBox(
                    height: 20,
                  ),
                  Text("Mot de passe oublié ?",
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Tcolor.primaryColor3)),
                  SizedBox(
                    height: 20,
                  ),
                  InkWell(
                    onTap: _login, // Ajout du gestionnaire de connexion
                    child: Container(
                      height: 50,
                      width: 150,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          gradient: LinearGradient(
                              colors: [Color(0xff9DCEFF), Color(0xff60b3dc)])),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "Connexion",
                            style: TextStyle(
                                fontWeight: FontWeight.w900,
                                fontSize: 17,
                                color: Colors.white),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 150,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Pas de compte ? ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Type()));
                        },
                        child: Text(
                          "Créer un",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Tcolor.primaryColor3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                      height:
                          30), // Espace supplémentaire pour éviter le recouvrement par le clavier
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
