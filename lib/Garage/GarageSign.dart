import 'dart:convert';
import 'package:autoguard_flutter/Garage/HomeGarage.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:autoguard_flutter/Constant.dart';
import 'package:autoguard_flutter/Clipper.dart';
import 'package:autoguard_flutter/Colors_code.dart';
import 'package:autoguard_flutter/Utilisateur/Login.dart';

class GarageSign extends StatefulWidget {
  const GarageSign({Key? key}) : super(key: key);

  @override
  State<GarageSign> createState() => _GarageSignState();
}

class _GarageSignState extends State<GarageSign> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final surnameController = TextEditingController();
  final addressController = TextEditingController();
  final phoneController = TextEditingController();
  final nomGarageController = TextEditingController();
  final adresseGarageController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    // URL de l'API pour l'inscription du garage
    const String _registerUrl = '$url/api/garages';

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
          'motDePasse': passwordController.text,
          'nomGarage': nomGarageController.text,
          'adresseGarage': adresseGarageController.text
        }),
      );

      print('Status code: ${response.statusCode}');
      print('Response body: ${response.body}');

      if (response.statusCode == 201) {
        final responseData = jsonDecode(response.body);

        String? token = responseData['access_token'];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        if (token != null) {
          await prefs.setString('authToken', token);
        }
        await prefs.setString('userNom', nameController.text);
        await prefs.setString('userPrenom', surnameController.text);
        await prefs.setString('userEmail', emailController.text);
        await prefs.setString('userAdresse', addressController.text);
        await prefs.setString('userTelephone', phoneController.text);
        await prefs.setString('nomGarage', nomGarageController.text);
        await prefs.setString('adresseGarage', adresseGarageController.text);

        if (token == null) {
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(
            content: Text('Compte créé avec succès, mais le jeton est absent'),
            backgroundColor: Colors.orange,
          ));
        }

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Compte de garage créé avec succès!'),
          backgroundColor: Colors.green,
        ));

        Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (_) => HomeGarage()));
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _showErrorDialog(
            responseData['message'] ?? 'Erreur lors de la création du compte.');
      }
    } catch (e) {
      _showErrorDialog('Une erreur est survenue: ${e.toString()}');
    }
  }

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
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
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
            prefixIcon: Icon(Icons.email_outlined),
            hintText: "Entrer votre email"),
      ),
    );
  }

  Widget _buildAddress() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
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
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
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
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
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
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
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

  Widget _buildGarageName() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez le nom du garage";
          }
          return null;
        },
        controller: nomGarageController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.business_center),
            hintText: "Entrer le nom du garage"),
      ),
    );
  }

  Widget _buildGarageAddress() {
    return Container(
      height: 50,
      decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [BoxShadow(offset: Offset(3, 3), color: Colors.cyan)]),
      child: TextFormField(
        validator: (value) {
          if (value == null || value.isEmpty) {
            return "Entrez l'adresse du garage";
          }
          return null;
        },
        controller: adresseGarageController,
        decoration: InputDecoration(
            border: InputBorder.none,
            contentPadding: EdgeInsets.only(top: 14),
            prefixIcon: Icon(Icons.location_city),
            hintText: "Entrer l'adresse du garage"),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
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
                      top: 140,
                      left: 30,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Créer Compte Garage",
                            style: TextStyle(
                                fontWeight: FontWeight.w800, fontSize: 26),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            "Veuillez créer un compte pour continuer.",
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
                      _buildGarageName(),
                      SizedBox(
                        height: 20,
                      ),
                      _buildGarageAddress(),
                      SizedBox(
                        height: 20,
                      ),
                      Container(
                        height: 50,
                        width: 150,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            gradient: LinearGradient(colors: [
                              Color(0xff9DCEFF),
                              Color(0xff60b3dc)
                            ])),
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
