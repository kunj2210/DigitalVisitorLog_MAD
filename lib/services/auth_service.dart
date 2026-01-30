import 'dart:async';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // Sign Up with Email and Password
  Future<UserCredential> signUp({
    required String email,
    required String password,
    required String name,
  }) async {
    debugPrint('AuthService: Attempting Sign Up for $email');
    try {
      // 1. Create User in Firebase Auth
      // This is the primary security step.
      final credential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15), onTimeout: () {
        throw TimeoutException('Connection timed out during Auth.');
      });

      debugPrint('AuthService: User created: ${credential.user?.uid}');

      // 2. Create User Profile and Update Display Name in Parallel
      if (credential.user != null) {
        try {
          await Future.wait([
            _firestore.collection('users').doc(credential.user!.uid).set({
              'uid': credential.user!.uid,
              'name': name,
              'email': email,
              'role': 'user',
              'createdAt': FieldValue.serverTimestamp(),
            }).timeout(const Duration(seconds: 10)),
            
            credential.user!.updateDisplayName(name).timeout(const Duration(seconds: 5)),
          ]);
           
           debugPrint('AuthService: Firestore profile and Auth DisplayName updated.');
        } catch (e) {
           debugPrint('AuthService: Profile sync failed (Non-fatal): $e');
           // We do not rethrow here so the user is still logged in even if profile sync fails
        }
      }
      return credential;
    } catch (e) {
      debugPrint('AuthService: SignUp Failed: $e');
      rethrow;
    }
  }

  /// Sign In with Email and Password
  Future<UserCredential> signIn({
    required String email,
    required String password,
  }) async {
    debugPrint('AuthService: Attempting Sign In...');
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      ).timeout(const Duration(seconds: 15));
    } catch (e) {
      debugPrint('AuthService: SignIn Failed: $e');
      rethrow;
    }
  }

  /// Sign Out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(String email) async {
    await _auth.sendPasswordResetEmail(email: email);
  }

  Future<Map<String, dynamic>?> getCurrentUserData() async {
    final user = _auth.currentUser;
    if (user != null) {
      try {
        final doc = await _firestore.collection('users').doc(user.uid).get().timeout(const Duration(seconds: 10));
        return doc.data();
      } catch (e) {
        debugPrint('AuthService: Fetch User Data Failed: $e');
        return null;
      }
    }
    return null;
  }
}
