import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

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

import 'localization/app_localizations.dart';
import 'localization/language_controller.dart';

// Notification Service
import 'services/notification_service.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();

  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  /// ================= FCM PERMISSION =================

  await FirebaseMessaging
      .instance
      .requestPermission();

  /// ================= GET TOKEN =================

  final token =
      await FirebaseMessaging
          .instance
          .getToken();

  print("FCM TOKEN: $token");

  /// ================= SAVE TOKEN =================

  final user =
      FirebaseAuth
          .instance
          .currentUser;

  if (user != null &&
      token != null) {

    await FirebaseFirestore
        .instance
        .collection('agents')
        .doc(user.uid)
        .set({

      'fcmToken': token,

    }, SetOptions(
      merge: true,
    ));
  }

  /// ================= FOREGROUND NOTIFICATION =================

  FirebaseMessaging.onMessage.listen(

    (RemoteMessage message) {

      print(
        message.notification?.title,
      );
    },
  );

  // Initialize Notifications
  await NotificationService.initialize();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {

    return ValueListenableBuilder(

      valueListenable: appLocale,

      builder: (context, locale, child) {

        return MaterialApp(

          debugShowCheckedModeBanner: false,

          locale: locale,

          supportedLocales: const [

            Locale('en'),
            Locale('hi'),
            Locale('te'),
          ],

          localizationsDelegates: const [

            AppLocalizations.delegate,

            GlobalMaterialLocalizations.delegate,

            GlobalWidgetsLocalizations.delegate,

            GlobalCupertinoLocalizations.delegate,
          ],

          home: const SplashScreen(),
        );
      },
    );
  }
}