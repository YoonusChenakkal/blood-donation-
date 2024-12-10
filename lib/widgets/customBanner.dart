import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomBanner extends StatelessWidget {
  const CustomBanner({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 88.w,
      height: 18.h,
      decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(8),
          image: const DecorationImage(
              fit: BoxFit.cover,
              opacity: 0.9,
              image: NetworkImage(
                  'https://c0.wallpaperflare.com/preview/478/173/152/healthcare-hospital-lamp-light.jpg'))),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Donate If You Can',
              style: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            Text(
              'Save One Life',
              style: TextStyle(
                  fontSize: 17.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: .4.h,
            ),
            Text(
              'Make them happy',
              style: TextStyle(
                  fontSize: 14.5.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.w300),
            ),
            SizedBox(
              height: .4.h,
            ),
            SizedBox(
                height: 3.h,
                width: 20.w,
                child: ElevatedButton(
                  onPressed: () {}, // Disable button when loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 26, 11),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                  ),
                  child: Text(
                    'More',
                    style: TextStyle(fontSize: 14.sp, color: Colors.white),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
