import 'package:flutter/material.dart';
import 'screens/home_screen.dart';
import 'screens/upload_normal_screen.dart';
import 'screens/upload_xray_screen.dart';
import 'screens/result_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/tips_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';

void main() {
  runApp(DentalCareApp());
}

class DentalCareApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Dental Care',
      theme: ThemeData(
        primarySwatch: Colors.teal,
        scaffoldBackgroundColor: Colors.white,
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/signup': (context) => SignupScreen(),
        '/home': (context) => HomeScreen(),
        '/upload_normal': (context) => UploadNormalScreen(),
        '/upload_xray': (context) => UploadXrayScreen(),
        '/result': (context) => ResultScreen(),
        '/chatbot': (context) => ChatbotScreen(),
        '/tips': (context) => TipsScreen(),
        '/profile': (context) => ProfileScreen(),
      },
    );
  }
}
