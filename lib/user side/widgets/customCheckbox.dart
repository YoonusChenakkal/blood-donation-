import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class CustomCheckbox extends StatelessWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged; // Callback to notify changes
  final String title;
  final Color textColor;

  CustomCheckbox(
      {Key? key,
      this.title = '',
      required this.isChecked,
      required this.onChanged,
      this.textColor = Colors.blueGrey})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: GoogleFonts.cabin(
                fontSize: 15.sp, fontWeight: FontWeight.w500, color: textColor),
          ),
          SizedBox(width: 1.5.w), // Adjusted space between text and checkbox
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: Colors.red,
            materialTapTargetSize:
                MaterialTapTargetSize.shrinkWrap, // Reduces checkbox padding
          ),
        ],
      ),
    );
  }
}
