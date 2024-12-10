import 'package:blood_donation/widgets/customBanner.dart';
import 'package:blood_donation/widgets/customCard.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          title: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Hello,Yoonus',
                style: TextStyle(
                    fontSize: 19.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              Text(
                'welcome',
                style: TextStyle(
                    fontSize: 15.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500),
              )
            ],
          ),
          backgroundColor: Colors.white,
          toolbarHeight: 10.h,
          actions: [
            Container(
              height: 7.h,
              width: 7.h,
              padding: const EdgeInsets.all(2),
              margin: EdgeInsets.symmetric(horizontal: 2.w),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  'https://c4.wallpaperflare.com/wallpaper/499/693/150/candice-swanepoel-women-blonde-face-wallpaper-preview.jpg',
                  width: 6.h,
                  height: 6.h,
                  fit: BoxFit
                      .cover, // Ensure the image fills the avatar appropriately
                ),
              ),
            ),
          ],
        ),
        body: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              CustomBanner(),
              SizedBox(
                height: 2.5.h,
              ),
              const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  CustomCard(),
                  CustomCard(),
                  CustomCard(),
                ],
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Message',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CustomBanner(),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Message',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CustomBanner(),
            ],
          ),
        ));
  }
}
