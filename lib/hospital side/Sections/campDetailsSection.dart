import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CampDetailsSection extends StatelessWidget {
  const CampDetailsSection({super.key, required this.filteredCamp});
  final filteredCamp;

  String formatDate(DateTime? date) {
    if (date == null) return 'Unknown Date';
    return DateFormat('MMMM d, yyyy').format(date); // Example: January 9, 2025
  }

  String formatTime(String? time) {
    if (time == null) return 'Unknown Time';
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("h:mm a").format(parsedTime); // Example: 10:00 AM
    } catch (e) {
      return 'Invalid Time';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h, bottom: 4.h),
      padding: EdgeInsets.all(3.w),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.red, width: 1.4),
        boxShadow: const [
          BoxShadow(
            blurRadius: 8,
            color: Color.fromARGB(90, 0, 0, 0),
            offset: Offset(2, 1),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(top: 1.5.h, bottom: 3.h),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(6),
                color: Colors.red,
              ),
              child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 12.0),
                  child: Text(
                    filteredCamp.hospital ?? 'No Name',
                    style: TextStyle(
                        fontSize: 24.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.w600),
                  ))),
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Time:',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Date:',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Location:',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      'Description:',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                flex: 4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${formatTime(filteredCamp.startTime)} - ${formatTime(filteredCamp.endTime)}',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      formatDate(filteredCamp.date),
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      filteredCamp.location ?? 'Unknown Location',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      filteredCamp.description ?? 'No Description',
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(2.0),
                          child: Text(
                            "Posted on : ${formatDate(filteredCamp.createdAt)}",
                            style:
                                TextStyle(fontSize: 13.sp, color: Colors.black),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
