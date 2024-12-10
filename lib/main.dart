import 'package:blood_donation/Proiders/authProvider.dart';
import 'package:blood_donation/Screens/certificateDetails.dart';
import 'package:blood_donation/Screens/home.dart';
import 'package:blood_donation/Screens/login.dart';
import 'package:blood_donation/Screens/register.dart';
import 'package:blood_donation/Screens/welcomePage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

void main() {
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return MultiProvider(providers: [
          ChangeNotifierProvider(create: (_) => AuthProvider()),
        ], child: const MainApp()); // Wrap the MainApp with Sizer
      },
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/home',
      routes: {
        '/home': (context) => const HomePage(),
        '/welcomePage': (context) => const WelcomePage(),
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/certificateDetails': (context) => const CertificateDetails(),
      },
    );
  }
}
