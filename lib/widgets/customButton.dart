import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonType buttonType;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool isLoading;
  const CustomButton({
    required this.text,
    required this.buttonType,
    required this.onPressed,
    this.isLoading = false,
    this.width = 40,
    this.height = 4.5,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height.h,
      width: width.w,
      child: buttonType == ButtonType.Elevated
          ? ElevatedButton(
              onPressed:
                  isLoading ? null : onPressed, // Disable button when loading
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color.fromARGB(255, 232, 15, 0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
              child: isLoading
                  ? const CircularProgressIndicator(
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.black),
                    ) // Show spinner while loading
                  : Text(
                      text,
                      style: TextStyle(fontSize: 17.sp, color: Colors.black),
                    ),
            )
          : buttonType == ButtonType.Ovelshaped
              ? ElevatedButton(
                  onPressed: isLoading
                      ? null
                      : onPressed, // Disable button when loading
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 236, 26, 11),
                    shape: const StadiumBorder(), // Oval shape
                  ),
                  child: isLoading
                      ? SizedBox(
                          height: height.h - .5.h,
                          width: height.h - .5.h,
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ) // Show spinner while loading
                      : Text(
                          text,
                          style:
                              TextStyle(fontSize: 10.sp, color: Colors.white),
                        ),
                )
              : OutlinedButton(
                  onPressed: isLoading
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
                  child: isLoading
                      ? const CircularProgressIndicator(
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

enum ButtonType { Elevated, Outlined, Ovelshaped }
