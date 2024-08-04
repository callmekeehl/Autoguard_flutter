import 'dart:convert';
import 'dart:io';
import 'package:autoguard_flutter/Constant.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class Signal extends StatefulWidget {
  @override
  _SignalState createState() => _SignalState();
}

class _SignalState extends State<Signal> {
  final nomProprioController = TextEditingController();
  final prenomProprioController = TextEditingController();
  final telephoneProprioController = TextEditingController();
  final lieuLongController = TextEditingController();
  final lieuLatController = TextEditingController();
  final numChassisController = TextEditingController();
  final numPlaqueController = TextEditingController();
  final marqueController = TextEditingController();
  final modeleController = TextEditingController();
  final dateHeureController = TextEditingController();

  File? _imageFile;
  String? _photoCarteGriseBase64;

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    setState(() {
      if (pickedFile != null) {
        _imageFile = File(pickedFile.path);
        _convertImageToBase64(_imageFile!);
      } else {
        print('No image selected.');
      }
    });
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        dateHeureController.text = picked.toLocal().toString().split(' ')[0];
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (picked != null) {
      setState(() {
        final now = DateTime.now();
        final dateTime =
            DateTime(now.year, now.month, now.day, picked.hour, picked.minute);
        dateHeureController.text += " " + picked.format(context);
      });
    }
  }

  Future<void> _convertImageToBase64(File imageFile) async {
    List<int> imageBytes = await imageFile.readAsBytes();
    _photoCarteGriseBase64 = base64Encode(imageBytes);
  }

  bool _validateFields() {
    if (nomProprioController.text.isEmpty ||
        prenomProprioController.text.isEmpty ||
        telephoneProprioController.text.isEmpty ||
        lieuLongController.text.isEmpty ||
        lieuLatController.text.isEmpty ||
        numChassisController.text.isEmpty ||
        numPlaqueController.text.isEmpty ||
        marqueController.text.isEmpty ||
        modeleController.text.isEmpty ||
        dateHeureController.text.isEmpty ||
        _photoCarteGriseBase64 == null) {
      _showErrorDialog(
          "Veuillez remplir tous les champs et sélectionner une photo de la carte grise.");
      return false;
    }
    return true;
  }

  Future<void> _submitDeclaration() async {
    if (!_validateFields()) {
      return;
    }
    final prefs = await SharedPreferences.getInstance();
    final utilisateurId = prefs
        .getInt('utilisateurId'); // Assurez-vous que l'utilisateurId est stocké

    if (utilisateurId == null) {
      _showErrorDialog("Utilisateur non identifié. Veuillez vous reconnecter.");
      return;
    }

    final declarationData = {
      'utilisateurId': utilisateurId,
      'nomProprio': nomProprioController.text,
      'prenomProprio': prenomProprioController.text,
      'telephoneProprio': telephoneProprioController.text,
      'lieuLong': lieuLongController.text,
      'lieuLat': lieuLatController.text,
      'photoCarteGrise': _photoCarteGriseBase64,
      'numChassis': numChassisController.text,
      'numPlaque': numPlaqueController.text,
      'marque': marqueController.text,
      'modele': modeleController.text,
      'dateHeure': dateHeureController.text,
      'statut': 0,
    };

    const String _baseUrl = '$url/api/declarations';

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(declarationData),
      );

      if (response.statusCode == 201) {
        // Corrigé pour le code de succès approprié
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Déclaration envoyée avec succès!'),
          backgroundColor: Colors.green,
        ));
        Navigator.pop(
            context); // Retour à l'écran précédent ou autre navigation
      } else {
        _showErrorDialog(
            "Erreur lors de l'envoi de la déclaration. Veuillez réessayer.");
      }
    } catch (e) {
      _showErrorDialog("Une erreur est survenue: ${e.toString()}");
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

  Widget _buildTextField(String hintText, TextEditingController controller,
      {bool obscureText = false}) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      decoration: InputDecoration(
        filled: true,
        fillColor: Color(0xFFE7EDEB),
        hintText: hintText,
        border: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(8.0),
        ),
      ),
    );
  }

  _buildDateTimeField(String hintText, TextEditingController controller) {
    return GestureDetector(
      onTap: () async {
        await _selectDate(context);
        await _selectTime(context);
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(
            filled: true,
            fillColor: Color(0xFFE7EDEB),
            hintText: hintText,
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
              borderRadius: BorderRadius.circular(8.0),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            maxWidth: media.width,
            maxHeight: media.height,
          ),
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
            mainAxisAlignment: MainAxisAlignment.end,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 36.0, horizontal: 24.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Signalement",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 42.0,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                      SizedBox(height: 5.0),
                      Text(
                        "Remplissez le formulaire pour continuer",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 15.0,
                          fontWeight: FontWeight.w400,
                        ),
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 5,
                child: Container(
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
                    child: ListView(
                      children: [
                        _buildTextField(
                            "Nom Propriétaire", nomProprioController),
                        SizedBox(height: 20.0),
                        _buildTextField(
                            "Prénom Propriétaire", prenomProprioController),
                        SizedBox(height: 20.0),
                        _buildTextField("Téléphone Propriétaire",
                            telephoneProprioController),
                        SizedBox(height: 20.0),
                        _buildTextField("Lieu Longitude", lieuLongController),
                        SizedBox(height: 20.0),
                        _buildTextField("Lieu Latitude", lieuLatController),
                        SizedBox(height: 20.0),
                        // Bouton pour choisir l'image
                        ElevatedButton(
                          onPressed: _pickImage,
                          child: Text('Choisir une photo de la carte grise'),
                        ),
                        if (_imageFile != null)
                          Image.file(
                            _imageFile!,
                            height: 100,
                          ),
                        SizedBox(height: 20.0),
                        _buildTextField("Numéro Châssis", numChassisController),
                        SizedBox(height: 20.0),
                        _buildTextField("Numéro Plaque", numPlaqueController),
                        SizedBox(height: 20.0),
                        _buildTextField("Marque", marqueController),
                        SizedBox(height: 20.0),
                        _buildTextField("Modèle", modeleController),
                        SizedBox(height: 20.0),
                        _buildDateTimeField(
                            "Date et Heure", dateHeureController),
                        SizedBox(height: 50.0),
                        Container(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blue.shade600,
                            ),
                            onPressed: _submitDeclaration,
                            child: Padding(
                              padding:
                                  const EdgeInsets.symmetric(vertical: 18.0),
                              child: Text(
                                "Soumettre",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
