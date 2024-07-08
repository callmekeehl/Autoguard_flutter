import 'package:autoguard_flutter/Garage/GarageInfo.dart';
import 'package:autoguard_flutter/Utilisateur/Login.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomeGarage extends StatefulWidget {
  @override
  _HomeGarageState createState() => _HomeGarageState();
}

class _HomeGarageState extends State<HomeGarage> {
  @override
  void initState() {
    super.initState();
    _checkAuthentication();
  }

  Future<void> _checkAuthentication() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

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
        backgroundColor: Colors.blue[400],
        title: Text(
          "Autoguard",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: Image.asset("./assets/images/icon.png"),
        actions: [
          Row(
            children: [
              IconButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => GarageInfo()),
                  );
                },
                icon: Icon(
                  Icons.account_circle_outlined,
                  color: Colors.white,
                  size: 32,
                ),
              )
            ],
          )
        ],
      ),
      body: Center(
        child: Text("Bienvenue à la page d'accueil garage!"),
      ),
    );
  }
}
