import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class UserChat extends StatelessWidget {
  const UserChat({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          'Chats',
          style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
        ),
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              top: 0,
              child: Container(
                width: 92.w,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.black),
                child: ListTile(
                    leading: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          onPressed: () => Navigator.pop(context),
                          icon: Icon(
                            Icons.arrow_back_ios,
                            color: Colors.white,
                          ),
                        ),
                        CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg'),
                        ),
                      ],
                    ),
                    title: Text(
                      'Marry Hospital',
                      style: TextStyle(
                          fontSize: 15.5.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w600),
                    ),
                    titleAlignment: ListTileTitleAlignment.center,
                    subtitle: Text(
                      '3 weeks ago',
                      style: TextStyle(
                          fontSize: 14.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.w400),
                    ),
                    trailing: IconButton(
                      onPressed: () {},
                      icon: Icon(
                        Icons.info_outline,
                        size: 21.5.sp,
                        color: Colors.amber,
                      ),
                    )),
              ),
            ),
            Positioned(
              bottom: 0,
              child: Container(
                margin: EdgeInsets.all(10),
                padding: EdgeInsets.symmetric(horizontal: 2.2.w),
                width: 92.w,
                height: 6.2.h,
                decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(25)),
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
                              color: const Color.fromARGB(255, 224, 224, 224)),
                          border: InputBorder.none, // To remove border
                        ),
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    IconButton(
                        onPressed: () {},
                        icon: Icon(
                          Icons.send_rounded,
                          size: 23.sp,
                          color: Colors.amber,
                        ))
                  ],
                ),
              ),
            ),
            SizedBox(
              width: 96.w,
              height: 72.h,
              child: ListView(
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      const CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg')),
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: 75.w, minWidth: 13.w),
                        margin: const EdgeInsets.all(4),
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(22)),
                        child: const Text('hello Your donation date is sheduled'),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        constraints:
                            BoxConstraints(maxWidth: 75.w, minWidth: 13.w),
                        margin: EdgeInsets.all(4),
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                            color: Colors.red[50],
                            borderRadius: BorderRadius.circular(22)),
                        child: Text('when?'),
                      ),
                      CircleAvatar(
                          backgroundImage: NetworkImage(
                              'https://c1.wallpaperflare.com/preview/811/653/259/hospital-emergency-entrance-architecture-building-doctor.jpg')),
                    ],
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
