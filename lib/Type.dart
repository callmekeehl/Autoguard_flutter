import 'package:autoguard_flutter/Garage/GarageSign.dart';
import 'package:autoguard_flutter/Police/PoliceSign.dart';
import 'package:autoguard_flutter/Utilisateur/Login.dart';
import 'package:flutter/material.dart';
import 'Utilisateur/Sign.dart';

class Type extends StatefulWidget {
  const Type({super.key});

  @override
  State<Type> createState() => _TypeState();
}

class _TypeState extends State<Type> {
  @override
  Widget build(BuildContext context) {
    final media = MediaQuery.of(context).size;

    return Scaffold(
        backgroundColor: Colors.blue[200],
        body: SingleChildScrollView(
          child: Column(children: [
            SizedBox(
              height: 100,
            ),
            Image.asset(
              './assets/images/icon.png',
              height: media.height / 6,
            ),
            SizedBox(
              height: 50,
              child: Text(
                "Type de compte",
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 26),
              ),
            ),
            SizedBox(
              height: 30,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => Sign()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 20,
                    padding: EdgeInsets.only(left: 26, right: 26)),
                child: Text(
                  'Utilisateur Simple',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => PoliceSign()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 20,
                    padding: EdgeInsets.only(left: 10, right: 10)),
                child: Text(
                  'Departement Policier',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            SizedBox(
              height: 50,
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.push(
                      context, MaterialPageRoute(builder: (_) => GarageSign()));
                },
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    elevation: 20,
                    padding: EdgeInsets.only(left: 76, right: 76)),
                child: Text(
                  'Garage',
                  style: TextStyle(color: Colors.white, fontSize: 20),
                )),
            SizedBox(
              height: 50,
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
                    Navigator.push(
                        context, MaterialPageRoute(builder: (_) => Login()));
                  },
                  child: Text(
                    "Connexion",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: Colors.blue.shade700),
                  ),
                ),
              ],
            ),
          ]),
        ));
  }
}
