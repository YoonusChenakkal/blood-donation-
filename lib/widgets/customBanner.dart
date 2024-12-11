import 'package:blood_donation/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomBanner extends StatelessWidget {
  CustomBanner(
      {super.key,
      required this.title1,
      required this.title2,
      this.buttonText = '',
      this.imageUrl = '',
      this.bannerColor = const Color.fromARGB(255, 243, 243, 243),
      required this.textColor,
      required this.onPressed});

  String imageUrl;
  String title1;
  String title2;
  String buttonText;
  Color bannerColor;
  Color textColor;
  VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 92.w,
      height: 14.5.h,
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
        padding: const EdgeInsets.only(left: 15.0, top: 12),
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
                          fontSize: imageUrl.isEmpty ? 13.6.sp : 15.sp,
                          color: imageUrl.isEmpty ? Colors.black : Colors.white,
                          fontWeight: FontWeight.bold)),
                  Text(
                    title2,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                        fontSize: 13.sp,
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
                onPressed: onPressed)
          ],
        ),
      ),
    );
  }
}
