import 'package:Life_Connect/hospital%20side/Providers/authProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/profileProvider.dart';
import 'package:Life_Connect/hospital%20side/widgets/customButton.dart';
import 'package:Life_Connect/tabIndexNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class HospitalProfilePage extends StatelessWidget {
  const HospitalProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<HospitalProfileProvider>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: Stack(
          children: [
            // Top Profile Section with Gradient
            Container(
              height: 60.h,
              width: 100.w,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.red.shade700,
                    Colors.redAccent,
                    Colors.white,
                  ],
                  stops: [0.0, 0.6, 1.0],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
            ),
            SafeArea(
              child: Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: IconButton(
                      onPressed: () {
                        if (profileProvider.id != null) {
                          Navigator.pushNamed(context, '/hospitalEditProfileDetails');
                        }
                      },
                      icon: Icon(
                        Icons.edit_outlined,
                        size: 23.sp,
                        color: Colors.white,
                      )),
                ),
              ),
            ),
            Center(
              child: SizedBox(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 15.h,
                    ),
                    profilePicture(profileProvider, context),
                    SizedBox(height: 2.h),
                    Text(
                      profileProvider.name ?? 'Update Profile',
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    GestureDetector(
                      onLongPress: () {
                        HapticFeedback.vibrate();

                        Clipboard.setData(
                            ClipboardData(text: profileProvider.email ?? ''));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Text Copied to clipboard!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        profileProvider.email ?? '',
                        style: GoogleFonts.roboto(
                          color: Colors.white70,
                          fontSize: 15.sp,
                          fontWeight: FontWeight.w500,
                        ),
                        softWrap: true,
                        overflow: TextOverflow.visible,
                      ),
                    ),
                    SizedBox(
                      height: 5.h,
                    ),
                    Container(
                      height: 35.h,
                      width: 85.w,
                      padding: EdgeInsets.all(6.w),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.red, width: 2),
                        boxShadow: const [
                          BoxShadow(
                            blurRadius: 8,
                            color: Color.fromARGB(90, 0, 0, 0),
                            offset: Offset(2, 1),
                          ),
                        ],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            // Aligned Details Section
                            SizedBox(
                              height: 1.5.h,
                            ),

                            _buildLabelText('Conatct Number :'),
                            _buildValueText(
                                profileProvider.phone ?? 'no id', context),
                            SizedBox(
                              height: 1.h,
                            ),
                            _buildLabelText('Hospital Location :'),
                            _buildValueText(
                                profileProvider.address ?? 'update address',
                                context),
                            // Table(
                            //   columnWidths: const {
                            //     0: IntrinsicColumnWidth(), // Automatically sizes the label column
                            //     1: FlexColumnWidth(), // Allows the value column to take up remaining space
                            //   },
                            //   defaultVerticalAlignment:
                            //       TableCellVerticalAlignment.top,
                            //   children: [
                            //     TableRow(
                            //       children: [
                            //         _buildLabelText('    phone :  '),
                            //         _buildValueText(
                            //             profileProvider.phone ?? 'no id',
                            //             context),
                            //       ],
                            //     ),
                            //     TableRow(
                            //       children: [
                            //         _buildLabelText('Address :  '),
                            //         _buildValueText(
                            //             profileProvider.address ??
                            //                 'update address',
                            //             context),
                            //       ],
                            //     ),
                            //   ],
                            // ),

                            SizedBox(height: 4.h),
                            Center(
                              child: CustomButton(
                                height: 4.2,
                                width: 50,
                                text: 'Log Out',
                                buttonType: ButtonType.Outlined,
                                onPressed: () => logout(context),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabelText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: .5.h),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 15.5.sp,
          fontWeight: FontWeight.w500,
          color: Colors.red,
        ),
      ),
    );
  }

  _buildValueText(String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: .5.h),
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.vibrate();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Center(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Text(
                    'Copied',
                    style: TextStyle(color: Colors.white, fontSize: 14),
                  ),
                ),
              ),
              behavior: SnackBarBehavior.floating,
              backgroundColor:
                  Colors.transparent, // Make the background invisible
              elevation: 0, // Remove shadow
              duration: const Duration(seconds: 1),
            ),
          );
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w500,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  Widget profilePicture(
      HospitalProfileProvider profileProvider, BuildContext context) {
    return SizedBox(
      width: 12.5.h,
      height: 12.h,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 12.5.h,
            backgroundColor: Colors.white,
            backgroundImage:
                profileProvider.image == null || profileProvider.image == ''
                    ? const AssetImage('assets/hospital.png')
                    : NetworkImage(
                        profileProvider.image!,
                      ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                await profileProvider.pickProfileImage();
                if (profileProvider.pickedImage != null) {
                  final message = await profileProvider
                      .updateProfilePicture(profileProvider.pickedImage);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                    duration: const Duration(seconds: 2),
                  ));
                }
              },
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
    );
  }

  void logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('hospitalName');
    prefs.remove('user_type');

    await Provider.of<HospitalAuthProvider>(context, listen: false).reset();
    Provider.of<TabIndexNotifier>(context, listen: false).setIndex(0);

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcomePage',
      (route) => false,
    );
  }
}
