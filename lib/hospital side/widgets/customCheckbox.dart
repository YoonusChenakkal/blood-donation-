import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomCheckbox extends StatelessWidget {
  bool isChecked;
  ValueChanged<bool?> onChanged; // Callback to notify changes
  String title;

  CustomCheckbox({
    Key? key,
    this.title = '',
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        top: 1.5.h,
        left: 18.w,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Checkbox(
            value: isChecked,
            onChanged: onChanged,
            activeColor: Colors.amber,
          ),
          SizedBox(
            width: 2.w,
          ),
          Text(
            title,
            style: TextStyle(fontSize: 14.sp, color: Colors.white),
          ),
        ],
      ),
    );
  }
}
