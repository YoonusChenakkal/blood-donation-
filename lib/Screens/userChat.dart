import 'package:blood_donation/Models/hospitalModel.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UserChat extends StatelessWidget {
  const UserChat({super.key});

  @override
  Widget build(BuildContext context) {
    final HospitalModel camp =
        ModalRoute.of(context)!.settings.arguments as HospitalModel;

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset:
          true, // Ensures content resizes with the keyboard
      body: SafeArea(
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Column(
            children: [
              Container(
                margin: const EdgeInsets.all(15),
                width: 98.w,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: Colors.black,
                ),
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: Colors.white,
                        ),
                      ),
                      const CircleAvatar(
                        backgroundImage: NetworkImage(
                          'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg',
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    camp.name,
                    style: TextStyle(
                      fontSize: 15.5.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  titleAlignment: ListTileTitleAlignment.center,
                  subtitle: Text(
                    '3 weeks ago',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  trailing: IconButton(
                    onPressed: () {},
                    icon: Icon(
                      Icons.info_outline,
                      size: 21.5.sp,
                      color: Colors.amber,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg',
                          ),
                        ),
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: 75.w, minWidth: 13.w),
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Text(
                            'Hello! Your donation date is scheduled.',
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        Container(
                          constraints:
                              BoxConstraints(maxWidth: 75.w, minWidth: 13.w),
                          margin: const EdgeInsets.all(4),
                          padding: const EdgeInsets.all(9),
                          decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(22),
                          ),
                          child: const Text('When?'),
                        ),
                        const CircleAvatar(
                          backgroundImage: NetworkImage(
                            'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg',
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                margin: const EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 2.2.w),
                width: 92.w,
                height: 6.2.h,
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(25),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: TextField(
                        decoration: InputDecoration(
                          contentPadding:
                              EdgeInsets.only(left: 4.5.w, right: 1.w),
                          hintText: 'Message',
                          hintStyle: TextStyle(
                            fontSize: 16.sp,
                            color: const Color.fromARGB(255, 224, 224, 224),
                          ),
                          border: InputBorder.none, // To remove border
                        ),
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.send_rounded,
                        size: 23.sp,
                        color: Colors.amber,
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
