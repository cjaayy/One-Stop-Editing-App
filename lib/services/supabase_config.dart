import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class SupabaseConfig {
  // Priority: .env (via flutter_dotenv) -> Dart define (--dart-define) -> fallback placeholder
  static String get url {
    try {
      if (dotenv.isInitialized) {
        final fromDotenv = dotenv.env['SUPABASE_URL'];
        if (fromDotenv != null && fromDotenv.isNotEmpty) return fromDotenv;
      }
    } catch (error) {
      debugPrint('SupabaseConfig.url fallback due to dotenv error: $error');
    }

    return const String.fromEnvironment(
      'SUPABASE_URL',
      defaultValue: 'https://YOUR_PROJECT.supabase.co',
    );
  }

  static String get anonKey {
    try {
      if (dotenv.isInitialized) {
        final fromDotenv = dotenv.env['SUPABASE_ANON_KEY'];
        if (fromDotenv != null && fromDotenv.isNotEmpty) return fromDotenv;
      }
    } catch (error) {
      debugPrint('SupabaseConfig.anonKey fallback due to dotenv error: $error');
    }

    return const String.fromEnvironment(
      'SUPABASE_ANON_KEY',
      defaultValue: 'YOUR_SUPABASE_ANON_KEY',
    );
  }

  static bool get hasValidCredentials {
    final urlValue = url;
    final keyValue = anonKey;

    return urlValue.contains('supabase.co') &&
        !urlValue.contains('YOUR_PROJECT.supabase.co') &&
        keyValue.isNotEmpty &&
        !keyValue.contains('YOUR_SUPABASE_ANON_KEY');
  }

  static List<String> get adminEmails {
    try {
      if (dotenv.isInitialized) {
        final fromDotenv = dotenv.env['ADMIN_EMAILS'];
        if (fromDotenv != null && fromDotenv.isNotEmpty) {
          return fromDotenv
              .split(',')
              .map((value) => value.trim())
              .where((value) => value.isNotEmpty)
              .toList();
        }
      }
    } catch (error) {
      debugPrint(
          'SupabaseConfig.adminEmails fallback due to dotenv error: $error');
    }

    const configured = String.fromEnvironment(
      'ADMIN_EMAILS',
      defaultValue: '',
    );

    return configured
        .split(',')
        .map((value) => value.trim())
        .where((value) => value.isNotEmpty)
        .toList();
  }
}
