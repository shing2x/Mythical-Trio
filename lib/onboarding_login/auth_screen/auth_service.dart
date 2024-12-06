import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

class AuthService extends GetxController {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user
  User? get user => _auth.currentUser;

  // Register method
  Future<String> registerUser(
    String email,
    String password,
    String username,
  ) async {
    try {
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await _firestore.collection('users').doc(user!.uid).set({
        'email': email,
        'username': username,
        'password': password,
        'created_at': DateTime.now(),
      });

      await sendEmailVerification();
      return 'Registration successful! Please check your email for verification.';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred during registration.';
    }
  }

  // Send email verification
  Future<void> sendEmailVerification() async {
    User? user = _auth.currentUser;
    if (user != null && !user.emailVerified) {
      await user.sendEmailVerification();
    }
  }

  // Sign-in method with email and password
  Future<String> signInWithEmailPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);

      return 'Sign in successful!';
    } on FirebaseAuthException catch (e) {
      return e.message ?? 'An error occurred during sign-in.';
    }
  }

  // Check if the user is verified
  bool isEmailVerified() {
    User? user = _auth.currentUser;
    return user != null && user.emailVerified;
  }
}
