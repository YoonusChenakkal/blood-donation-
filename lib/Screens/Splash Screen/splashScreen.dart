import 'package:blood_donation/Screens/userProfileRegister.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(parent: _controller, curve: Curves.easeIn);
    _controller.forward();

    Future.delayed(const Duration(seconds: 3), () {
      // Navigator.push(
      //     context,
      //     MaterialPageRoute(
      //       builder: (context) => UserProfile(),
      //     ));
      Navigator.pushReplacementNamed(context, '/bottomNavigationBar');
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: Center(
            child: Text(
          'Blood Donation App',
          style: GoogleFonts.pacifico(
            fontSize: 23.sp,
            color: const Color.fromARGB(255, 236, 26, 11),
          ),
        )),
      ),
    );
  }
}
