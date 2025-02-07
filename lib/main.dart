import 'dart:async';
import 'package:Life_Connect/Providers/authProvider.dart';
import 'package:Life_Connect/Providers/campsProvider.dart';
import 'package:Life_Connect/Providers/certificateProvider.dart';
import 'package:Life_Connect/Providers/chatsProvider.dart';
import 'package:Life_Connect/Providers/donorCountProvider.dart';
import 'package:Life_Connect/Providers/hospitalProvider.dart';
import 'package:Life_Connect/Providers/tabIndexNotifier.dart';
import 'package:Life_Connect/Providers/userProfileProvider.dart';
import 'package:Life_Connect/Screens/Bottom%20Naigation%20Bar/BottomNaigationBar.dart';
import 'package:Life_Connect/Screens/CampDetails.dart';
import 'package:Life_Connect/Screens/Splash%20Screen/splashScreen.dart';
import 'package:Life_Connect/Screens/certificatePage.dart';
import 'package:Life_Connect/Screens/chat.dart';
import 'package:Life_Connect/Screens/home.dart';
import 'package:Life_Connect/Screens/login.dart';
import 'package:Life_Connect/Screens/profile.dart';
import 'package:Life_Connect/Screens/register.dart';
import 'package:Life_Connect/Screens/hospitalChat.dart';
import 'package:Life_Connect/Screens/userProfileEdit.dart';
import 'package:Life_Connect/Screens/userProfileRegister.dart';
import 'package:Life_Connect/Screens/welcomePage.dart';
import 'package:Life_Connect/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/services.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  // Lock orientation to portrait
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]).then((_) {
    runApp(
      Sizer(
        builder: (context, orientation, deviceType) {
          return MultiProvider(
            providers: [
              ChangeNotifierProvider(create: (_) => AuthProvider()),
              ChangeNotifierProvider(create: (_) => TabIndexNotifier()),
              ChangeNotifierProvider(
                  create: (_) => UserProfileProvider()..fetchUserProfile()),
              ChangeNotifierProvider(create: (_) => ChatsProvider()),
              ChangeNotifierProvider(
                  create: (_) => CertificateProvider()..fetchCertificate()),
              ChangeNotifierProvider(
                  create: (_) => HospitalProvider()..fetchHospitals()),
              ChangeNotifierProvider(
                  create: (_) => DonorCountProvider()..loadDonorCount()),
              ChangeNotifierProvider(
                  create: (_) => Campsprovider()..fetchCamps(context)),
              Provider(create: (_) => AuthService()),
            ],
            child: const MainApp(),
          );
        },
      ),
    );
  });
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // Function to check whether uniqueId is present in SharedPreferences
  Future<String> checkInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    String? user = prefs.getString('username');
    // If uniqueId exists, return '/home' (i.e., Bottom Navigation Bar), otherwise '/welcomePage'
    return user != null && user.isNotEmpty ? '/splashScreen' : '/welcomePage';
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      // Use FutureBuilder to check if uniqueId exists
      initialRoute: '/',
      routes: {
        '/welcomePage': (context) => const WelcomePage(),
        '/splashScreen': (context) => SplashScreen(),
        '/register': (context) => const Register(),
        '/login': (context) => const Login(),
        '/home': (context) => const HomePage(),
        '/chats': (context) => const ChatsPage(),
        '/hospitalChat': (context) => const HospitalChat(),
        '/profile': (context) => const ProfilePage(),
        '/bottomNavigationBar': (context) => const CustomBottomNavigationBar(),
        '/userProfile': (context) => const UserProfile(),
        '/certificatePage': (context) => const CertificatePage(),
        '/campDetails': (context) => const CampDetails(),
        '/userProfileEdit': (context) => const UserProfileEdit(),
      },
      // Use FutureBuilder to asynchronously set initial route based on uniqueId presence
      builder: (context, child) {
        return FutureBuilder<String>(
          future: checkInitialRoute(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return MaterialApp(
                initialRoute: snapshot.data,
                routes: {
                  '/welcomePage': (context) => const WelcomePage(),
                  '/splashScreen': (context) => SplashScreen(),
                  '/register': (context) => const Register(),
                  '/login': (context) => const Login(),
                  '/home': (context) => const HomePage(),
                  '/chats': (context) => const ChatsPage(),
                  '/hospitalChat': (context) => const HospitalChat(),
                  '/profile': (context) => const ProfilePage(),
                  '/bottomNavigationBar': (context) =>
                      const CustomBottomNavigationBar(),
                  '/userProfile': (context) => const UserProfile(),
                  '/certificatePage': (context) => const CertificatePage(),
                  '/campDetails': (context) => const CampDetails(),
                  '/userProfileEdit': (context) => const UserProfileEdit(),
                },
              );
            }
            return const Center(child: CircularProgressIndicator());
          },
        );
      },
    );
  }
}
