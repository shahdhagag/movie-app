import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  static const _kLoggedInKey = 'is_logged_in';

  final StreamController<bool> _controller = StreamController<bool>.broadcast();
  bool _isLoggedIn = false;

  AuthService();

  /// Initialize from SharedPreferences. Call this before runApp.
  Future<void> init() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _isLoggedIn = prefs.getBool(_kLoggedInKey) ?? false;
    } catch (_) {
      _isLoggedIn = false;
    }
    _controller.add(_isLoggedIn);
  }

  /// Synchronous getter used by router redirect logic.
  bool get isLoggedIn => _isLoggedIn;

  /// Stream that emits when auth state changes (router listens).
  Stream<bool> get authStateChanges => _controller.stream;

  /// Update logged-in state (persist + notify).
  Future<void> setLoggedIn(bool value) async {
    _isLoggedIn = value;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_kLoggedInKey, value);
    } catch (_) {
      // ignore persistence errors
    }
    _controller.add(_isLoggedIn);
  }

  Future<void> dispose() async {
    await _controller.close();
  }
}