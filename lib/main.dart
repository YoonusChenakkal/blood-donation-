import 'package:Life_Connect/Splash%20Screen/splashScreen.dart';
import 'package:Life_Connect/hospital%20side/Providers/authProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/campaignProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/chatsProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/donorProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/hosptalCountProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/profileProvider.dart';
import 'package:Life_Connect/hospital%20side/Screens/Bottom%20Naigation%20Bar/BottomNaigationBar.dart';
import 'package:Life_Connect/hospital%20side/Screens/campDetails.dart';
import 'package:Life_Connect/hospital%20side/Screens/donorChat.dart';
import 'package:Life_Connect/hospital%20side/Screens/donorDetails.dart';
import 'package:Life_Connect/hospital%20side/Screens/donorList.dart';
import 'package:Life_Connect/hospital%20side/Screens/editCampDetails.dart';
import 'package:Life_Connect/hospital%20side/Screens/editProfileDetails.dart';
import 'package:Life_Connect/hospital%20side/Screens/home.dart';
import 'package:Life_Connect/hospital%20side/Screens/login.dart';
import 'package:Life_Connect/hospital%20side/Screens/profile.dart';
import 'package:Life_Connect/hospital%20side/Screens/register.dart';
import 'package:Life_Connect/hospital%20side/Screens/registerCampaign.dart';
import 'package:Life_Connect/hospital%20side/Screens/shedule.dart';
import 'package:Life_Connect/hospital%20side/Services/authService.dart';
import 'package:Life_Connect/user side/Providers/authProvider.dart';
import 'package:Life_Connect/user side/Providers/campsProvider.dart';
import 'package:Life_Connect/user side/Providers/certificateProvider.dart';
import 'package:Life_Connect/user side/Providers/chatsProvider.dart';
import 'package:Life_Connect/user side/Providers/donorCountProvider.dart';
import 'package:Life_Connect/user side/Providers/hospitalProvider.dart';
import 'package:Life_Connect/tabIndexNotifier.dart';
import 'package:Life_Connect/user side/Providers/userProfileProvider.dart';
import 'package:Life_Connect/user side/Screens/Bottom%20Naigation%20Bar/BottomNaigationBar.dart';
import 'package:Life_Connect/user side/Screens/CampDetails.dart';
import 'package:Life_Connect/user side/Screens/certificatePage.dart';
import 'package:Life_Connect/user side/Screens/chat.dart';
import 'package:Life_Connect/user side/Screens/home.dart';
import 'package:Life_Connect/user side/Screens/login.dart';
import 'package:Life_Connect/user side/Screens/profile.dart';
import 'package:Life_Connect/user side/Screens/register.dart';
import 'package:Life_Connect/user side/Screens/hospitalChat.dart';
import 'package:Life_Connect/user side/Screens/userProfileEdit.dart';
import 'package:Life_Connect/user side/Screens/userProfileRegister.dart';
import 'package:Life_Connect/welcomePage.dart';
import 'package:Life_Connect/user side/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
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
              // user Side ----------------->
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

              // Hospital Side ----------------->

              ChangeNotifierProvider(create: (_) => HospitalAuthProvider()),
              ChangeNotifierProvider(create: (_) => TabIndexNotifier()),
              ChangeNotifierProvider(create: (_) => HospitalChatsProvider()),
              ChangeNotifierProvider(
                  create: (_) => HospitalCountProvider()..loadHospitalCount()),
              ChangeNotifierProvider(
                  create: (_) =>
                      HospitalProfileProvider()..fetchHospitalProfile()),
              ChangeNotifierProvider(
                  create: (_) =>
                      HospitalCampaignProvider()..fetchCamps(context)),
              Provider(create: (_) => HospitalAuthService()),
              ChangeNotifierProvider(
                  create: (_) => HospitalDonorProvider()..loadDonors()),
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

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/splashScreen',
      routes: {        '/splashScreen': (context) => SplashScreen(),

        // user Side ----------->
        '/welcomePage': (context) => const WelcomePage(),
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
        
        // hospital Side 
        '/hospitalBottomBar' : (context)=> const HospitalCustomBottomNavigationBar(),
        '/hospitalRegister': (context) => const HospitalRegister(),
        '/hospitalLogin': (context) => const HospitalLogin(),
        '/hospitalHome': (context) => const HospitalHomePage(),
        '/hospitalShedule': (context) => const HospitalShedulePage(),
        '/hospitalDonorChat': (context) => const HospitalDonorChat(),
        '/hospitalProfile': (context) => const HospitalProfilePage(),
        '/hospitalDonorList': (context) => const HospitalDonorListPage(),
        '/hospitalSheduledCamp': (context) => const HospitalRegisterCampaign(),
        '/hospitalCampDetails': (context) => const HospitalCampDetails(),
        'hospitalEditCampDetails': (context) => const HospitalEditCampDetails(),
        '/hospitalEditProfileDetails': (context) => const HospitalEditProfileDetails(),
        '/hospitalDonorDetails': (context) => const HospitalDonordetails(),

      },
    );
  }
}
