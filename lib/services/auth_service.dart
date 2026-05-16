import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {

  final FirebaseAuth _auth =
      FirebaseAuth.instance;

  final FirebaseFirestore
      _firestore =
          FirebaseFirestore.instance;

  // 🔐 SIGN UP
  Future<User?> signUp({
    required String email,
    required String password,
    required String name,
  }) async {

    try {

      final credential =
          await _auth
              .createUserWithEmailAndPassword(

        email: email,
        password: password,
      );

      final user =
          credential.user;

      if (user != null) {

        // ✅ Save real name in Firebase Auth
        await user.updateDisplayName(name);

        // ✅ Verification email
        await user.sendEmailVerification();

        // ✅ Firestore user document
        await _firestore
            .collection('agents')
            .doc(user.uid)
            .set({

          'uid': user.uid,

          'name': name,

          'email': email,

          'phone': '',

          'profileImage': '',

          'role': 'rider',


        });
      }

      return user;

    } on FirebaseAuthException catch (e) {

      throw e.message ??
          "Sign up failed";

    } catch (e) {

      print(e);

      throw e.toString();
    }
  }

  // 🔐 LOGIN
  Future<User?> login({
    required String email,
    required String password,
  }) async {

    try {

      final credential =
          await _auth
              .signInWithEmailAndPassword(

        email: email,
        password: password,
      );

      final user =
          credential.user;

      // 🚫 Block login if email not verified
      if (user != null &&
          !user.emailVerified) {

        await _auth.signOut();

        throw "Please verify your email before logging in.";
      }

      return user;

    } on FirebaseAuthException catch (e) {

      throw e.message ??
          "Login failed";

    } catch (e) {

      throw e.toString();
    }
  }

  // 🔐 GOOGLE SIGN IN
  Future<UserCredential?> signInWithGoogle() async {

    try {

      final GoogleSignInAccount? googleUser =
          await GoogleSignIn().signIn();

      if (googleUser == null) {
        return null;
      }

      final GoogleSignInAuthentication
          googleAuth =
              await googleUser.authentication;

      final credential =
          GoogleAuthProvider.credential(

        accessToken:
            googleAuth.accessToken,

        idToken:
            googleAuth.idToken,
      );

      UserCredential userCredential =
          await FirebaseAuth.instance
              .signInWithCredential(
                  credential);

      final user =
          userCredential.user;

      if (user != null) {

        await FirebaseFirestore.instance
            .collection('agents')
            .doc(user.uid)
            .set({

          'name':
              user.displayName ?? '',

          'email':
              user.email ?? '',

          'uid':
              user.uid,

          'phone': '',

          'profileImage': '',

          'role': 'rider',

        },

        SetOptions(
          merge: true,
        ));
      }

      return userCredential;

    } catch (e) {

      print(
        "Google Sign-In Error: $e",
      );

      return null;
    }
  }

  // 🚪 LOGOUT
  Future<void> logout() async {

    try {

      await GoogleSignIn().signOut();

      await _auth.signOut();

    } catch (e) {

      throw "Failed to log out";
    }
  }
}