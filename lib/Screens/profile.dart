import 'package:blood_donation/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              width: 25.w,
              height: 25.w,
              child: Stack(
                children: [
                  CircleAvatar(
                    backgroundColor: const Color.fromARGB(255, 234, 234, 234),
                    radius: 15.w,
                    child: Icon(
                      Icons.person_2_outlined,
                      color: Colors.grey,
                      size: 30.sp,
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: InkWell(
                      onTap: () {},
                      child: CircleAvatar(
                        radius: 3.6.w,
                        backgroundColor: const Color(0xFF5686E1),
                        child: Icon(
                          Icons.add,
                          size: 20.sp,
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(
              height: 2.h,
            ),
            Text(
              'Yoonus',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20.sp,
                fontWeight: FontWeight.w700,
                height: .25.h,
              ),
            ),
            Text(
              'yoonus123@gmail.com',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w500,
                height: .2.h,
              ),
            ),
            Text(
              'Coconut Basket company',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w400,
                  height: .2.h),
            ),
            Text(
              'company address',
              style: TextStyle(
                color: Colors.black,
                fontSize: 16.sp,
                fontWeight: FontWeight.w400,
                height: .2.h,
              ),
            ),
            SizedBox(
              height: 3.2.h,
            ),
            CustomButton(
                height: 4.2,
                width: 32,
                text: 'Log Out',
                buttonType: ButtonType.Outlined,
                onPressed: () {})
          ],
        ),
      ),
    );
  }
}
