import 'package:autoguard_flutter/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token == null) {
      // Si aucun jeton n'est trouvé, redirigez vers la page de connexion
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (_) => Login()));
    } else {
      // Vous pouvez également ajouter une vérification du jeton ici
      // par exemple, appeler une API protégée avec le jeton
    }
  }

  @override
  Widget build(BuildContext context) {
    // Construisez l'interface utilisateur de la page Home ici
    return Scaffold(
      appBar: AppBar(
        title: Text("Accueil"),
        leading: Image.asset("./assets/images/icon.png"),
      ),
      body: Center(
        child: Text("Bienvenue à la page d'accueil!"),
      ),
    );
  }
}
