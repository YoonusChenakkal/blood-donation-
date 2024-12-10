import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextfield extends StatelessWidget {
  CustomTextfield(
      {super.key,
      this.hintText = '',
      this.enabled = true,
      required this.icon,
      required this.onChanged});
  bool enabled;
  String hintText;
  IconData icon;
  Function(String) onChanged;
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      width: 75.w,
      decoration: ShapeDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: TextField(
        enabled: enabled,
        // controller: tc,
        onChanged: onChanged,
        style: TextStyle(fontSize: 17.sp),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: TextStyle(
              fontSize: 16.sp, color: const Color.fromARGB(255, 102, 102, 102)),
          counterText: '', // Hides the counter (char limit), if you have one
          errorStyle: TextStyle(fontSize: 10.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.symmetric(horizontal: 2.w, vertical: 13),
          prefixIcon: Padding(
            padding: EdgeInsets.only(right: 2.w),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 102, 102, 102),
              size: 20.sp,
            ),
          ),
        ),
      ),
    );
  }
}
