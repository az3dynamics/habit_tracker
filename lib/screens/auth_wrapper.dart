import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:habit_tracker/screens/home_screen.dart';
import 'package:habit_tracker/screens/login_screen.dart';
import 'package:habit_tracker/services/auth_service.dart';

class AuthWrapper extends StatelessWidget {
  final AuthService? authService; // Made injectable

  const AuthWrapper({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = authService ?? AuthService(); // Use injected or default

    return StreamBuilder<User?>(
      stream: _authService.user,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Scaffold(
            body: Center(
              child: CircularProgressIndicator(),
            ),
          );
        }
        if (snapshot.hasData) {
          return const HomeScreen();
        } else {
          return const LoginScreen();
        }
      },
    );
  }
}
