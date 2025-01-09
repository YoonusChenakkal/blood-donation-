import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? count;

  const CustomCard({super.key, required this.title, required this.count});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27.w,
      height: 12.h,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: Colors.red, width: 1.2)),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14.sp,
                color: Colors.black),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                count ?? '0',
                style: GoogleFonts.archivoBlack(
                    fontWeight: FontWeight.w400, fontSize: 22.5.sp),
              ),
              Icon(
                FontAwesomeIcons.hospital,
                color: Colors.red,
                size: 20.sp,
              )
            ],
          )
        ],
      ),
    );
  }
}
