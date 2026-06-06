import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/user_model.dart';
import '../models/auth_result.dart';
import '../services/auth_service.dart';
import '../services/profile_service.dart';

class AuthProvider with ChangeNotifier {
  final AuthService _authService = AuthService();
  final ProfileService _profileService = ProfileService();

  User? _supabaseUser;
  UserModel? _userModel;
  bool _isLoading = false;
  String? _errorMessage;

  User? get currentUser => _supabaseUser;
  UserModel? get userModel => _userModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated =>
      _supabaseUser != null && _supabaseUser!.emailConfirmedAt != null;

  AuthProvider() {
    _authService.authStateChanges.listen((User? user) async {
      _supabaseUser = user;
      if (user != null && user.emailConfirmedAt != null) {
        await _loadUserDocument(user.id);
      } else {
        _userModel = null;
      }
      notifyListeners();
    });
  }

  Future<void> _loadUserDocument(String uid) async {
    try {
      _userModel = await _profileService.getUserDocument(uid);

      if (_userModel == null && _supabaseUser != null) {
        final email = _supabaseUser!.email ?? '';
        final name = (_supabaseUser!.userMetadata?['name'] ??
                (email.contains('@') ? email.split('@').first : 'User'))
            .toString();

        _userModel = UserModel(
          uid: uid,
          name: name,
          email: email,
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
          emailVerified: _supabaseUser!.emailConfirmedAt != null,
          isAdmin: false,
        );
        await _profileService.createUserDocument(_userModel!);
      }

      if (_userModel != null && _supabaseUser != null) {
        final confirmed = _supabaseUser!.emailConfirmedAt != null;
        if (_userModel!.emailVerified != confirmed) {
          await _profileService.updateEmailVerificationStatus(uid, confirmed);
          _userModel = _userModel!.copyWith(
            emailVerified: confirmed,
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
      AuthResult result = await _authService.signUpWithEmail(
        email: email,
        password: password,
        name: name,
      );

      if (result.success) {
        final currentUser = _authService.currentUser;
        final userId = result.userId ?? currentUser?.id;

        if (userId != null && currentUser != null) {
          final isConfirmed = currentUser.emailConfirmedAt != null;
          UserModel newUser = UserModel(
            uid: userId,
            name: name,
            email: email,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
            emailVerified: isConfirmed,
            isAdmin: false,
          );

          await _profileService.createUserDocument(newUser);
          await _authService.signOut();
        }
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
    _supabaseUser = null;
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
