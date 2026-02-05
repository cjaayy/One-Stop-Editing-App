import 'package:firebase_auth/firebase_auth.dart';
import '../models/auth_result.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Get current user
  User? get currentUser => _auth.currentUser;

  // Auth state stream
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // SIGNUP WITH EMAIL VERIFICATION
  // Key steps:
  // 1. Create user with email/password
  // 2. Send verification email immediately
  // 3. Return success (DO NOT sign out yet - Firestore write needs auth)
  Future<AuthResult> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      // Create user account
      UserCredential userCredential =
          await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Send verification email
      await userCredential.user!.sendEmailVerification();

      // Update display name
      await userCredential.user!.updateDisplayName(name);

      // NOTE: Do NOT sign out here - let auth_provider write to Firestore first
      return AuthResult.success(userId: userCredential.user!.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_handleAuthException(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: $e');
    }
  }

  // LOGIN WITH VERIFICATION CHECK
  // Key steps:
  // 1. Sign in with email/password
  // 2. Reload user to get latest emailVerified status
  // 3. Check if email is verified
  // 4. If not verified: sign out and return error
  // 5. If verified: return success
  Future<AuthResult> loginWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // CRITICAL: Reload user to get latest verification status
      await userCredential.user!.reload();
      User? user = _auth.currentUser;

      // Check if email is verified
      if (user != null && !user.emailVerified) {
        // Sign out unverified user
        await _auth.signOut();
        return AuthResult.failure(
          'Email not verified. Please check your email and verify your account before logging in.',
        );
      }

      return AuthResult.success(userId: user!.uid);
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_handleAuthException(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: $e');
    }
  }

  // Resend verification email (for users who didn't receive it)
  Future<AuthResult> resendVerificationEmail({
    required String email,
    required String password,
  }) async {
    try {
      // Sign in temporarily
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      await userCredential.user!.reload();
      User? user = _auth.currentUser;

      if (user != null && !user.emailVerified) {
        await user.sendEmailVerification();
        await _auth.signOut();
        return AuthResult.success();
      } else if (user != null && user.emailVerified) {
        // Already verified
        return AuthResult.failure(
            'Email is already verified. You can log in now.');
      }

      return AuthResult.failure('User not found.');
    } on FirebaseAuthException catch (e) {
      return AuthResult.failure(_handleAuthException(e));
    } catch (e) {
      return AuthResult.failure('An unexpected error occurred: $e');
    }
  }

  // Sign out
  Future<void> signOut() async {
    await _auth.signOut();
  }

  // Handle Firebase Auth exceptions
  String _handleAuthException(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'The password is too weak.';
      case 'email-already-in-use':
        return 'An account already exists for this email.';
      case 'invalid-email':
        return 'The email address is not valid.';
      case 'user-not-found':
        return 'No user found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'network-request-failed':
        return 'Network error. Please check your connection.';
      default:
        return 'Authentication error: ${e.message}';
    }
  }
}
