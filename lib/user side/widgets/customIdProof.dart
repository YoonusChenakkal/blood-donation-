import 'package:Life_Connect/user side/Providers/userProfileProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomIdProof extends StatelessWidget {
  const CustomIdProof({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    return Container(
        height: 6.h,
        width: 85.w,
        decoration: ShapeDecoration(
          color: const Color.fromARGB(255, 231, 231, 231),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
        ),
        child: userProfileProvider.idProofImage == null
            ? Row(
                children: [
                  Padding(
                    padding: EdgeInsets.only(left: 2.w, right: 4.w),
                    child: Icon(
                      Icons.upload_file_outlined,
                      color: const Color.fromARGB(255, 102, 102, 102),
                      size: 20.sp,
                    ),
                  ),
                  Text(
                    'Upload Id Proof',
                    style: TextStyle(
                        fontSize: 16.sp,
                        color: const Color.fromARGB(255, 102, 102, 102)),
                  ),
                  TextButton(
                    onPressed: () {
                      userProfileProvider.pickIdProofImage();
                    },
                    style: const ButtonStyle(
                      padding: WidgetStatePropertyAll(EdgeInsets.zero),
                    ),
                    child: Text('Browse',
                        style: TextStyle(
                            fontSize: 16.sp, color: Color(0xFF5686E1))),
                  ),
                ],
              )
            : Row(children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 2.w),
                  child: Icon(
                    Icons.upload_file_outlined,
                    color: const Color.fromARGB(255, 102, 102, 102),
                    size: 20.sp,
                  ),
                ),
                Text(
                  userProfileProvider.imageName as String,
                  style: TextStyle(
                      fontSize: 16.sp,
                      color: const Color.fromARGB(255, 102, 102, 102)),
                ),
                IconButton(
                  onPressed: () {
                    userProfileProvider.idProofImage = null;
                  },
                  style: const ButtonStyle(
                    padding: WidgetStatePropertyAll(EdgeInsets.zero),
                  ),
                  icon: Icon(Icons.close),
                ),
              ]));
  }
}
