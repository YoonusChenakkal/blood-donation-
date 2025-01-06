import 'package:blood_donation/Models/campsModel.dart';
import 'package:blood_donation/Providers/authProvider.dart';
import 'package:blood_donation/Providers/campsProvider.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';

class CampDetails extends StatelessWidget {
  const CampDetails({super.key});

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
    final campProvider = Provider.of<Campsprovider>(context);
    final CampsModel camp =
        ModalRoute.of(context)!.settings.arguments as CampsModel;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Camp Details',
          style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Container(
            margin:
                EdgeInsets.only(left: 3.w, right: 3.w, top: 5.h, bottom: 4.h),
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
                    margin: EdgeInsets.only(top: 1.5.h, bottom: 4.h),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(6),
                      color: Colors.red,
                    ),
                    child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 12.0),
                        child: Text(
                          camp.hospital ?? 'No Name',
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
                            '${formatTime(camp.startTime)} - ${formatTime(camp.endTime)}',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            formatDate(camp.date),
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            camp.location ?? 'Unknown Location',
                            style: TextStyle(
                              fontSize: 18.sp,
                              fontWeight: FontWeight.w400,
                              color: Colors.black87,
                            ),
                          ),
                          SizedBox(height: 1.h),
                          Text(
                            camp.description ?? 'No Description',
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
                                  "Posted on : ${formatDate(camp.createdAt)}",
                                  style: TextStyle(
                                      fontSize: 13.sp, color: Colors.black),
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
          ),
          campProvider.isRegisteredForCamp(camp.id!)
              ? CustomButton(
                  text: 'Registered',
                  buttonType: ButtonType.Outlined,
                  onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('User Already Registered'),
                      duration: Duration(seconds: 2),
                    ),
                  ),
                )
              : CustomButton(
                  text: 'Register',
                  height: 6,
                  isLoading: campProvider.isLoading,
                  buttonType: ButtonType.Elevated,
                  onPressed: () => _showExitDialog(camp, context),
                ),
        ],
      ),
    );
  }

  _showExitDialog(CampsModel camp, BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('Registration'),
        content: const Text('Are you sure you want to Register?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);

              final campsProvider =
                  Provider.of<Campsprovider>(parentContext, listen: false);

              final prefs = await SharedPreferences.getInstance();
              String? username = prefs.getString('username');

              if (username == null) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(content: Text('Please login first.')),
                );
                return;
              }

              final message = await campsProvider.registerInCamp(
                username,
                camp.id!,
              );

              if (message != null) {
                ScaffoldMessenger.of(parentContext).showSnackBar(
                  SnackBar(content: Text(message)),
                );
              }
            },
            child: const Text(
              'Confirm',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
