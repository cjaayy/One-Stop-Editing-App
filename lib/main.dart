import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'providers/auth_provider.dart';
import 'screens/splash_screen.dart';
import 'utils/constants.dart';
import 'services/supabase_config.dart';

void main() async {
  // Ensure Flutter bindings are initialized
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Supabase
  // Load local .env (if present) before initializing Supabase.
  // If you prefer dart-define, that's still supported.
  try {
    await dotenv.load(fileName: '.env', isOptional: true);
  } catch (error) {
    debugPrint('Unable to load .env; continuing with fallback values: $error');
  }

  final supabaseUrl = SupabaseConfig.url;
  final supabaseAnonKey = SupabaseConfig.anonKey;

  if (supabaseUrl.contains('YOUR_PROJECT.supabase.co') ||
      supabaseAnonKey.contains('YOUR_SUPABASE_ANON_KEY')) {
    debugPrint(
        'Supabase credentials are not configured. Signup will fail until .env or dart-define values are provided.');
  }

  await Supabase.initialize(
    url: supabaseUrl,
    publishableKey: supabaseAnonKey,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
      ],
      child: MaterialApp(
        title: AppStrings.appName,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: AppColors.darkRed),
          useMaterial3: true,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
