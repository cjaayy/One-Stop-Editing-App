import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:one_stop_editor/services/auth_service.dart';
import 'package:one_stop_editor/services/supabase_config.dart';

void main() {
  test('Supabase credentials resolve to real values from .env', () async {
    await dotenv.load(fileName: '.env', isOptional: true);

    expect(SupabaseConfig.url, isNot(contains('YOUR_PROJECT.supabase.co')));
    expect(SupabaseConfig.anonKey, isNot(contains('YOUR_SUPABASE_ANON_KEY')));
    expect(SupabaseConfig.hasValidCredentials, isTrue);
  });

  test('Redirect URL normalization blocks localhost and keeps the app callback',
      () {
    expect(
      SupabaseConfig.normalizeRedirectUrl('http://localhost:3000/?code=abc'),
      equals('one-stop-editor://login-callback'),
    );

    expect(
      SupabaseConfig.normalizeRedirectUrl('one-stop-editor://login-callback'),
      equals('one-stop-editor://login-callback'),
    );
  });

  test('AuthService maps rate-limit errors to a friendly message', () {
    final service = AuthService();

    final message = service.formatAuthExceptionMessage(
      const AuthException('email rate limit exceeded'),
    );

    expect(
      message,
      contains('Too many emails were sent too quickly'),
    );
  });
}
