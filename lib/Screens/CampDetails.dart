import 'package:Life_Connect/Models/campsModel.dart';
import 'package:Life_Connect/Providers/campsProvider.dart';
import 'package:Life_Connect/widgets/customButton.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class CampDetails extends StatelessWidget {
  const CampDetails({super.key});

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
    final CampsModel camp =
        ModalRoute.of(context)!.settings.arguments as CampsModel;

    openMap(String location) async {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${camp.location}');
      if (camp.location != null) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Unable to Open Map')));
      }
    }

    return Scaffold(
      backgroundColor: Colors.grey[100],
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            color: Colors.redAccent,
          ),
        ),
        toolbarHeight: 8.h,
        title: Text(
          'Camp Details',
          style: GoogleFonts.poppins(
            fontSize: 20.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
          ),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // Hero Header
            Hero(
              tag: camp.id ?? 'unknown_id',
              child: Container(
                width: 100.w,
                margin: EdgeInsets.all(4.w),
                padding: EdgeInsets.all(4.w),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  gradient: const LinearGradient(
                    colors: [Colors.redAccent, Colors.pinkAccent],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 12,
                      color: Colors.black.withOpacity(0.15),
                      offset: Offset(2, 4),
                    ),
                  ],
                ),
                child: Text(
                  camp.hospital ?? 'No Name',
                  style: GoogleFonts.nunitoSans(
                    fontSize: 22.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
            // Details Section
            _buildDetailsCard(
              icon: Icons.date_range,
              title: 'Date',
              value: formatDate(camp.date),
            ),
            _buildDetailsCard(
              icon: Icons.access_time,
              title: 'Time',
              value:
                  '${formatTime(camp.startTime)} - ${formatTime(camp.endTime)}',
            ),
            _buildDetailsCard(
              icon: Icons.location_pin,
              title: 'Location',
              value: camp.location ?? 'Unknown Location',
              isInteractive: true,
              onTap: () => openMap(camp.location ?? ''),
            ),
            _buildDetailsCard(
                icon: Icons.notes_rounded,
                title: 'Description',
                value: camp.description ?? ''),
            SizedBox(height: 3.h),
            // Registration Section
            Center(
              child: campProvider.isRegisteredForCamp(camp.id!)
                  ? CustomButton(
                      height: 5.3,
                      width: 50,
                      color: campProvider.isRegisteredForCamp(camp.id)
                          ? Colors.green
                          : Colors.red,
                      textColor: campProvider.isRegisteredForCamp(camp.id)
                          ? Colors.green
                          : Colors.red,
                      text: 'Registered',
                      buttonType: ButtonType.Outlined,
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'You are already registered.',
                              style: TextStyle(color: Colors.white),
                            ),
                            backgroundColor: Colors.green,
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                    )
                  : CustomButton(
                      textColor: Colors.white,
                      text: 'Register',
                      height: 5.3,
                      width: 50,
                      isLoading: campProvider.isLoading,
                      buttonType: ButtonType.Elevated,
                      onPressed: () => _showExitDialog(camp, context),
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsCard({
    required IconData icon,
    required String title,
    required String value,
    bool isInteractive = false,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: isInteractive ? onTap : null,
      child: Card(
        margin: EdgeInsets.symmetric(horizontal: 4.w, vertical: .5.h),
        elevation: 6,
        shadowColor: Colors.black45,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Padding(
          padding: EdgeInsets.all(3.w),
          child: Row(
            children: [
              Icon(icon, size: 6.w, color: Colors.redAccent),
              SizedBox(width: 3.w),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                        color: Colors.black54,
                      ),
                    ),
                    SizedBox(height: 0.5.h),
                    Text(
                      value,
                      style: TextStyle(
                        fontSize: 15.sp,
                        fontWeight: FontWeight.w400,
                        color: Colors.black87,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  _showExitDialog(CampsModel camp, BuildContext parentContext) async {
    return showDialog(
      context: parentContext,
      builder: (context) => AlertDialog(
        title: const Text('Register for Camp'),
        content: const Text('Are you sure you want to register?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Colors.redAccent),
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
                  const SnackBar(
                    content: Text(
                      'Please login first.',
                      style: TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Colors.redAccent,
                  ),
                );
                return;
              }

              final message = await campsProvider.registerInCamp(
                username,
                camp.id!,
              );

              ScaffoldMessenger.of(parentContext).showSnackBar(
                SnackBar(
                  content: Text(message ?? 'Registration successful!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text(
              'Confirm',
              style: TextStyle(color: Colors.blueAccent),
            ),
          ),
        ],
      ),
    );
  }
}
