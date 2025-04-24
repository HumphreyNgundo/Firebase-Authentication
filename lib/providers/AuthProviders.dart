import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../services/AuthService.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();
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
    _authService.user.listen((User? user) {
      _user = user;
      notifyListeners();
    });
  }

  Future<void> signUpWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signUpWithEmail(email, password);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithEmail(String email, String password) async {
    _setLoading(true);
    try {
      await _authService.signInWithEmail(email, password);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInWithGoogle() async {
    _setLoading(true);
    try {
      await _authService.signInWithGoogle();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> signInAnonymously() async {
    _setLoading(true);
    try {
      await _authService.signInAnonymously();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> resetPassword(String email) async {
    _setLoading(true);
    try {
      await _authService.resetPassword(email);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
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
      _setError(e.toString());
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
          _setError(e.message ?? "Phone verification failed");
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
      _setError(e.toString());
      _setLoading(false);
    }
  }

  Future<void> signInWithPhoneCredential(PhoneAuthCredential credential) async {
    _setLoading(true);
    try {
      await _authService.signInWithPhoneCredential(credential);
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }

  Future<void> verifyOTP(String smsCode) async {
    if (_verificationId == null) {
      _setError("No verification ID found. Request code again.");
      return;
    }

    PhoneAuthCredential credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: smsCode,
    );

    await signInWithPhoneCredential(credential);
  }

// Apple sign in
  Future<void> signInWithApple() async {
    _setLoading(true);
    try {
      await _authService.signInWithApple();
      _setError(null);
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
    }
  }
}