import 'package:Life_Connect/hospital%20side/Providers/profileProvider.dart';
import 'package:Life_Connect/hospital%20side/widgets/customButton.dart';
import 'package:Life_Connect/hospital%20side/widgets/customTextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HospitalEditProfileDetails extends StatelessWidget {
  const HospitalEditProfileDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final profileProvider = Provider.of<HospitalProfileProvider>(context);

    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: Colors.black,
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage(
              'assets/bg_threenurse.jpg',
            ),
            fit: BoxFit.cover,
            opacity: 0.3,
          ),
        ),
        child: Stack(
          children: [
            Positioned(
              top: 4.h,
              child: IconButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                icon: Icon(
                  Icons.arrow_back,
                  color: const Color.fromARGB(255, 209, 209, 209),
                  size: 24.sp,
                ),
              ),
            ),
            SizedBox(
              height: 100.h,
              width: 100.w,
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Edit Profile',
                        style: TextStyle(
                          fontSize: 23.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    CustomTextfield(
                      enabled: false,
                      hintText: profileProvider.name ?? 'name',
                      keyboardType: TextInputType.name,
                      icon: Icons.person_2_outlined,
                      onChanged: (value) {},
                    ),
                    SizedBox(
                      height: 1.3.h,
                    ),
                    CustomTextfield(
                      hintText: profileProvider.address ?? 'Address',
                      keyboardType: TextInputType.streetAddress,
                      icon: Icons.place_outlined,
                      onChanged: (value) {
                        profileProvider.editedAddress = value.trim();
                      },
                    ),
                    SizedBox(
                      height: 1.3.h,
                    ),
                    CustomTextfield(
                      hintText: profileProvider.phone ?? 'Phone',
                      maxlenth: 10,
                      keyboardType: TextInputType.number,
                      icon: Icons.phone_in_talk_outlined,
                      onChanged: (value) {
                        profileProvider.editedPhone = value.trim();
                      },
                    ),

                    SizedBox(
                      height: 3.h,
                    ),
                    // Submit Button
                    CustomButton(
                      text: 'Submit',
                      isLoading: profileProvider.isLoading,
                      textColor: const Color.fromARGB(255, 230, 3, 3),
                      onPressed: () {
                        if (profileProvider.id == null ||
                            profileProvider.id == 0) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Profile Not Found')),
                          );
                        } else if ((profileProvider.editedPhone != null &&
                                profileProvider.editedPhone!.isNotEmpty) &&
                            profileProvider.editedPhone!.length < 10) {
                          ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                  content: Text('Number must be 10 digits')));
                        } else {
                          // Proceed with Register User Profile
                          profileProvider.updateProfileDetails(
                              context,
                              profileProvider.editedAddress,
                              profileProvider.editedPhone);
                        }
                      },
                      buttonType: ButtonType.Outlined,
                    ),

                    SizedBox(
                      height: 2.h,
                    ),
                  ]),
            ),
          ],
        ),
      ),
    );
  }
}
