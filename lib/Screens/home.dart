import 'package:blood_donation/widgets/customBanner.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:blood_donation/widgets/customCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
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
                    fontSize: 18.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'welcome',
                  style: GoogleFonts.archivo(
                    fontSize: 16.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 8.h,
        actions: [
          Container(
            width: 5.3.h,
            height: 5.3.h,
            padding: const EdgeInsets.all(1.8),
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: const BoxDecoration(
              color: Colors.red,
              shape: BoxShape.circle,
            ),
            child: ClipOval(
              child: Image.network(
                'https://c4.wallpaperflare.com/wallpaper/499/693/150/candice-swanepoel-women-blonde-face-wallpaper-preview.jpg',
                fit: BoxFit.cover,
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
              CustomBanner(
                title1: 'Donate If You Can\nSave One Life',
                title2: 'Make them happy',
                textColor: Colors.white,
                buttonText: 'View More',
                onPressed: () {},
                imageUrl:
                    'https://c0.wallpaperflare.com/preview/478/173/152/healthcare-hospital-lamp-light.jpg',
              ),
              SizedBox(height: 1.5.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: const [CustomCard(), CustomCard(), CustomCard()],
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
                buttonText: 'Download',
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
                title2: '',
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
                    'Update Your Schedule',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              Container(
                width: 93.w,
                height: 7.h,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 243, 243, 243),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    SizedBox(
                      width: 60.w,
                      child: Text(
                        'You can update the donation month, date, and year',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 14.5.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    CustomButton(
                      height: 3,
                      width: 20,
                      text: 'Update',
                      buttonType: ButtonType.Ovelshaped,
                      onPressed: () {
                        Navigator.pushNamed(context, '/chats');
                      },
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
