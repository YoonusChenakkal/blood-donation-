import 'dart:async';
import 'package:blood_donation/Providers/authProvider.dart';
import 'package:blood_donation/Providers/campsProvider.dart';
import 'package:blood_donation/Providers/certificateProvider.dart';
import 'package:blood_donation/Providers/chatsProvider.dart';
import 'package:blood_donation/Providers/donorCountProvider.dart';
import 'package:blood_donation/Providers/hospitalProvider.dart';
import 'package:blood_donation/Providers/tabIndexNotifier.dart';
import 'package:blood_donation/Providers/userProfileProvider.dart';
import 'package:blood_donation/Screens/Bottom%20Naigation%20Bar/BottomNaigationBar.dart';
import 'package:blood_donation/Screens/CampDetails.dart';
import 'package:blood_donation/Screens/Splash%20Screen/splashScreen.dart';
import 'package:blood_donation/Screens/certificateDetails.dart';
import 'package:blood_donation/Screens/certificatePage.dart';
import 'package:blood_donation/Screens/chat.dart';
import 'package:blood_donation/Screens/home.dart';
import 'package:blood_donation/Screens/login.dart';
import 'package:blood_donation/Screens/profile.dart';
import 'package:blood_donation/Screens/register.dart';
import 'package:blood_donation/Screens/hospitalChat.dart';
import 'package:blood_donation/Screens/userProfileEdit.dart';
import 'package:blood_donation/Screens/userProfileRegister.dart';
import 'package:blood_donation/Screens/welcomePage.dart';
import 'package:blood_donation/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
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
          child: const MainApp(), // Wrap the MainApp with Sizer
        );
      },
    ),
  );
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
        '/certificateDetails': (context) => const CertificateDetails(),
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
                  '/certificateDetails': (context) =>
                      const CertificateDetails(),
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
