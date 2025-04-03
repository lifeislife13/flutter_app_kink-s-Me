// AgeCheckScreen corrigé + redirection propre vers Home
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AgeCheckScreen extends StatefulWidget {
  const AgeCheckScreen({super.key});

  @override
  AgeCheckScreenState createState() => AgeCheckScreenState();
}

class AgeCheckScreenState extends State<AgeCheckScreen> {
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _confirmedDob = false;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    _dobController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _pickDateOfBirth() async {
    final today = DateTime.now();
    final initialDate = DateTime(today.year - 18, today.month, today.day);
    final firstDate = DateTime(today.year - 100);
    final lastDate = today;

    final picked = await showDatePicker(
      context: context,
      initialDate: initialDate,
      firstDate: firstDate,
      lastDate: lastDate,
    );
    if (picked != null) {
      final dateStr = DateFormat('dd/MM/yyyy').format(picked);
      _dobController.text = dateStr;
    }
  }

  bool _isAdult(String dobStr) {
    try {
      final parsed = DateFormat('dd/MM/yyyy').parseStrict(dobStr);
      final today = DateTime.now();
      int age = today.year - parsed.year;
      final birthdayThisYear = DateTime(today.year, parsed.month, parsed.day);
      if (birthdayThisYear.isAfter(today)) {
        age--;
      }
      return (age >= 18);
    } catch (_) {
      return false;
    }
  }

  void _openLegalInfo() {
    Navigator.pushNamed(context, '/about');
  }

  void _onContinue() async {
    final dobStr = _dobController.text.trim();
    final email = _emailController.text.trim();

    if (dobStr.isEmpty || email.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Veuillez saisir date de naissance et email."),
        ),
      );
      return;
    }
    if (!_isAdult(dobStr)) {
      showDialog(
        context: context,
        builder:
            (ctx) => AlertDialog(
              title: const Text("Accès refusé 🚫"),
              content: const Text(
                "Vous devez être majeur pour utiliser Kink’s Me.",
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(ctx),
                  child: const Text("OK"),
                ),
              ],
            ),
      );
      return;
    }
    if (!_confirmedDob) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez cocher la case de confirmation de votre âge.",
          ),
        ),
      );
      return;
    }
    if (!_acceptedTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Veuillez accepter les Conditions et Mentions Légales.",
          ),
        ),
      );
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('seenHome', true);

    if (mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const Text(
                "Bienvenue sur Kink’s Me",
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                "Pour accéder à l'application, veuillez confirmer que vous êtes majeur(e).",
                style: TextStyle(color: Colors.white70, fontSize: 16),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 30),
              TextField(
                controller: _dobController,
                readOnly: true,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: "Date de naissance (JJ/MM/AAAA)",
                  labelStyle: const TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  suffixIcon: IconButton(
                    icon: const Icon(
                      Icons.calendar_today,
                      color: Colors.white70,
                    ),
                    onPressed: _pickDateOfBirth,
                  ),
                  border: const OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.white70),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              TextField(
                controller: _emailController,
                style: const TextStyle(color: Colors.white),
                decoration: const InputDecoration(
                  labelText: "Votre Email",
                  labelStyle: TextStyle(color: Colors.white70),
                  filled: true,
                  fillColor: Colors.black54,
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Checkbox(
                    value: _confirmedDob,
                    activeColor: Colors.red,
                    onChanged: (val) {
                      setState(() {
                        _confirmedDob = val ?? false;
                      });
                    },
                  ),
                  const Expanded(
                    child: Text(
                      "Je certifie  ma date de naissance (j'ai >= 18 ans).",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    value: _acceptedTerms,
                    activeColor: Colors.red,
                    onChanged: (val) {
                      setState(() {
                        _acceptedTerms = val ?? false;
                      });
                    },
                  ),
                  Expanded(
                    child: Wrap(
                      children: [
                        const Text(
                          "J'accepte les ",
                          style: TextStyle(color: Colors.white),
                        ),
                        GestureDetector(
                          onTap: _openLegalInfo,
                          child: const Text(
                            "Conditions d'utilisation / Mentions Légales",
                            style: TextStyle(
                              color: Colors.blueAccent,
                              decoration: TextDecoration.underline,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              ElevatedButton(
                onPressed: _onContinue,
                style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                child: const Text("Continuer", style: TextStyle(fontSize: 18)),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
