import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sizer/sizer.dart';

class CustomCard extends StatelessWidget {
  const CustomCard({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10.5.h,
      height: 10.5.h,
      decoration: BoxDecoration(
        color: Colors.red[50],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.all(6.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Total',
              style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13.sp,
                  color: Colors.black),
            ),
            Text(
              'Donations',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13.sp),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(
                  '4',
                  style:
                      TextStyle(fontWeight: FontWeight.w900, fontSize: 19.sp),
                ),
                Icon(
                  FontAwesomeIcons.hospital,
                  color: Colors.blueAccent,
                  size: 17.sp,
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}
