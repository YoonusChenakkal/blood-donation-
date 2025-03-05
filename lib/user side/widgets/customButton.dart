import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final ButtonType buttonType;
  final VoidCallback onPressed;
  final double width;
  final double height;
  final bool isLoading;
  final Color color;
  final Color textColor;
  const CustomButton({
    required this.text,
    required this.buttonType,
    required this.onPressed,
    this.isLoading = false,
    this.color = const Color.fromARGB(255, 230, 3, 3),
    this.textColor = Colors.black,
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
                backgroundColor: color,
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
                      style: GoogleFonts.nunito(
                          fontSize: 17.sp,
                          color: textColor,
                          fontWeight: FontWeight.w700),
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
                          child: const CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(Colors.white),
                          ),
                        ) // Show spinner while loading
                      : Text(
                          text,
                          style: GoogleFonts.aBeeZee(
                              fontSize: 13.sp, color: Colors.white),
                        ),
                )
              : OutlinedButton(
                  onPressed: isLoading
                      ? null
                      : onPressed, // Disable button when loading
                  style: OutlinedButton.styleFrom(
                    side: BorderSide(
                      color: color,
                      width: 1.5,
                    ),
                    foregroundColor: Color.fromARGB(255, 255, 17, 0),
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
                          style: GoogleFonts.nunito(
                              fontSize: 17.sp, fontWeight: FontWeight.w700),
                        ),
                ),
    );
  }
}

enum ButtonType { Elevated, Outlined, Ovelshaped }
