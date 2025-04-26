import 'package:firebase_analytics/firebase_analytics.dart';

class AnalyticsService {
  final FirebaseAnalytics _analytics = FirebaseAnalytics.instance;

  FirebaseAnalyticsObserver getAnalyticsObserver() {
    return FirebaseAnalyticsObserver(analytics: _analytics);
  }

  Future<void> logLogin(String method) async {
    await _analytics.logLogin(loginMethod: method);
  }

  Future<void> logSignUp(String method) async {
    await _analytics.logSignUp(signUpMethod: method);
  }

  Future<void> logPasswordReset() async {
    await _analytics.logEvent(name: 'password_reset');
  }

  Future<void> logProfileUpdate() async {
    await _analytics.logEvent(name: 'profile_update');
  }

  Future<void> setUserProperties({
    required String userId,
    String? userRole,
  }) async {
    await _analytics.setUserId(id: userId);

    if (userRole != null) {
      await _analytics.setUserProperty(name: 'user_role', value: userRole);
    }
  }
}