import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:reviveecotech_rider/screens/dashboard_screen.dart';
import 'theme_controller.dart';

class VerifyEmailScreen extends StatefulWidget {
  const VerifyEmailScreen({super.key});

  @override
  State<VerifyEmailScreen> createState() => _VerifyEmailScreenState();
}

class _VerifyEmailScreenState extends State<VerifyEmailScreen> {
  final User? user = FirebaseAuth.instance.currentUser;
  bool _isLoading = false;
  int _secondsRemaining = 30;
  Timer? _timer;

  // ── Colors ──
  static const navy = Color(0xFF0B132B);
  static const green = Color(0xFF10B981);
  static const surface = Color(0xFF162032);

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining == 0) {
        timer.cancel();
      } else {
        setState(() => _secondsRemaining--);
      }
    });
  }

  Future<void> _checkVerification() async {
    setState(() => _isLoading = true);
    await user?.reload();
    final refreshedUser = FirebaseAuth.instance.currentUser;

    if (refreshedUser != null && refreshedUser.emailVerified) {
      if (!mounted) return;
      Navigator.pushReplacement(context, MaterialPageRoute(builder: (_) => const DashboardScreen()));
    } else {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Email not verified yet."), backgroundColor: Colors.orange));
    }
    if (mounted) setState(() => _isLoading = false);
  }

  Future<void> _resendEmail() async {
    await user?.sendEmailVerification();
    setState(() => _secondsRemaining = 30);
    _startTimer();
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: isDarkMode,
      builder: (context, dynamic value, child) {
        final bool isDark = value;
        return Scaffold(
          backgroundColor: isDark ? navy : const Color(0xFFEDF4F0),
          body: Column(
            children: [
              // 🔵 Header Section
              _buildHeader(isDark),

              // 🏢 Content Section
              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
                  child: Column(
                    children: [
                      _buildInfoCard(isDark),
                      const SizedBox(height: 40),
                      _buildActionButtons(isDark),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHeader(bool isDark) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 80, 20, 60),
      decoration: BoxDecoration(
        gradient: isDark
            ? const LinearGradient(colors: [navy, Color(0xFF0D1F3C)], begin: Alignment.topLeft, end: Alignment.bottomRight)
            : const LinearGradient(colors: [Color(0xFF003856), green], begin: Alignment.topLeft, end: Alignment.bottomRight),
        borderRadius: const BorderRadius.only(bottomLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
        boxShadow: [BoxShadow(color: green.withAlpha(60), blurRadius: 30, offset: const Offset(0, 10))],
      ),
      child: Center(
        child: Image.asset(
          'assets/images/revive_logo_transparent.png',
          width: 250,
          errorBuilder: (context, error, stackTrace) => const Icon(Icons.eco_rounded, size: 80, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildInfoCard(bool isDark) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: isDark ? surface : Colors.white,
        borderRadius: BorderRadius.circular(32),
        border: Border.all(color: isDark ? Colors.white12 : green.withAlpha(50), width: 1.5),
        boxShadow: [
          BoxShadow(color: isDark ? Colors.black.withAlpha(40) : green.withAlpha(15), blurRadius: 20, offset: const Offset(0, 10)),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: green.withAlpha(15), shape: BoxShape.circle, border: Border.all(color: green.withAlpha(40))),
            child: const Icon(Icons.mark_email_read_rounded, size: 50, color: green),
          ),
          const SizedBox(height: 32),
          Text(
            'Check Your Inbox!',
            style: TextStyle(fontSize: 26, fontWeight: FontWeight.w900, fontFamily: 'RedHatDisplay', color: isDark ? Colors.white : navy),
          ),
          const SizedBox(height: 12),
          Text(
            'We have sent a verification link to\n${user?.email}',
            textAlign: TextAlign.center,
            style: TextStyle(fontSize: 16, height: 1.6, fontFamily: 'RedHatDisplay', color: isDark ? Colors.white54 : Colors.black45),
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(bool isDark) {
    return Column(
      children: [
        GestureDetector(
          onTap: _isLoading ? null : _checkVerification,
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 20),
            decoration: BoxDecoration(
              gradient: const LinearGradient(colors: [green, Color(0xFF059669)]),
              borderRadius: BorderRadius.circular(20),
              boxShadow: [BoxShadow(color: green.withAlpha(80), blurRadius: 20, offset: const Offset(0, 10))],
            ),
            child: Center(
              child: _isLoading
                  ? const SizedBox(height: 24, width: 24, child: CircularProgressIndicator(color: Colors.white, strokeWidth: 3))
                  : const Text(
                      "I've Verified",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900, color: Colors.white, fontFamily: 'RedHatDisplay', letterSpacing: 1.2),
                    ),
            ),
          ),
        ),
        const SizedBox(height: 32),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          decoration: BoxDecoration(color: isDark ? surface : Colors.white, borderRadius: BorderRadius.circular(20), border: Border.all(color: Colors.white10)),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: _secondsRemaining == 0 ? _resendEmail : null,
                child: Text(
                  'Resend Email',
                  style: TextStyle(
                    fontWeight: FontWeight.w900,
                    fontFamily: 'RedHatDisplay',
                    color: _secondsRemaining == 0 ? green : (isDark ? Colors.white24 : Colors.black26),
                    fontSize: 15,
                  ),
                ),
              ),
              Text(
                '00:${_secondsRemaining.toString().padLeft(2, '0')}',
                style: TextStyle(fontWeight: FontWeight.w900, fontFamily: 'RedHatDisplay', color: isDark ? Colors.white : navy, fontSize: 15),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
