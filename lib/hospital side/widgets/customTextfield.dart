import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomTextfield extends StatelessWidget {
  final double height;
  final double width;
  final int? maxLines;
  final int? maxlenth;
  final int? minLines;
  final bool enabled;
  final String hintText;
  final IconData icon;
  final TextInputType keyboardType;
  final TextEditingController? tc;
  final Function(String) onChanged;
  const CustomTextfield(
      {super.key,
      this.height = 6,
      this.width = 85,
      this.minLines,
      this.maxlenth,
      this.maxLines = 1,
      this.hintText = '',
      this.tc,
      this.enabled = true,
      required this.icon,
      required this.onChanged,
      required this.keyboardType});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height.h,
      width: width.w,
      decoration: ShapeDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
      ),
      child: TextField(
        enabled: enabled,
        keyboardType: keyboardType,
        controller: tc,
        onChanged: onChanged,
        maxLength: maxlenth,
        maxLines: maxLines,
        minLines: minLines,
        style: TextStyle(fontSize: 17.sp),
        textAlignVertical: TextAlignVertical.center,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(
              fontSize: 14, color: Color.fromARGB(255, 102, 102, 102)),
          counterText: '', // Hides the counter (char limit), if you have one
          errorStyle: TextStyle(fontSize: 10.sp),
          border: InputBorder.none,
          contentPadding: EdgeInsets.only(
            right: 2.w,
            left: 2.w,
          ),
          prefixIcon: Padding(
            padding: EdgeInsets.only(left: .5.w, right: 2.w),
            child: Icon(
              icon,
              color: const Color.fromARGB(255, 102, 102, 102),
              size: 20,
            ),
          ),
        ),
      ),
    );
  }
}
