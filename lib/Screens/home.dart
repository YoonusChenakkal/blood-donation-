import 'package:blood_donation/Providers/campsProvider.dart';
import 'package:blood_donation/Providers/donorCountProvider.dart';
import 'package:blood_donation/Providers/hospitalProvider.dart';
import 'package:blood_donation/Providers/userProfileProvider.dart';
import 'package:blood_donation/widgets/customBanner.dart';
import 'package:blood_donation/widgets/customCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final donorCountProvider = Provider.of<DonorCountProvider>(context);
    final hospitaProvider = Provider.of<HospitalProvider>(context);
    final campProvider = Provider.of<Campsprovider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: FutureBuilder<String>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(
                'Guest',
                style: TextStyle(fontSize: 19.sp, color: Colors.red),
              );
            }
            final username = snapshot.data ?? 'Guest';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $username',
                  style: GoogleFonts.archivo(
                    fontSize: 19.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'welcome',
                  style: GoogleFonts.archivo(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 9.h,
        actions: [
          Container(
            width: 7.h,
            padding: const EdgeInsets.all(1),
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.red, width: 1.5),
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: userProfileProvider.profileData['profileImage'] == null ||
                      userProfileProvider.profileData['profileImage'] == ''
                  ? Image.asset('assets/man.png')
                  : Image.network(
                      userProfileProvider.profileData['profileImage'],
                    ),
            ),
          ),
        ],
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              CustomBanner(
                title1: 'Donate If You Can\nSave One Life',
                title2: 'Make them happy',
                textColor: Colors.white,
                buttonText: 'View',
                onPressed: () {},
                imageUrl:
                    'https://c0.wallpaperflare.com/preview/478/173/152/healthcare-hospital-lamp-light.jpg',
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                child: Row(
                  children: [
                    CustomCard(
                      title: 'Total\nDonors',
                      count: donorCountProvider.donorCount,
                      image: Image.asset(
                        'assets/donors.png',
                        height: 3.h,
                      ),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    CustomCard(
                      title: 'Total\nHospitals',
                      count: hospitaProvider.hospitals.length.toString(),
                      image: Image.asset(
                        'assets/hospital-1.png',
                        height: 4.h,
                      ),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    CustomCard(
                      title: 'Total\nCamps',
                      count: campProvider.camp.length.toString(),
                      image: Image.asset(
                        'assets/camp.png',
                        height: 4.h,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 2.h,
                  left: 3.5.w,
                  bottom: 1.h,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Message',
                    style: TextStyle(
                      fontSize: 13.4.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomBanner(
                title1: 'Marry Hospital',
                title2:
                    'Your Donation Date has Scheduled We will inform you soon',
                buttonText: 'View',
                textColor: Colors.black,
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 1.5.h,
                  left: 3.5.w,
                  bottom: 1.h,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Certificate',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomBanner(
                title1: 'Scheduled Donations',
                title2: 'Your Donation Has Sheduled\nWe wil inform you soon',
                buttonText: 'View',
                textColor: Colors.black,
                onPressed: () {},
              ),
            ],
          ),
        ),
      ),
    );
  }
}
