import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

    checkInitialRoute();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  checkInitialRoute() async {
    final prefs = await SharedPreferences.getInstance();
    final user = prefs.getString('username');
    final userType = prefs.getString('user_type');

    if (user != null) {
      if (userType == 'hospital') {
        Navigator.pushReplacementNamed(context, '/hospitalBottomBar');
      } else {
        Navigator.pushReplacementNamed(context, '/bottomNavigationBar');
      }
    } else {
      Navigator.pushReplacementNamed(context, '/welcomePage');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: FadeTransition(
        opacity: _animation,
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/iconbg.png',
                height: 20.h,
                width: 20.h,
              ),
              SizedBox(
                height: 1.h,
              ),
              RichText(
                text: TextSpan(
                  text: 'Life ', // "Life" part
                  style: GoogleFonts.cairoPlay(
                    fontSize: 26.sp,
                    fontWeight: FontWeight.w700,
                    color: Colors.black, // Black color for "Life"
                  ),
                  children: [
                    TextSpan(
                      text: 'Connect', // "Connect" part
                      style: GoogleFonts.novaSquare(
                        fontSize: 26.sp,
                        fontWeight: FontWeight.w700,
                        color: const Color.fromARGB(
                            255, 236, 26, 11), // Red color for "Connect"
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
