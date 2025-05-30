import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ctech/providers/theme_provider.dart';
import 'package:ctech/services/auth.dart';
import 'package:ctech/screens/splash_screen.dart';
import 'package:ctech/screens/login_screen.dart';
import 'package:ctech/screens/signup_screen.dart';
import 'package:ctech/screens/home_screen.dart';
import 'package:ctech/screens/quiz_screen.dart';
import 'package:ctech/screens/stories_screen.dart';
import 'package:ctech/screens/tech_words_screen.dart';
import 'package:ctech/screens/profile_screen.dart';
import 'package:ctech/screens/settings_screen.dart';
import 'package:ctech/screens/forgot_password_screen.dart';
import 'package:ctech/screens/career_details_screen.dart';
import 'package:ctech/screens/career_screen.dart';
import 'package:ctech/screens/verify_otp_screen.dart';
import 'package:ctech/screens/reset_password_screen.dart';

import 'package:ctech/models/career.dart';
import 'firebase_options.dart';



void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(
  //   // options: DefaultFirebaseOptions.currentPlatform,
  // ); // You should include options if using firebase_options.dart
  if (Firebase.apps.isEmpty) {
    await Firebase.initializeApp();
  }

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => ThemeProvider(),
        ),
        ChangeNotifierProvider<AuthService>(
          create: (_) => AuthService(FirebaseAuth.instance),
        ),
        StreamProvider<User?>(
          create: (context) => context.read<AuthService>().authStateChanges,
          initialData: null,
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final authState = context.watch<User?>();

    // If user is already authenticated, show home screen
    if (authState != null) {
      debugPrint('User is authenticated, showing HomeScreen');
      return MaterialApp(
        title: 'CTech',
        debugShowCheckedModeBanner: false,
        theme: themeProvider.theme,
        home: const HomeScreen(),
        routes: {
          '/login': (context) => const LoginScreen(),
          '/signup': (context) => const SignUpScreen(),
          '/home': (context) => const HomeScreen(),
          '/careers': (context) => const CareerScreen(),
          '/quiz': (context) => const QuizScreen(),
          '/stories': (context) => const StoriesScreen(),
          '/tech-words': (context) => const TechWordsScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/settings': (context) => const SettingsScreen(),
          '/forgot-password': (context) => const ForgotPasswordScreen(),
          '/career-details': (context) => CareerDetailsScreen(
                career: ModalRoute.of(context)!.settings.arguments as Career,
              ),
          '/verify-otp': (context) => VerifyOtpScreen(
                email: ModalRoute.of(context)!.settings.arguments as String,
              ),
          '/reset-password': (context) => ResetPasswordScreen(
                email: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['email']!,
                otp: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['otp']!,
              ),
        },
      );
    }

    // Show splash screen for initial load
    return MaterialApp(
      title: 'CTech',
      debugShowCheckedModeBanner: false,
      theme: themeProvider.theme,
      home: const SplashScreen(),
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignUpScreen(),
        '/home': (context) => const HomeScreen(),
        '/careers': (context) => const CareerScreen(),
        '/quiz': (context) => const QuizScreen(),
        '/stories': (context) => const StoriesScreen(),
        '/tech-words': (context) => const TechWordsScreen(),
        '/profile': (context) => const ProfileScreen(),
        '/settings': (context) => const SettingsScreen(),
        '/forgot-password': (context) => const ForgotPasswordScreen(),
        '/career-details': (context) => CareerDetailsScreen(
              career: ModalRoute.of(context)!.settings.arguments as Career,
            ),
        '/verify-otp': (context) => VerifyOtpScreen(
              email: ModalRoute.of(context)!.settings.arguments as String,
            ),
        '/reset-password': (context) => ResetPasswordScreen(
              email: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['email']!,
              otp: (ModalRoute.of(context)!.settings.arguments as Map<String, String>)['otp']!,
            ),
      },
    );
  }
}


