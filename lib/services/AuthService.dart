import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Stream to listen to auth state changes
  Stream<User?> get user => _auth.authStateChanges();

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Email sign up
  Future<UserCredential> signUpWithEmail(String email, String password) async {
    try {
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      // Send email verification
      await userCredential.user?.sendEmailVerification();
      return userCredential;
    } catch (e) {
      throw e;
    }
  }

  // Email sign in
  Future<UserCredential> signInWithEmail(String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
    } catch (e) {
      throw e;
    }
  }

  // Google sign in
  Future<UserCredential> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) throw Exception('Google sign in aborted');

      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e;
    }
  }

  // Anonymous sign in
  Future<UserCredential> signInAnonymously() async {
    try {
      return await _auth.signInAnonymously();
    } catch (e) {
      throw e;
    }
  }

  // Password reset
  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } catch (e) {
      throw e;
    }
  }

  // Sign out
  Future<void> signOut() async {
    try {
      await _googleSignIn.signOut();
      await _auth.signOut();
    } catch (e) {
      throw e;
    }
  }

  // Update user profile
  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    try {
      await _auth.currentUser?.updateDisplayName(displayName);
      await _auth.currentUser?.updatePhotoURL(photoURL);
    } catch (e) {
      throw e;
    }
  }

  // Update email
  Future<void> updateEmail(String newEmail) async {
    try {
      await _auth.currentUser?.updateEmail(newEmail);
    } catch (e) {
      throw e;
    }
  }

  // Update password
  Future<void> updatePassword(String newPassword) async {
    try {
      await _auth.currentUser?.updatePassword(newPassword);
    } catch (e) {
      throw e;
    }
  }

  // Phone auth - request verification code
  Future<void> verifyPhoneNumber({
    required String phoneNumber,
    required Function(PhoneAuthCredential) verificationCompleted,
    required Function(FirebaseAuthException) verificationFailed,
    required Function(String, int?) codeSent,
    required Function(String) codeAutoRetrievalTimeout,
  }) async {
    try {
      await _auth.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: verificationCompleted,
        verificationFailed: verificationFailed,
        codeSent: codeSent,
        codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
      );
    } catch (e) {
      throw e;
    }
  }

// Sign in with phone auth credential
  Future<UserCredential> signInWithPhoneCredential(PhoneAuthCredential credential) async {
    try {
      return await _auth.signInWithCredential(credential);
    } catch (e) {
      throw e;
    }
  }

  // Apple sign in
  Future<UserCredential> signInWithApple() async {
    try {
      // Generate a random nonce and convert to base64
      final rawNonce = _generateNonce();
      final nonce = _sha256ofString(rawNonce);

      // Request credential for Apple
      final appleCredential = await SignInWithApple.getAppleIDCredential(
        scopes: [
          AppleIDAuthorizationScopes.email,
          AppleIDAuthorizationScopes.fullName,
        ],
        nonce: nonce,
      );

      // Create an OAuthCredential from the Apple response
      final oauthCredential = OAuthProvider("apple.com").credential(
        idToken: appleCredential.identityToken!,
        rawNonce: rawNonce,
      );

      // Sign in with the credential
      return await _auth.signInWithCredential(oauthCredential);
    } catch (e) {
      throw e;
    }
  }

// Generate a random string for authentication
  String _generateNonce([int length = 32]) {
    const charset = '0123456789ABCDEFGHIJKLMNOPQRSTUVXYZabcdefghijklmnopqrstuvwxyz-._';
    final random = Random.secure();
    return List.generate(length, (_) => charset[random.nextInt(charset.length)]).join();
  }

// Returns sha256 hash of [input] in hex notation
  String _sha256ofString(String input) {
    final bytes = utf8.encode(input);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }
}