import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({super.key});

  @override
  State<Homepage> createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  final user = FirebaseAuth.instance.currentUser;

  signout() async {
    await FirebaseAuth.instance.signOut();
  }

  getFridge() async {
    final jwtToken = await user
        ?.getIdToken(); // Récupère le JWT Token de l'utilisateur Firebase

    // Vérifie si le jwtToken n'est pas null
    if (jwtToken != null) {
      try {
        final response = await http.get(
          Uri.parse('http://localhost/api/api/admin/recipes'),
          // Ajoute le token JWT dans l'en-tête d'Authorization
          headers: {
            'Authorization': 'Bearer $jwtToken',
          },
        );

        if (response.statusCode == 200) {
          // Si le serveur retourne une réponse OK, parse le JSON
          print('Response data: ${response.body}');
        } else {
          // Si la réponse n'est pas OK, affiche une erreur
          print('Failed to load fridge data');
        }
      } catch (e) {
        // Gestion des exceptions d'appel réseau
        print('Caught error: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Homepage"),
      ),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('${user!.email!}'),
            SizedBox(height: 20), // Ajoute un espace entre les widgets
            // Le nouveau bouton pour "Récupérer son frigo"
            ElevatedButton(
              onPressed: (() => getFridge()), // La fonction à appeler
              child: Text('Récupérer son frigo'),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: (() => signout()),
        child: Icon(Icons.login_rounded),
      ),
    );
  }
}