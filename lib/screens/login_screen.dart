import 'package:flutter/material.dart';
import 'package:habit_tracker/services/auth_service.dart';

class LoginScreen extends StatelessWidget {
  final AuthService? authService;

  const LoginScreen({super.key, this.authService});

  @override
  Widget build(BuildContext context) {
    final AuthService _authService = authService ?? AuthService();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Login'),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            // The auth state stream will trigger a rebuild in the AuthWrapper.
            await _authService.signInWithGoogle();
          },
          child: const Text('Sign in with Google'),
        ),
      ),
    );
  }
}
