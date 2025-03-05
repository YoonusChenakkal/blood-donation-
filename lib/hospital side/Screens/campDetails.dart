
import 'package:Life_Connect/hospital%20side/Models/campsModel.dart';
import 'package:Life_Connect/hospital%20side/Providers/campaignProvider.dart';
import 'package:Life_Connect/hospital%20side/Sections/registeredUserListSection.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sizer/sizer.dart';
import 'package:url_launcher/url_launcher.dart';

class HospitalCampDetails extends StatelessWidget {
  const HospitalCampDetails({super.key});

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
    final CampsModel filteredCamp =
        ModalRoute.of(context)!.settings.arguments as CampsModel;

    final campProvider = Provider.of<HospitalCampaignProvider>(context);

    openMap(String location) async {
      final Uri url = Uri.parse(
          'https://www.google.com/maps/search/?api=1&query=${filteredCamp.location}');
      if (filteredCamp.location != null) {
        await launchUrl(url);
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Unable to Open Map')));
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
        actions: [
          IconButton(
            onPressed: () => {
              Navigator.pushNamed(context, '/editCampDetails',
                  arguments: filteredCamp),
            },
            icon: const Icon(Icons.edit),
            color: Colors.white,
          ),
          IconButton(
            onPressed: () {
              campProvider.deleteCamp(filteredCamp.id, context);
            },
            icon: const Icon(Icons.delete),
            color: Colors.white,
          )
        ],
        centerTitle: true,
      ),
      body: Column(
        children: [
          // Hero Header
          Hero(
            tag: filteredCamp.id ?? 'unknown_id',
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
                    offset: const Offset(2, 4),
                  ),
                ],
              ),
              child: Text(
                filteredCamp.hospital ?? 'No Name',
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
            value: formatDate(filteredCamp.date),
          ),
          _buildDetailsCard(
            icon: Icons.access_time,
            title: 'Time',
            value:
                '${formatTime(filteredCamp.startTime)} - ${formatTime(filteredCamp.endTime)}',
          ),
          _buildDetailsCard(
            icon: Icons.location_pin,
            title: 'Location',
            value: filteredCamp.location ?? 'Unknown Location',
            isInteractive: true,
            onTap: () => openMap(filteredCamp.location ?? ''),
          ),
          _buildDetailsCard(
              icon: Icons.notes_rounded,
              title: 'Description',
              value: filteredCamp.description ?? ''),

          // Registratered User List Section

          Row(
            children: [
              Padding(
                  padding: EdgeInsets.only(top: 1.h, left: 3.5.w, bottom: .5.h),
                  child: const Text('Registered Users')),
            ],
          ),
          userRegisteredListSection(
            filteredCamp: filteredCamp,
          ),
        ],
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
}
