import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user_model.dart';

class AuthProvider with ChangeNotifier {
  UserModel? _user;
  bool _isLoading = false;
  bool _isInitialized = false;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isAuthenticated => _user != null;
  bool get isInitialized => _isInitialized;

  AuthProvider() {
    _initializeAuth();
  }

  Future<void> _initializeAuth() async {
    _isLoading = true;
    notifyListeners();

    try {
      final prefs = await SharedPreferences.getInstance();
      final userJson = prefs.getString('current_user');

      if (userJson != null) {
        // Parse stored user data when Firebase integration is added
        // For now, create a demo user
        _user = UserModel(
          id: 'demo_user_123',
          email: 'demo@mindmaze.app',
          displayName: 'Demo User',
          createdAt: DateTime.now(),
          hasCompletedOnboarding: prefs.getBool('onboarding_completed') ?? false,
          hasAcceptedConsent: prefs.getBool('consent_accepted') ?? false,
        );
      }
    } catch (e) {
      print('Error initializing auth: $e');
    } finally {
      _isLoading = false;
      _isInitialized = true;
      notifyListeners();
    }
  }

  // Mock authentication - replace with Firebase Auth later
  Future<String?> signUp(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Basic email validation
      if (!email.contains('@')) {
        return 'Please enter a valid email address';
      }

      if (password.length < 6) {
        return 'Password must be at least 6 characters';
      }

      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        createdAt: DateTime.now(),
      );

      // Store user data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', _user!.id);
      await prefs.setString('user_email', email);

      return null;
    } catch (e) {
      return 'An error occurred during sign up';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> signIn(String email, String password) async {
    try {
      _isLoading = true;
      notifyListeners();

      // Simulate API delay
      await Future.delayed(const Duration(seconds: 1));

      // Mock validation - accept any email/password for demo
      if (!email.contains('@')) {
        return 'Please enter a valid email address';
      }

      _user = UserModel(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        email: email,
        createdAt: DateTime.now().subtract(const Duration(days: 7)),
        hasCompletedOnboarding: true,
        hasAcceptedConsent: true,
      );

      // Store user data locally
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('current_user', _user!.id);
      await prefs.setString('user_email', email);
      await prefs.setBool('onboarding_completed', true);
      await prefs.setBool('consent_accepted', true);

      return null;
    } catch (e) {
      return 'An error occurred during sign in';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> signOut() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    notifyListeners();
  }

  Future<void> updateConsentStatus(bool accepted) async {
    if (_user == null) return;

    _user = _user!.copyWith(hasAcceptedConsent: accepted);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('consent_accepted', accepted);

    notifyListeners();
  }

  Future<void> completeOnboarding() async {
    if (_user == null) return;

    _user = _user!.copyWith(hasCompletedOnboarding: true);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_completed', true);

    notifyListeners();
  }
}