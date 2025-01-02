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
          toolbarHeight: 8.h,
          actions: [
            Container(
              width: 5.3.h,
              height: 5.3.h,
              padding: const EdgeInsets.all(1.8),
              margin: EdgeInsets.symmetric(horizontal: 4.w),
              decoration: const BoxDecoration(
                color: Colors.red,
                shape: BoxShape.circle,
              ),
              child: ClipOval(
                child: Image.network(
                  'https://c4.wallpaperflare.com/wallpaper/499/693/150/candice-swanepoel-women-blonde-face-wallpaper-preview.jpg',

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
                  onPressed: () => Navigator.pushNamed(context, '/profile'),
                  imageUrl:
                      'https://c0.wallpaperflare.com/preview/478/173/152/healthcare-hospital-lamp-light.jpg'),
              SizedBox(
                height: 2.h,
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
                padding: EdgeInsets.only(
                  top: .6.h,
                  left: 2.8.w,
                  bottom: .8.h,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Message',
                    style: TextStyle(
                        fontSize: 13.4.sp, fontWeight: FontWeight.bold),
                  ),
                ),
              ),
              CustomBanner(
                title1: 'Marry Hospital',
                title2:
                    'Your Donation Date has Sheduled We will inform you soon',
                buttonText: 'Download',
                textColor: Colors.black,
                onPressed: () {},
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: .6.h,
                  left: 2.8.w,
                  bottom: 1.4.h,
                ),
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
                  title1: 'Sheduled Donations',
                  title2: '',
                  buttonText: 'View',
                  textColor: Colors.black,
                  onPressed: () {}),
              Padding(
                padding: const EdgeInsets.only(
                  top: 13.0,
                  left: 13,
                  bottom: 7,
                ),
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
