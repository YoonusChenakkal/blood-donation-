import 'package:Life_Connect/user%20side/Models/campModel.dart';
import 'package:Life_Connect/user side/Providers/campsProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CampCard extends StatelessWidget {
  const CampCard({
    super.key,
    required this.camp,
  });
  final CampsModel camp;

  String formatDate(DateTime? date) {
    if (date == null) return 'Unknown Date';
    return DateFormat('MMMM d, yyyy').format(date);
  }

  String formatTime(String? time) {
    if (time == null) return 'Unknown Time';
    try {
      final parsedTime = DateFormat("HH:mm:ss").parse(time);
      return DateFormat("h:mm a").format(parsedTime);
    } catch (e) {
      return 'Invalid Time';
    }
  }

  @override
  Widget build(BuildContext context) {
    final campProvider = Provider.of<Campsprovider>(context);

    return GestureDetector(
      onTap: () => Navigator.pushNamed(
        context,
        '/campDetails',
        arguments: camp,
      ),
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 1.h, horizontal: 4.w),
        padding: EdgeInsets.all(3.w),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white,
          border: Border.all(
              color: campProvider.isRegisteredForCamp(camp.id!)
                  ? Colors.green
                  : Colors.red,
              width: 1),
          boxShadow: [
            BoxShadow(
              blurRadius: 6,
              color: Colors.grey.withOpacity(0.3),
              offset: Offset(2, 2),
            ),
          ],
        ),
        child: Stack(
          children: [
            if (campProvider.isRegisteredForCamp(camp.id!))
              Positioned(
                right: 0,
                child: Checkbox(
                  shape: CircleBorder(),
                  value: true,
                  onChanged: (value) {},
                  activeColor: Colors.green,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  camp.hospital ?? 'Unknown Hospital',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 17.5.sp,
                    fontWeight: FontWeight.w800,
                    color: Colors.red,
                  ),
                ),
                SizedBox(height: 1.h),
                Text(
                  'Date : ${formatDate(camp.date)}',
                  style: GoogleFonts.roboto(
                      fontSize: 15.sp, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 0.5.h),
                Text(
                  'Time : ${formatTime(camp.startTime)} - ${formatTime(camp.endTime)}',
                  style: GoogleFonts.roboto(
                      fontSize: 15.sp, fontWeight: FontWeight.w400),
                ),
                SizedBox(height: 1.h),
                Align(
                  alignment: Alignment.centerRight,
                  child: Text(
                    'Posted on: ${formatDate(camp.createdAt)}',
                    style: TextStyle(fontSize: 12.sp, color: Colors.grey),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
