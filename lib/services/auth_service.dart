import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // 🔐 SIGN UP
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      if (user != null) {
        // 🔥 Send verification email
        await user.sendEmailVerification();

        // Create Firestore user document
        await _firestore.collection('users').doc(user.uid).set({
          'name': name,
          'email': email,
          'role': 'rider',
          'createdAt': FieldValue.serverTimestamp(),
        });
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Sign up failed";
    } catch (e) {
      throw "An unexpected error occurred during sign up";
    }
  }

  // 🔐 LOGIN
  Future<User?> login({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final user = credential.user;

      // 🚫 Block login if email not verified
      if (user != null && !user.emailVerified) {
        await _auth.signOut();
        throw "Please verify your email before logging in.";
      }

      return user;
    } on FirebaseAuthException catch (e) {
      throw e.message ?? "Login failed";
    } catch (e) {
      throw e.toString();
    }
  }

  // 🚪 LOGOUT
  Future<void> logout() async {
    try {
      await _auth.signOut();
    } catch (e) {
      throw "Failed to log out";
    }
  }
}