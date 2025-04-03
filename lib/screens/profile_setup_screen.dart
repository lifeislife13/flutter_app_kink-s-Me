import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileSetupScreen extends StatefulWidget {
  const ProfileSetupScreen({super.key});

  @override
  _ProfileSetupScreenState createState() => _ProfileSetupScreenState();
}

class _ProfileSetupScreenState extends State<ProfileSetupScreen> {
  File? _image;
  final TextEditingController _bioController = TextEditingController();
  final List<String> _selectedPreferences = [];
  String _selectedOrientation = "Hétéro";

  final List<String> _preferences = [
    "Fétichisme",
    "Shibari / bondage",
    "Contrainte (menottes, chaînes ...)",
    "Discipline (Fessée, fouet, cravache...)",
    "Enfermement (placard, cage, coffre...)",
    "Asservissement (valet, soubrette ...)",
    "Exhibition forcée",
    "Suspension (harnais, cage ...)",
    "Brûlure (cire ...)",
    "Stimulation par sex-toy",
    "Electro-stimulation",
    "Piétinement (pieds nus ou talons ...)",
    "Uniforme (médecin, militaire, religieuse)",
    "Pet-play (travestir en chien, cheval ...)",
    "Infantilisation (autoritaire ou maternel)",
    "Chasteté (cage/ceinture ...)",
    "Momification (cellophane, adhésif)",
    "Etouffement maîtrisé",
    "Urolagnie",
    "Scatophilie",
    "Facesitting",
    "Adoration (cérémonial, dévotion ...)",
    "Mise en scène (kidnapping, viol simulé ...)",
  ];

  Future<void> _pickImage() async {
    try {
      final pickedFile = await ImagePicker().pickImage(
        source: ImageSource.gallery,
      );
      if (pickedFile != null) {
        setState(() {
          _image = File(pickedFile.path);
        });
      }
    } catch (e) {
      debugPrint("Erreur lors de la sélection d'image : $e");
    }
  }

  Future<void> _showWarningDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Colors.black87,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          title: const Text(
            'Avertissement',
            style: TextStyle(
              color: Color.fromARGB(255, 175, 3, 3),
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          content: const SingleChildScrollView(
            child: Text(
              "Privilégions les échanges authentiques et respectueux. Ne partagez pas vos coordonnées ni d'argent ! Si vous avez des fonds à dépenser, soutenez plutôt Kink’s Me pour que cette communauté continue de grandir !",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text(
                'OK',
                style: TextStyle(
                  color: Colors.red,
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void dispose() {
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Mon espace intime"),
        backgroundColor: Colors.black,
      ),
      body: Stack(
        children: [
          Container(
            width: double.infinity,
            height: double.infinity,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/fond.png"),
                fit: BoxFit.cover,
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: GestureDetector(
                    onTap: _pickImage,
                    child: CircleAvatar(
                      radius: 60,
                      backgroundColor: Colors.white24,
                      backgroundImage:
                          _image != null ? FileImage(_image!) : null,
                      child:
                          _image == null
                              ? const Icon(
                                Icons.camera_alt,
                                size: 40,
                                color: Colors.white,
                              )
                              : null,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Présentation :",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                TextField(
                  controller: _bioController,
                  maxLines: 3,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Écris ici une description de toi...",
                    hintStyle: const TextStyle(color: Colors.white70),
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Mes Explorations :",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                Column(
                  children:
                      _preferences.map((preference) {
                        return CheckboxListTile(
                          title: Text(
                            preference,
                            style: const TextStyle(color: Colors.white),
                          ),
                          value: _selectedPreferences.contains(preference),
                          activeColor: const Color.fromARGB(255, 178, 25, 14),
                          onChanged: (bool? value) {
                            setState(() {
                              if (value == true) {
                                _selectedPreferences.add(preference);
                              } else {
                                _selectedPreferences.remove(preference);
                              }
                            });
                          },
                        );
                      }).toList(),
                ),
                const SizedBox(height: 20),
                const Text(
                  "Mes affinités intimes :",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
                DropdownButtonFormField<String>(
                  value: _selectedOrientation,
                  dropdownColor: Colors.black,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white12,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                  items:
                      [
                            "Hétéro",
                            "Bi",
                            "Bi curieux(se)",
                            "Gay",
                            "Lesbienne",
                            "Queer",
                          ]
                          .map(
                            (orientation) => DropdownMenuItem(
                              value: orientation,
                              child: Text(
                                orientation,
                                style: const TextStyle(color: Colors.white),
                              ),
                            ),
                          )
                          .toList(),
                  onChanged: (value) {
                    if (value != null) {
                      setState(() {
                        _selectedOrientation = value;
                      });
                    }
                  },
                ),
                const SizedBox(height: 20),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      await _showWarningDialog();
                      final prefs = await SharedPreferences.getInstance();
                      await prefs.setBool(
                        'seenSetup',
                        true,
                      ); // ✅ Marquer le setup comme terminé
                      Navigator.pushReplacementNamed(
                        context,
                        '/profileMenu',
                      ); // ✅ Redirection propre
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(255, 159, 24, 15),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 50,
                        vertical: 15,
                      ),
                    ),
                    child: const Text(
                      "Enregistrer",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
