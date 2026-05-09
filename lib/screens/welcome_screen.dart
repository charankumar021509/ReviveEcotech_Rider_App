import 'package:flutter/material.dart';
import 'login_screen.dart';
import 'signup_screen.dart';

class WelcomeScreen extends StatelessWidget {
  const WelcomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF3E3),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Image.asset(
            'assets/images/welcome_illustration.jpg',
            fit: BoxFit.cover,
          ),
          const SizedBox(height: 80),

          // Get Started button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const SignUpScreen()),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF003D5B),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Sign up',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800, // ✅ SemiBold
                  fontFamily: 'RedHatDisplay',
                  color: Colors.white,
                ),
              ),
            ),
          ),

          const SizedBox(height: 16),

          // Log in button
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30.0),
            child: OutlinedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginScreen()),
                );
              },
              style: OutlinedButton.styleFrom(
                backgroundColor: const Color(0xFFFCF3E3),
                side: const BorderSide(color: Color(0xFF003D5B), width: 3.0),
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: const Text(
                'Log in',
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w800, // ✅ SemiBold
                  fontFamily: 'RedHatDisplay',
                  color: Color(0xFF003D5B),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
