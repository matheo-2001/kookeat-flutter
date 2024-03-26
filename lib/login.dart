import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();

  // Supposons que cette fonction est appelée après une authentification réussie
  Future<String?> getJwtToken() async {
    // Récupération de l'utilisateur actuellement connecté
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      // Récupération du JWT Token
      String? jwtToken = await user.getIdToken();
      print("JWT Token: $jwtToken");

      // Vous pouvez maintenant utiliser ce JWT Token selon vos besoins
      return jwtToken;
    } else {
      // Gérer le cas où aucun utilisateur n'est connecté
      print("Aucun utilisateur connecté trouvé.");
      return '';
    }
  }

  signIn() async {
    await FirebaseAuth.instance
        .signInWithEmailAndPassword(email: email.text, password: password.text);
    getJwtToken();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Login"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            TextField(
              controller: email,
              decoration: InputDecoration(hintText: 'Enter email'),
            ),
            TextField(
              controller: password,
              decoration: InputDecoration(hintText: 'Enter password'),
            ),
            ElevatedButton(onPressed: (() => signIn()), child: Text("Login"))
          ],
        ),
      ),
    );
  }
}