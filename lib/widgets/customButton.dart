import 'package:blood_donation/Proiders/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonType buttonType;
  final VoidCallback onPressed;
  final double width;
  final double height;
  const CustomButton({
    required this.text,
    required this.buttonType,
    required this.onPressed,
    this.width = 40,
    this.height = 4.5,
  });

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return SizedBox(
      height: height.h,
      width: width.w,
      child: buttonType == ButtonType.Elevated
          ? ElevatedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : onPressed, // Disable button when loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 236, 26, 11),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: authProvider.isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ) // Show spinner while loading
                  : Text(
                      text,
                      style: TextStyle(fontSize: 17.sp, color: Colors.black),
                    ),
            )
          : OutlinedButton(
              onPressed: authProvider.isLoading
                  ? null
                  : onPressed, // Disable button when loading
              style: OutlinedButton.styleFrom(
                side: const BorderSide(
                  color: Color.fromARGB(255, 255, 17, 0),
                  width: 1.5,
                ),
                foregroundColor: const Color.fromARGB(255, 255, 17, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: authProvider.isLoading
                  ? CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(
                          Color.fromARGB(255, 255, 17, 0)),
                    ) // Show spinner while loading
                  : Text(
                      text,
                      style: TextStyle(fontSize: 17.sp),
                    ),
            ),
    );
  }
}

enum ButtonType { Elevated, Outlined }
