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
}
