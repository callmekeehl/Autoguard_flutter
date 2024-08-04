import 'package:autoguard_flutter/Constant.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ListeRdv extends StatefulWidget {
  @override
  _ListeRdvState createState() => _ListeRdvState();
}

class _ListeRdvState extends State<ListeRdv> {
  List<dynamic> motifs = [];
  int? policeId;
  DateTime? selectedDate;
  bool isEditing = false;
  int? editingMotifId;

  @override
  void initState() {
    super.initState();
    _loadMotifs();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      policeId = prefs.getInt('policeId');
    });
  }

  Future<void> _loadMotifs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');
    final response = await http.get(
      Uri.parse('$url/api/motifs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      setState(() {
        motifs = jsonDecode(response.body);
      });
    }
  }

  Future<void> _enregistrerRdv(int utilisateurId, String motif) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('authToken');

    final response = await http.post(
      Uri.parse('$url/api/rdvs'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'utilisateurId': utilisateurId,
        'policeId': policeId,
        'date': selectedDate?.toIso8601String(),
        'motif': motif,
      }),
    );

    if (response.statusCode == 201) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Rendez-vous enregistré avec succès.'),
          backgroundColor: Colors.green,
        ),
      );
      _loadMotifs();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Erreur lors de l\'enregistrement du rendez-vous.'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  Future<Map<String, dynamic>?> _getUtilisateurInfo(int utilisateurId) async {
    final response = await http.get(
      Uri.parse('$url/api/utilisateurs/$utilisateurId'),
      headers: {
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue.shade400,
        title: Text('Liste des demandes de rendez-vous'),
      ),
      body: ListView.builder(
        itemCount: motifs.length,
        itemBuilder: (context, index) {
          final motif = motifs[index];
          return FutureBuilder<Map<String, dynamic>?>(
            future: _getUtilisateurInfo(motif['utilisateurId']),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return CircularProgressIndicator();
              } else if (snapshot.hasError || !snapshot.hasData) {
                return Text('Erreur lors de la récupération des données');
              } else {
                final userInfo = snapshot.data!;
                return Card(
                  child: ListTile(
                    title: Text('${userInfo['prenom']} ${userInfo['nom']}'),
                    subtitle: Text('Motif: ${motif['motifDescription']}'),
                    trailing: isEditing && editingMotifId == motif['id']
                        ? Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              IconButton(
                                icon: Icon(Icons.calendar_today),
                                onPressed: () async {
                                  DateTime? date = await showDatePicker(
                                    context: context,
                                    initialDate: DateTime.now(),
                                    firstDate: DateTime.now(),
                                    lastDate: DateTime(2101),
                                  );
                                  if (date != null) {
                                    setState(() {
                                      selectedDate = date;
                                    });
                                  }
                                },
                              ),
                              ElevatedButton(
                                onPressed: () {
                                  if (selectedDate != null) {
                                    _enregistrerRdv(motif['utilisateurId'],
                                        motif['motifDescription']);
                                    setState(() {
                                      isEditing = false;
                                      editingMotifId = null;
                                    });
                                  }
                                },
                                child: Text('Soumettre'),
                              ),
                            ],
                          )
                        : IconButton(
                            icon: Icon(Icons.edit),
                            onPressed: () {
                              setState(() {
                                isEditing = true;
                                editingMotifId = motif['id'];
                              });
                            },
                          ),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
