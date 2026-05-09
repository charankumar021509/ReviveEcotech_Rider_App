import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

import 'package:reviveecotech_rider/screens/dashboard_screen.dart';
import 'package:reviveecotech_rider/screens/edit_profile_screen.dart';
import 'package:reviveecotech_rider/screens/login_screen.dart';
import 'package:reviveecotech_rider/screens/order_details_screen.dart';
import 'package:reviveecotech_rider/screens/order_history_screen.dart';
import 'package:reviveecotech_rider/screens/profile_settings_screen.dart';
import 'package:reviveecotech_rider/screens/settings_screen.dart';
import 'package:reviveecotech_rider/screens/verify_email_screen.dart';
import 'package:reviveecotech_rider/screens/welcome_screen.dart';
import 'screens/splash_screen.dart';
import 'screens/order_complete_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: DashboardScreen(),
    );
  }
}