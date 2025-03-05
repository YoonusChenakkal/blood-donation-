import 'package:Life_Connect/user side//widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/bg_nurse.jpg'),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
                bottom: 0,
                child: SizedBox(
                  height: 55.h,
                  width: 100.w,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('When we ',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
                          Text(
                            'donate',
                            style: GoogleFonts.robotoSlab(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: const Color.fromARGB(255, 255, 17, 0)),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text('we connect ',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.white,
                              )),
                          Text('lives',
                              style: GoogleFonts.robotoSlab(
                                fontSize: 24.sp,
                                fontWeight: FontWeight.w500,
                                color: Colors.blue,
                              ))
                        ],
                      ),
                      Text('"Be the reason someone smiles today"',
                          style: GoogleFonts.montserrat(
                              fontSize: 14.5.sp,
                              fontWeight: FontWeight.w500,
                              color: Colors.white,
                              height: 2)),
                      SizedBox(
                        height: 5.h,
                      ),
                      Center(
                          child: CustomButton(
                              width: 60,
                              text: 'User',
                              textColor: const Color.fromARGB(255, 230, 3, 3),
                              buttonType: ButtonType.Outlined,
                              onPressed: () {
                                Navigator.pushNamed(context, '/login');
                              })),
                      SizedBox(
                        height: 1.5.h,
                      ),
                      Center(
                          child: CustomButton(
                              width: 60,
                              text: 'Hospital',
                              buttonType: ButtonType.Elevated,
                              onPressed: () {
                                Navigator.pushNamed(context, '/hospitalLogin');
                              })),
                    ],
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
