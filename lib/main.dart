import 'package:flutter/material.dart';
import 'package:ortotech/login/sign_in.dart';
import 'package:ortotech/login/welcome_page.dart';
import 'package:ortotech/login/sign_up.dart';
import 'package:firebase_core/firebase_core.dart';
import 'services/firebase_options.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  try {
    // Initialize Firebase with error handling
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase initialization error: $e');
  }

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Ortotech',
      initialRoute: '/',
      routes: {
        '/': (context) => const WelcomeScreen(), // Default route
        '/sign_in': (context) => const SignInScreen(),
        '/sign_up': (context) => const SignUpScreen(),
      },
    );
  }
}
