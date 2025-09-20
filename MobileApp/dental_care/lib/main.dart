import 'package:flutter/material.dart';
import 'utils/theme.dart';
import 'services/auth_storage.dart';
import 'package:url_launcher/url_launcher.dart';

// Screens
import 'screens/login_screen.dart';
import 'screens/signup_screen.dart';
import 'screens/home_screen.dart';
import 'screens/upload_normal_screen.dart';
import 'screens/upload_xray_screen.dart';
import 'screens/result_screen.dart';
import 'screens/chatbot_screen.dart';
import 'screens/profile_screen.dart';
import 'screens/articles_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final token = await AuthStorage.getToken();
  runApp(DentalCareApp(initialRoute: token != null ? '/home' : '/login'));
}

class DentalCareApp extends StatelessWidget {
  final String initialRoute;
  const DentalCareApp({super.key, this.initialRoute = '/login'});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dental Care',
      debugShowCheckedModeBanner: false,
      theme: buildAppTheme(),
      initialRoute: initialRoute,
      routes: {
        '/login': (_) => const LoginScreen(),
        '/signup': (_) => const SignupScreen(),
        '/home': (_) => const HomeScreen(),
        '/upload_normal': (_) => const UploadNormalScreen(),
        '/upload_xray': (_) => const UploadXrayScreen(),
        '/result': (_) => const ResultScreen(),
        '/chatbot': (_) => const ChatbotScreen(),
        '/profile': (_) => const ProfileScreen(),
        '/articles': (_) => const ArticlesScreen(),
      },
    );
  }
}
