import 'package:blood_donation/Proiders/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Customdropdown extends StatelessWidget {
  bool enabled;
  Customdropdown({super.key, this.enabled = true});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);

    return Container(
      height: 6.h,
      width: 75.w,
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
              Icons.bloodtype,
              color: const Color.fromARGB(255, 102, 102, 102),
              size: 20.sp,
            ),
          ),
          Expanded(
            child: DropdownButton<String>(
              value: authProvider.bloodGroup,
              hint: Text(
                'Blood Group',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: const Color.fromARGB(255, 102, 102, 102)),
              ),
              isExpanded: true,
              onChanged: enabled // Only allow changes if enabled is true
                  ? (String? newValue) {
                      authProvider.bloodGroup = newValue;
                    }
                  : null, // If disabled, onChanged is null (dropdown is read-only)
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
                              : const Color.fromARGB(255, 156, 156, 156)),
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
  'AB-'
];
