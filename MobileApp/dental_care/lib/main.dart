import 'package:flutter/material.dart';
import 'utils/theme.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/upload_normal_screen.dart';
import 'screens/upload_xray_screen.dart';
import 'screens/result_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/profile_screen.dart';

void main() {
  runApp(const DentalCareApp());
}

class DentalCareApp extends StatelessWidget {
  const DentalCareApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Care',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: '/login',
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/upload_normal': (_) => const UploadNormalScreen(),
        '/upload_xray': (_) => const UploadXrayScreen(),
        '/result': (_) => const ResultScreen(),
        '/chatbot': (_) => const ChatbotScreen(),
        '/profile': (_) => const ProfileScreen(),
      },
    );
  }
}
