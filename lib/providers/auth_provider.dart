import 'package:flutter/foundation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/user_model.dart';
import '../models/auth_result.dart';
import '../services/auth_service.dart';
import '../services/firestore_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final FirestoreService _firestoreService = FirestoreService();

  User? _firebaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  // Getters
  User? get firebaseUser => _firebaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      _firebaseUser != null && _firebaseUser!.emailVerified;

  AuthProvider() {
    // Listen to auth state changes
    _authService.authStateChanges.listen((User? user) async {
      _firebaseUser = user;
      if (user != null && user.emailVerified) {
        // Load user document from Firestore
        await _loadUserDocument(user.uid);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  // Load user document from Firestore
  Future<void> _loadUserDocument(String uid) async {
    try {
      _userModel = await _firestoreService.getUserDocument(uid);

      // Sync email verification status
      if (_userModel != null && _firebaseUser != null) {
        if (_userModel!.emailVerified != _firebaseUser!.emailVerified) {
          await _firestoreService.updateEmailVerificationStatus(
            uid,
            _firebaseUser!.emailVerified,
          );
          _userModel = _userModel!.copyWith(
            emailVerified: _firebaseUser!.emailVerified,
            updatedAt: DateTime.now(),
          );
        }
      }
    } catch (e) {
      _errorMessage = 'Failed to load user data: $e';
    }
  }

  // Sign up
  Future<AuthResult> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      // Create Firebase Auth account
      AuthResult result = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );

      if (result.success && result.userId != null) {
        // Create Firestore user document (user is still authenticated here)
        UserModel newUser = UserModel(
          uid: result.userId!,
          name: name,
          email: email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          emailVerified: false,
        );

        await _firestoreService.createUserDocument(newUser);

        // NOW sign out after Firestore write is complete
        await _authService.signOut();
      }

      _setLoading(false);
      return result;
    } catch (e) {
      _setLoading(false);
      _setError('Signup failed: $e');
      return AuthResult.failure('Signup failed: $e');
    }
  }

  // Login
  Future<AuthResult> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      AuthResult result = await _authService.loginWithEmail(
        email: email,
        password: password,
      );

      _setLoading(false);
      return result;
    } catch (e) {
      _setLoading(false);
      _setError('Login failed: $e');
      return AuthResult.failure('Login failed: $e');
    }
  }

  // Resend verification email
  Future<AuthResult> resendVerificationEmail({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _clearError();

    try {
      AuthResult result = await _authService.resendVerificationEmail(
        email: email,
        password: password,
      );

      _setLoading(false);
      return result;
    } catch (e) {
      _setLoading(false);
      _setError('Failed to resend email: $e');
      return AuthResult.failure('Failed to resend email: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    _setLoading(true);
    await _authService.signOut();
    _userModel = null;
    _firebaseUser = null;
    _setLoading(false);
  }

  // Helper methods
  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String message) {
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    _errorMessage = null;
    notifyListeners();
  }
}
