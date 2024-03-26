import 'package:flutter/material.dart';
import 'package:provider/provider.dart'; // Import the provider package
import 'package:kookeat_app/home/home_screen.dart';
import 'package:kookeat_app/user_auth/authenticate.dart';
import 'package:kookeat_app/models/user.dart'; // Make sure this line ends with a semicolon

class SplashScreenWrapper extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Assuming AppUser is correctly defined in your user.dart file
    final user = Provider.of<AppUser?>(context); // Use AppUser? if your setup allows nulls
    if (user == null) {
      return AuthenticateScreen();
    } else {
      return HomeScreen();
    }
  }
}
