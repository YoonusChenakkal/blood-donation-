import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class Customdropdown extends StatelessWidget {
  final bool enabled;
  final String hintText;
  final String? selectedValue;
  final Function(String?)? onChanged; // Add a callback function

  Customdropdown({
    super.key,
    this.enabled = true,
    required this.hintText,
    this.selectedValue,
    this.onChanged, // Accept the callback in the constructor
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6.h,
      width: 85.w,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(6),
      ),
      child: Row(
        children: [
          Padding(
            padding: EdgeInsets.only(right: 4.w),
            child: Icon(
              Icons.bloodtype_outlined,
              color: const Color.fromARGB(255, 102, 102, 102),
              size: 20.sp,
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
              value: selectedValue,
              hint: Text(
                hintText,
                style: TextStyle(
                  fontSize: 15.sp,
                  color: const Color.fromARGB(255, 102, 102, 102),
                ),
              ),
              isExpanded: true,
              onChanged: enabled ? onChanged : null, // Use the passed callback
              items: bloodTypes.map<DropdownMenuItem<String>>(
                (String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(
                      value,
                      style: TextStyle(
                        fontSize: 17.sp,
                        color: enabled
                            ? Colors.black
                            : const Color.fromARGB(255, 156, 156, 156),
                      ),
                    ),
                  );
                },
              ).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

final List<String> bloodTypes = [
  'A+',
  'A-',
  'B+',
  'B-',
  'O+',
  'O-',
  'AB+',
  'AB-',
];
