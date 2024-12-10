import 'package:blood_donation/widgets/customBanner.dart';
import 'package:blood_donation/widgets/customButton.dart';
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
              margin: EdgeInsets.symmetric(horizontal: 4.w),
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
              CustomBanner(
                  title1: 'Donate If You Can\nSave One Life',
                  title2: 'Make them happy',
                  textColor: Colors.white,
                  buttonText: 'View More',
                  imageUrl:
                      'https://c0.wallpaperflare.com/preview/478/173/152/healthcare-hospital-lamp-light.jpg'),
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
              CustomBanner(
                title1: 'Marry Hospital',
                title2:
                    'Your Donation Date has Sheduled We will inform you soon',
                buttonText: 'Download',
                textColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Certificate',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CustomBanner(
                title1: 'Your Certificate is raedy!',
                title2:
                    'Your Preious donation Certificate is ready to Download Get it now and do somethis  and someithonf',
                buttonText: 'Download',
                textColor: Colors.black,
              ),
              Padding(
                padding: const EdgeInsets.all(13.0),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Update Your Shedule',
                    style:
                        TextStyle(fontSize: 15.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              Container(
                width: 90.w,
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
                          'You can update the donation month , date and year',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 14.5.sp, fontWeight: FontWeight.w500),
                        )),
                    CustomButton(
                        height: 3,
                        width: 20,
                        text: 'Update',
                        buttonType: ButtonType.Ovelshaped,
                        onPressed: () {
                          Navigator.pushNamed(context, '/chats');
                        })
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
