import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class CustomCheckbox extends StatefulWidget {
  final bool isChecked;
  final ValueChanged<bool?> onChanged; // Callback to notify changes
  final title;
  const CustomCheckbox({
    Key? key,
    this.title = '',
    required this.isChecked,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomCheckbox> createState() => _CustomCheckboxState();
}

class _CustomCheckboxState extends State<CustomCheckbox> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 5.h,
      width: 75.w,
      child: CheckboxListTile(
        title: Text(
          widget.title,
          style: TextStyle(fontSize: 14.sp, color: Colors.white),
        ),
        controlAffinity: ListTileControlAffinity.leading,
        value: widget.isChecked,
        onChanged: widget.onChanged,
        activeColor: Colors.amber,
      ),
    );
  }
}
