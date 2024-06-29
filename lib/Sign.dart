import 'dart:convert';
import 'package:autoguard_flutter/Constant.dart';
import 'package:autoguard_flutter/Home.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autoguard_flutter/Login.dart';
import 'package:autoguard_flutter/Clipper.dart';
import 'package:autoguard_flutter/Colors_code.dart';

class Sign extends StatefulWidget {
  const Sign({Key? key}) : super(key: key);

  @override
  State<Sign> createState() => _SignState();
}

class _SignState extends State<Sign> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  // Fonction pour envoyer les données au backend et créer un nouvel utilisateur
  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      // Si le formulaire n'est pas valide, affichez une erreur.
      return;
    }

    // URL de l'API pour l'inscription (assurez-vous de définir votre `url` correctement dans `Constant.dart`)
    const String _registerUrl = '$url/api/utilisateurs';

    try {
      final response = await http.post(
        Uri.parse(_registerUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'nom': nameController.text,
          'prenom': surnameController.text,
          'email': emailController.text,
          'adresse': addressController.text,
          'telephone': phoneController.text,
          'motDePasse': passwordController.text
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        // Succès de l'inscription
        final responseData = jsonDecode(response.body);

        // Récupérer le jeton JWT
        String? token = responseData['access_token'];

        // Afficher unmessage d'avertissement mais avec l'inscription réussie
        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Compte créé avec succès, mais le jeton est absent'),
            backgroundColor: Colors.orange,
          ));
        }

        // Afficher un message de succès
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Compte créé avec succès!'),
          backgroundColor: Colors.green,
        ));

        // Naviguer vers la page de connexion
        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => Home()));
      } else {
        // Échec de l'inscription, afficher le message d'erreur
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _showErrorDialog(
            responseData['message'] ?? 'Erreur lors de la création du compte.');
      }
    } catch (e) {
      _showErrorDialog('Une erreur est survenue: ${e.toString()}');
    }
  }

  Future<void> fetchProtectedResource() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      final response = await http.get(
        Uri.parse('$url'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token'
        },
      );

      // Traitez la réponse comme nécessaire
    } else {
      // Gestion de l'absence de jeton
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

  Widget _buildName() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(3, 3),
        )
      ]),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez votre Nom";
          }
          return null;
        },
        controller: nameController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.person),
            hintText: "Entrer votre Nom"),
      ),
    );
  }

  Widget _buildSurname() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez votre prénom";
          }
          return null;
        },
        controller: surnameController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.person_outline),
            hintText: "Entrer votre prénom"),
      ),
    );
  }

  Widget _buildEmail() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(3, 3),
        )
      ]),
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
            prefixIcon: Icon(Icons.email_outlined),
            hintText: "Entrer votre email"),
      ),
    );
  }

  Widget _buildAddress() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(3, 3),
        )
      ]),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez votre adresse";
          }
          return null;
        },
        controller: addressController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.home_outlined),
            hintText: "Entrer votre adresse"),
      ),
    );
  }

  Widget _buildPhone() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(3, 3),
        )
      ]),
      child: TextFormField(
        keyboardType: TextInputType.phone,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez votre numéro de téléphone";
          }
          return null;
        },
        controller: phoneController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.phone),
            hintText: "Entrer votre téléphone"),
      ),
    );
  }

  Widget _buildPassword() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(3, 3),
        )
      ]),
      child: TextFormField(
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez votre mot de passe";
          }
          if (value.length < 6) {
            return "Le mot de passe doit contenir au moins 6 caractères";
          }
          return null;
        },
        controller: passwordController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.lock_outline_rounded),
            hintText: "Entrer votre mot de passe"),
      ),
    );
  }

  Widget _buildConfirmPassword() {
    return Container(
      height: 50,
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
          offset: Offset(3, 3),
        )
      ]),
      child: TextFormField(
        obscureText: true,
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Confirmez votre mot de passe";
          }
          if (value != passwordController.text) {
            return "Les mots de passe ne correspondent pas";
          }
          return null;
        },
        controller: confirmPasswordController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.lock),
            hintText: "Confirmez votre mot de passe"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
                  top: 140,
                  left: 30,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Créer Compte ",
                        style: TextStyle(
                            fontWeight: FontWeight.w800, fontSize: 26),
                      ),
                      SizedBox(
                        height: 5,
                      ),
                      Text(
                        "Veuillez creer un compte pour continuer.",
                        style: TextStyle(
                            fontWeight: FontWeight.w400, fontSize: 17),
                      )
                    ],
                  ))
            ],
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 28),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  SizedBox(
                    height: 20,
                  ),
                  _buildName(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildSurname(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildEmail(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildAddress(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildPhone(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildPassword(),
                  SizedBox(
                    height: 20,
                  ),
                  _buildConfirmPassword(),
                  SizedBox(
                    height: 20,
                  ),
                  Container(
                    height: 50,
                    width: 150,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        gradient: LinearGradient(
                            colors: [Color(0xff9DCEFF), Color(0xff60b3dc)])),
                    child: InkWell(
                      onTap: _register,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            "CREER",
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
                    height: 50,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Vous avez déjà un compte ? ",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Colors.black),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (_) => Login()));
                        },
                        child: Text(
                          "Connexion",
                          style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w400,
                              color: Tcolor.primaryColor3),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(
                    height: 50,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    ));
  }
}
