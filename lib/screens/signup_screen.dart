import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:reviveecotech_rider/screens/login_screen.dart';
import 'package:reviveecotech_rider/services/auth_service.dart';
import 'package:reviveecotech_rider/screens/verify_email_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  bool _isPasswordVisible = false;

  final AuthService _authService = AuthService();
  bool _isLoading = false;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFCF3E3),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // 🔵 Header (same as login)
          Container(
            height: 260,
            color: const Color(0xFF003856),
            child: Padding(
              padding: const EdgeInsets.only(top: 32),
              child: Center(
                child: Image.asset(
                  'assets/images/revive_logo.jpg',
                  width: 300,
                ),
              ),
            ),
          ),

          Expanded(
            child: SingleChildScrollView(
              child: Column(
                children: [
                  const SizedBox(height: 16),

                  // Title
                  const Text(
                    'Sign up',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      fontFamily: 'RedHatDisplay',
                      color: Color(0xFF003856),
                    ),
                  ),

                  const SizedBox(height: 10),

                  // Divider + shadow (same)
                  Column(
                    children: [
                      Container(
                        height: 2.5,
                        width: double.infinity,
                        color: const Color(0xFF003856),
                      ),
                      Container(
                        height: 22,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.black.withValues(alpha: 0.30),
                              Colors.black.withValues(alpha: 0.16),
                              Colors.black.withValues(alpha: 0.08),
                              Colors.transparent,
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 15),

                  const Text(
                    'Become the part of our future',
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF003856),
                      fontFamily: 'RedHatDisplay',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 👤 Name
                  _inputField(
                    controller: _nameController,
                    hint: 'Full Name',
                    icon: Icons.person_outline,
                  ),

                  const SizedBox(height: 25),

                  // 📧 Email
                  _inputField(
                    controller: _emailController,
                    hint: 'E-mail',
                    icon: Icons.email_outlined,
                  ),

                  const SizedBox(height: 25),

                  // 🔒 Password
                  _passwordField(
                    controller: _passwordController,
                    hint: 'Password',
                    isVisible: _isPasswordVisible,
                    toggle: () {
                      setState(() {
                        _isPasswordVisible = !_isPasswordVisible;
                      });
                    },
                  ),

                  const SizedBox(height: 30),

                  // 🟢 Sign up button (same style as login)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40),
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () async {
                          setState(() => _isLoading = true);

                          try {
                            final user = await _authService.signUp(
                              email: _emailController.text.trim(),
                              password: _passwordController.text.trim(),
                              name: _nameController.text.trim(),
                            );

                            if (user != null) {
                              if (!mounted) return;

                              Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => const VerifyEmailScreen(),
                                ),
                              );
                            }
                          } catch (e) {
                            if (!mounted) return;

                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(e.toString())),
                            );
                          }

                          if (mounted) {
                            setState(() => _isLoading = false);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF98C13F),
                          padding: const EdgeInsets.symmetric(vertical: 16),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                          elevation: 8,
                        ),
                        child: _isLoading
                            ? const CircularProgressIndicator(color: Colors.white)
                            : const Text(
                                'Sign up',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                  fontFamily: 'RedHatDisplay',
                                ),
                              ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Back to login
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'Already have an account? ',
                        style: TextStyle(fontFamily: 'RedHatDisplay'),
                      ),
                      GestureDetector(
                        onTap: () => Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const LoginScreen(),
                          ),
                        ),
                        child: const Text(
                          'Log in',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF003856),
                            fontFamily: 'RedHatDisplay',
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 10),

                  // "Or connect with" text
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      children: [
                        Expanded(
                          child: Divider(
                            color: Color(0xFF003856),
                            thickness: 1,
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 10.0),
                          child: Text(
                            'Or connect with',
                            style: TextStyle(
                              color: Color(0xFF003856),
                              fontWeight: FontWeight.bold,
                              fontFamily: 'RedHatDisplay',
                            ),
                          ),
                        ),
                        Expanded(
                          child: Divider(
                            color: Color(0xFF003856),
                            thickness: 1,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),

                  // Social Login Buttons
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 40.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        // Google and Apple
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.google,
                              color: Colors.red,
                            ),
                            label: const Text(
                              'Google',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'RedHatDisplay',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color(0xFF000000),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                        const SizedBox(width: 20),
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: () {},
                            icon: const FaIcon(
                              FontAwesomeIcons.apple,
                              color: Colors.black,
                            ),
                            label: const Text(
                              'Apple',
                              style: TextStyle(
                                color: Colors.black,
                                fontFamily: 'RedHatDisplay',
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              minimumSize: const Size(double.infinity, 50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                                side: const BorderSide(
                                  color: Color(0xFF000000),
                                ),
                              ),
                              padding: const EdgeInsets.symmetric(vertical: 15),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  // 🔹 Input Field (same as login)
  Widget _inputField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: _boxDecoration(),
        child: TextField(
          controller: controller,
          decoration: _inputDecoration(hint, icon),
          textInputAction: TextInputAction.next,
        ),
      ),
    );
  }

  // 🔹 Password Field
  Widget _passwordField({
    required TextEditingController controller,
    required String hint,
    required bool isVisible,
    required VoidCallback toggle,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 40),
      child: Container(
        decoration: _boxDecoration(),
        child: TextField(
          controller: controller,
          obscureText: !isVisible,
          decoration: _inputDecoration(
            hint,
            Icons.lock_outline,
            suffix: IconButton(
              onPressed: toggle,
              icon: Icon(
                isVisible ? Icons.visibility : Icons.visibility_off,
                color: const Color(0xFF98C13F),
              ),
            ),
          ),
          textInputAction: TextInputAction.done,
        ),
      ),
    );
  }

  BoxDecoration _boxDecoration() => BoxDecoration(
    color: const Color(0xFFFCF3E3),
    borderRadius: BorderRadius.circular(50),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withValues(alpha: 0.30),
        spreadRadius: 2,
        blurRadius: 10,
        offset: const Offset(0, 4),
      ),
    ],
  );

  InputDecoration _inputDecoration(
      String hint,
      IconData icon, {
        Widget? suffix,
      }) =>
      InputDecoration(
        contentPadding: const EdgeInsets.symmetric(vertical: 20),
        border: InputBorder.none,
        hintText: hint,
        hintStyle: const TextStyle(
          color: Color(0xFF003856),
          fontWeight: FontWeight.w500,
        ),
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 20, right: 10),
          child: Icon(icon, color: const Color(0xFF98C13F)),
        ),
        suffixIcon: suffix == null
            ? null
            : Padding(
          padding: const EdgeInsets.only(right: 20),
          child: suffix,
        ),
      );

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }
}