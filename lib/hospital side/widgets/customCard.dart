import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String? count;
  final Image image;

  const CustomCard(
      {super.key,
      required this.title,
      required this.count,
      required this.image});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 27.w,
      height: 13.h,
      padding: const EdgeInsets.all(6.0),
      decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: Colors.red,
          )),
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
                style: GoogleFonts.dosis(
                    fontWeight: FontWeight.w800, fontSize: 21.sp),
              ),
              image
            ],
          )
        ],
      ),
    );
  }
}
