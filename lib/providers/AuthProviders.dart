import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/AnalyticsService.dart';
import '../services/AuthService.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
  final AnalyticsService _analyticsService = AnalyticsService();

  User? _user;
  bool _isLoading = false;
  String? _error;

  User? get user => _user;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get isAuthenticated => _user != null;
  String? _verificationId;

  AuthProvider() {
    _init();
  }

  void _init() {
    // Set initial loading state while we wait for Firebase
    _setLoading(true);

    _authService.user.listen((User? user) {
      _user = user;
      // Once we have user data (even if null), we're no longer loading
      _setLoading(false);
      notifyListeners();
    });
  }

  // Helper to safely handle user credentials
  Future<void> _handleUserCredential(UserCredential? userCredential, String method) async {
    try {
      if (userCredential?.user != null) {
        await _analyticsService.setUserProperties(userId: userCredential!.user!.uid);
      }
      _setError(null);
    } catch (e) {
      _setError("Error handling authentication: ${e.toString()}");
    }
  }

  Future<void> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      final userCredential = await _authService.signUpWithEmail(email, password);
      await _analyticsService.logSignUp('email');
      await _handleUserCredential(userCredential, 'email');
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      final userCredential = await _authService.signInWithEmail(email, password);
      await _analyticsService.logLogin('email');
      await _handleUserCredential(userCredential, 'email');
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      final userCredential = await _authService.signInWithGoogle();
      await _analyticsService.logLogin('google');
      await _handleUserCredential(userCredential, 'google');
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInAnonymously() async {
    _setLoading(true);
    try {
      final userCredential = await _authService.signInAnonymously();
      await _analyticsService.logLogin('anonymous');
      await _handleUserCredential(userCredential, 'anonymous');
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      await _analyticsService.logPasswordReset();
      _setError(null);
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signOut() async {
    _setLoading(true);
    try {
      await _authService.signOut();
      _setError(null);
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> updateProfile({String? displayName, String? photoURL}) async {
    _setLoading(true);
    try {
      await _authService.updateProfile(displayName: displayName, photoURL: photoURL);
      await _analyticsService.logProfileUpdate();
      _setError(null);
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? value) {
    _error = value;
    notifyListeners();
  }

  // Format Firebase auth errors to be more user-friendly
  String _formatAuthError(dynamic error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'user-not-found':
          return 'No user found with this email.';
        case 'wrong-password':
          return 'Incorrect password.';
        case 'invalid-email':
          return 'The email address is not valid.';
        case 'user-disabled':
          return 'This user account has been disabled.';
        case 'too-many-requests':
          return 'Too many unsuccessful login attempts. Please try again later.';
        case 'operation-not-allowed':
          return 'This sign-in method is not allowed. Please contact support.';
        case 'email-already-in-use':
          return 'This email is already in use by another account.';
        case 'weak-password':
          return 'The password is too weak. Please use a stronger password.';
        case 'credential-already-in-use':
          return 'This credential is already associated with a different user account.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'invalid-credential':
          return 'The provided credential is invalid or has expired.';
        case 'account-exists-with-different-credential':
          return 'An account already exists with the same email but different sign-in credentials.';
        case 'requires-recent-login':
          return 'This operation requires re-authentication. Please log in again before retrying.';
        default:
          return error.message ?? 'An authentication error occurred.';
      }
    }
    // Generic fallback message
    return error.toString();
  }

  Future<void> verifyPhoneNumber(String phoneNumber) async {
    _setLoading(true);
    try {
      await _authService.verifyPhoneNumber(
        phoneNumber: phoneNumber,
        verificationCompleted: (PhoneAuthCredential credential) async {
          // Auto-resolution (Android only)
          await signInWithPhoneCredential(credential);
        },
        verificationFailed: (FirebaseAuthException e) {
          _setError(_formatAuthError(e));
          _setLoading(false);
        },
        codeSent: (String verificationId, int? resendToken) {
          _verificationId = verificationId;
          _setLoading(false);
          _setError(null);
        },
        codeAutoRetrievalTimeout: (String verificationId) {
          _verificationId = verificationId;
        },
      );
    } catch (e) {
      _setError(_formatAuthError(e));
      _setLoading(false);
    }
  }

  Future<void> signInWithPhoneCredential(PhoneAuthCredential credential) async {
    _setLoading(true);
    try {
      final userCredential = await _authService.signInWithPhoneCredential(credential);
      await _analyticsService.logLogin('phone');
      await _handleUserCredential(userCredential, 'phone');
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOTP(String smsCode) async {
    if (_verificationId == null) {
      _setError("No verification ID found. Request code again.");
      return;
    }

    try {
      PhoneAuthCredential credential = PhoneAuthProvider.credential(
        verificationId: _verificationId!,
        smsCode: smsCode,
      );

      await signInWithPhoneCredential(credential);
    } catch (e) {
      _setError(_formatAuthError(e));
    }
  }

  // Apple sign in
  Future<void> signInWithApple() async {
    _setLoading(true);
    try {
      final userCredential = await _authService.signInWithApple();
      await _analyticsService.logLogin('apple');
      await _handleUserCredential(userCredential, 'apple');
    } catch (e) {
      _setError(_formatAuthError(e));
    } finally {
      _setLoading(false);
    }
  }
}