import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CertificatePreview extends StatelessWidget {
  const CertificatePreview({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 31.h,
      width: 90.w,
      margin: EdgeInsets.only(top: 3.h, bottom: 4.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage(
                'assets/certificate.png',
              ),
              fit: BoxFit.cover)),
      child: Stack(
        children: [
          Center(
            child: Text('Yoonus', style: TextStyle(fontSize: 20.sp)),
          ),
          Positioned(
              bottom: 11.h,
              left: 22.w,
              child: Text(' Here He/She pledge for Organ Donation',
                  style: TextStyle(fontSize: 11.5.sp))),
          Positioned(
              bottom: 6.h,
              left: 21.w,
              child: Text(DateFormat('dd-MM-yyyy').format(DateTime.now()),
                  style: TextStyle(fontSize: 13.sp))),
          Positioned(
              bottom: 6.h,
              right: 26.w,
              child: Text('Sign', style: TextStyle(fontSize: 14.sp)))
        ],
      ),
    );
  }
}
