import 'dart:ui';

import 'package:blood_donation/Providers/authProvider.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomBanner extends StatelessWidget {
  CustomBanner({
    super.key,
    required this.title1,
    required this.title2,
    this.buttonText = '',
    this.imageUrl = '',
    this.bannerColor = const Color.fromARGB(255, 243, 243, 243),
    required this.textColor,
  });

  String imageUrl;
  String title1;
  String title2;
  String buttonText;
  Color bannerColor;
  Color textColor;

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Container(
      width: 92.w,
      height: 16.h,
      decoration: BoxDecoration(
        color: bannerColor,
        borderRadius: BorderRadius.circular(8),
        image: imageUrl.isEmpty
            ? null
            : DecorationImage(
                fit: BoxFit.cover,
                opacity: 0.9,
                image: NetworkImage(imageUrl),
              ),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 50.w,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: imageUrl.isEmpty ? 15.sp : 16.3.sp,
                          color: imageUrl.isEmpty ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold)),
                  SizedBox(height: .5.h),
                  Text(
                    title2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 14.5.sp,
                        color: imageUrl.isEmpty ? Colors.black : Colors.white,
                        fontWeight: FontWeight.w400),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            CustomButton(
                height: 3,
                width: 21.1,
                text: buttonText,
                buttonType: ButtonType.Ovelshaped,
                onPressed: () {
                  authProvider.demo();
                })
          ],
        ),
      ),
    );
  }
}
