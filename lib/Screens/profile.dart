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
                      onPressed: () => Navigator.pushNamed(
                          context,
                          userProfileProvider.profileData['id'] == null ||
                                  userProfileProvider.profileData['email'] ==
                                      null
                              ? '/userProfile'
                              : '/userProfileEdit'),
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
                    SizedBox(
                      height: 12.h,
                    ),
                    profilePicture(userProfileProvider, context),
                    SizedBox(height: 2.h),
                    Text(
                      userProfileProvider.profileData['name'] ??
                          userProfileProvider.name ??
                          'Update Profile',
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
                        userProfileProvider.profileData['email'] ?? '',
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
                      height: 52.h,
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
                            SizedBox(
                              height: 1.5.h,
                            ),
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
                                            .profileData['unique_id'] ??
                                        'no id'),
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildLabelText('   Blood  :   '),
                                    Row(
                                      children: [
                                        userProfileProvider.profileData.isEmpty
                                            ? _buildValueText('not found')
                                            : Container(
                                                margin: const EdgeInsets.all(2),
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                  color: Colors.red,
                                                ),
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(
                                                      horizontal: 8.0),
                                                  child: Text(
                                                    userProfileProvider
                                                            .profileData[
                                                        'bloodGroup'],
                                                    style: GoogleFonts.roboto(
                                                        fontSize: 19.sp,
                                                        color: Colors.white,
                                                        fontWeight:
                                                            FontWeight.w900),
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
                                                .profileData['phone'] ??
                                            'update no',
                                        context)
                                  ],
                                ),
                                TableRow(
                                  children: [
                                    _buildLabelText('Address :   '),
                                    _buildValueText(
                                      userProfileProvider
                                              .profileData['address'] ??
                                          'update address',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            SizedBox(height: 1.3.h),
                            const Text(
                              'Organs to Donate:',
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            const SizedBox(height: 8),
                            userProfileProvider.profileData['donateOrgan'] !=
                                        null &&
                                    userProfileProvider
                                        .profileData['donateOrgan'] is List &&
                                    userProfileProvider
                                        .profileData['donateOrgan'].isNotEmpty
                                ? Row(
                                    children: userProfileProvider
                                        .profileData['donateOrgan']
                                        .map<Widget>((organ) => Container(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 6,
                                                      vertical: 4),
                                              margin: const EdgeInsets.only(
                                                  right: 7),
                                              decoration: BoxDecoration(
                                                color: Colors.transparent,
                                                border: Border.all(
                                                    color: Colors.red),
                                                borderRadius:
                                                    BorderRadius.circular(16),
                                              ),
                                              child: Text(
                                                organ,
                                                style: const TextStyle(
                                                    fontSize: 13,
                                                    color: Colors.red),
                                              ),
                                            ))
                                        .toList(),
                                  )
                                : Text(
                                    'No Organs Selected',
                                    style: TextStyle(
                                      color:
                                          const Color.fromARGB(221, 78, 78, 78),
                                    ),
                                  ),
                            SizedBox(
                              height: 1.3.h,
                            ),
                            CustomCheckbox(
                              textColor: const Color.fromARGB(255, 0, 0, 0),
                              isChecked: userProfileProvider
                                      .profileData['willingDonateBlood'] ??
                                  false,
                              onChanged: (value) {},
                              title: ' Willing Donate to Blood ',
                            ),
                            // CustomCheckbox(
                            //   isChecked: userProfileProvider
                            //           .profileData['willingDonateOrgan'] ??
                            //       false,
                            //   onChanged: (value) {},
                            //   title: 'Willing Donate to organs ',
                            // ),

                            SizedBox(height: 3.h),
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

  Widget profilePicture(
      UserProfileProvider userProfileProvider, BuildContext context) {
    return SizedBox(
      width: 12.5.h,
      height: 12.h,
      child: Stack(
        children: [
          CircleAvatar(
            radius: 12.5.h,
            backgroundColor: Colors.white,
            backgroundImage:
                userProfileProvider.profileData['profileImage'] == null ||
                        userProfileProvider.profileData['profileImage'] == ''
                    ? const AssetImage('assets/man.png')
                    : NetworkImage(
                        userProfileProvider.profileData['profileImage'],
                      ),
          ),
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () async {
                await userProfileProvider.pickProfileImage();
                if (userProfileProvider.profileImage != null) {
                  final message =
                      await userProfileProvider.updateProfilePicture(
                          userProfileProvider.profileData['id'],
                          userProfileProvider.profileImage);
                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(message),
                    duration: Duration(seconds: 2),
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
