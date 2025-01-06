import 'package:blood_donation/Providers/authProvider.dart';
import 'package:blood_donation/Providers/campsProvider.dart';
import 'package:blood_donation/Providers/certificateProvider.dart';
import 'package:blood_donation/Providers/tabIndexNotifier.dart';
import 'package:blood_donation/Providers/userProfileProvider.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:blood_donation/widgets/customCheckbox.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);

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
                      onPressed: () {},
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
                  children: [
                    SizedBox(height: 14.h),
                    profilePicture(),
                    SizedBox(height: 2.h),
                    Text(
                      userProfileProvider.profileData['name'],
                      style: GoogleFonts.rubik(
                        color: Colors.white,
                        fontSize: 22.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 1.h),
                    GestureDetector(
                      onLongPress: () {
                        HapticFeedback.vibrate();

                        Clipboard.setData(ClipboardData(
                            text:
                                userProfileProvider.profileData['name'] ?? ''));
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Text Copied to clipboard!'),
                            duration: Duration(seconds: 1),
                          ),
                        );
                      },
                      child: Text(
                        userProfileProvider.profileData['email'],
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
                      height: 4.h,
                    ),
                    Container(
                      height: 48.h,
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
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Aligned Details Section
                            Table(
                              columnWidths: const {
                                0: IntrinsicColumnWidth(), // Automatically sizes the label column
                                1: FlexColumnWidth(), // Allows the value column to take up remaining space
                              },
                              defaultVerticalAlignment:
                                  TableCellVerticalAlignment.top,
                              children: [
                                TableRow(
                                  children: [
                                    _buildLabelText('  User Id :   '),
                                    _buildValueText(userProfileProvider
                                        .profileData['unique_id']),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildLabelText('   Blood  :   '),
                                    Row(
                                      children: [
                                        Container(
                                          margin: const EdgeInsets.all(2),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(6),
                                            color: Colors.red,
                                          ),
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 8.0),
                                            child: Text(
                                              userProfileProvider
                                                  .profileData['bloodGroup'],
                                              style: GoogleFonts.roboto(
                                                  fontSize: 19.sp,
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.w900),
                                            ),
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildLabelText('   Phone :   '),
                                    _buildClickableLabelText(
                                        userProfileProvider
                                            .profileData['phone'],
                                        context)
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildLabelText('Address :   '),
                                    _buildValueText(
                                      userProfileProvider
                                          .profileData['address'],
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 1.3.h),
                            CustomCheckbox(
                              isChecked: userProfileProvider
                                  .profileData['donateBlood'],
                              onChanged: (value) {},
                              title: ' Willing Donate to Blood ',
                            ),
                            CustomCheckbox(
                              isChecked: userProfileProvider
                                  .profileData['donateOrgan'],
                              onChanged: (value) {},
                              title: 'Willing Donate to organs ',
                            ),

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
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Text(
        text,
        style: GoogleFonts.roboto(
          fontSize: 15.5.sp,
          fontWeight: FontWeight.w500,
          color: const Color.fromARGB(221, 78, 78, 78),
        ),
      ),
    );
  }

  Widget _buildValueText(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.2.h),
      child: Text(
        text,
        style: TextStyle(
          fontSize: 16.sp,
          color: const Color.fromARGB(255, 0, 0, 0),
          fontWeight: FontWeight.w500,
        ),
        softWrap: true,
        overflow: TextOverflow.visible,
      ),
    );
  }

  _buildClickableLabelText(String text, BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: GestureDetector(
        onLongPress: () {
          HapticFeedback.vibrate();
          Clipboard.setData(ClipboardData(text: text));
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Copied $text to clipboard!'),
              duration: Duration(seconds: 1),
            ),
          );
        },
        child: Text(
          text,
          style: TextStyle(
            fontSize: 16.sp,
            color: Colors.blueAccent,
            fontWeight: FontWeight.w500,
          ),
          softWrap: true,
          overflow: TextOverflow.visible,
        ),
      ),
    );
  }

  Widget profilePicture() {
    return SizedBox(
      width: 25.w,
      height: 25.w,
      child: Stack(
        children: [
          CircleAvatar(
            backgroundColor: const Color.fromARGB(255, 234, 234, 234),
            radius: 15.w,
            child: Icon(
              Icons.camera_alt_outlined,
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
    );
  }

  void logout(BuildContext context) async {
    Provider.of<AuthProvider>(context, listen: false).reset();
    await Provider.of<UserProfileProvider>(context, listen: false).reset();
    Provider.of<Campsprovider>(context, listen: false).camp.clear();
    await Provider.of<CertificateProvider>(context, listen: false).reset();
    await Provider.of<TabIndexNotifier>(context, listen: false).reset();

    final prefs = await SharedPreferences.getInstance();
    prefs.remove('username');

    Navigator.pushNamedAndRemoveUntil(
      context,
      '/welcomePage',
      (route) => false,
    );
  }
}
