import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/auth_result.dart';
import 'supabase_config.dart';

class AuthService {
  SupabaseClient get _client => Supabase.instance.client;

  User? get currentUser => _client.auth.currentUser;

  Stream<User?> get authStateChanges =>
      _client.auth.onAuthStateChange.map((data) => data.session?.user);

  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final response = await _client.auth.signUp(
        email: email,
        password: password,
        data: {'name': name},
        emailRedirectTo: SupabaseConfig.redirectUrl,
      );

      return AuthResult.success(userId: response.user?.id);
    } on AuthException catch (e) {
      return AuthResult.failure(_handleAuthException(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: $e');
    }
  }

  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final response = await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = response.user;
      if (user == null) {
        return AuthResult.failure('Unable to sign in.');
      }

      final isEmailConfirmed = user.emailConfirmedAt != null;
      if (!isEmailConfirmed) {
        await _client.auth.signOut();
        return AuthResult.failure(
          'Email not verified. Please check your email and verify your account before logging in.',
        );
      }

      return AuthResult.success(userId: user.id);
    } on AuthException catch (e) {
      return AuthResult.failure(_handleAuthException(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: $e');
    }
  }

  Future<AuthResult> resendVerificationEmail({
    required String email,
    required String password,
  }) async {
    try {
      await _client.auth.signInWithPassword(
        email: email,
        password: password,
      );

      final user = _client.auth.currentUser;
      if (user != null && user.emailConfirmedAt == null) {
        await _client.auth.resend(
          type: OtpType.signup,
          email: email,
          emailRedirectTo: SupabaseConfig.redirectUrl,
        );
        await _client.auth.signOut();
        return AuthResult.success();
      } else if (user != null && user.emailConfirmedAt != null) {
        return AuthResult.failure(
            'Email is already verified. You can log in now.');
      }

      return AuthResult.failure('User not found.');
    } on AuthException catch (e) {
      return AuthResult.failure(_handleAuthException(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: $e');
    }
  }

  Future<void> signOut() async {
    await _client.auth.signOut();
  }

  String formatAuthExceptionMessage(AuthException e) {
    final message = e.message.toLowerCase();

    if (message.contains('password') && message.contains('weak')) {
      return 'The password is too weak.';
    }
    if (message.contains('already registered') ||
        message.contains('already exists')) {
      return 'An account already exists for this email.';
    }
    if (message.contains('invalid email')) {
      return 'The email address is not valid.';
    }
    if (message.contains('user not found')) {
      return 'No user found with this email.';
    }
    if (message.contains('incorrect password') ||
        message.contains('invalid login credentials')) {
      return 'Incorrect password.';
    }
    if (message.contains('rate limit') ||
        message.contains('email rate limit') ||
        message.contains('too many requests')) {
      return 'Too many emails were sent too quickly. Please wait a few minutes before trying again.';
    }
    if (message.contains('network')) {
      return 'Network error. Please check your connection.';
    }
    return 'Authentication error: ${e.message}';
  }

  String _handleAuthException(AuthException e) {
    return formatAuthExceptionMessage(e);
  }
}
