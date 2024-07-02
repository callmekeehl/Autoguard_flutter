import 'dart:convert';
import 'package:autoguard_flutter/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Clipper.dart';
import 'Colors_code.dart';
import 'Sign.dart';
import 'Constant.dart'; // Assurez-vous que ce fichier contient votre constante `url`

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

        // Enregistrer le token localement pour l'utiliser dans l'application
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('authToken', token);

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Connexion Réussie!'),
          backgroundColor: Colors.green,
        ));

        // Naviguer vers l'écran principal ou tableau de bord
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Home()));
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
                              MaterialPageRoute(builder: (_) => Sign()));
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
