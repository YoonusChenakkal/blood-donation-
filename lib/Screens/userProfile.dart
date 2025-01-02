import 'package:blood_donation/Providers/authProvider.dart';
import 'package:blood_donation/Providers/userProfileProvider.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:blood_donation/widgets/customCheckbox.dart';
import 'package:blood_donation/widgets/customDropdown.dart';
import 'package:blood_donation/widgets/customIdProof.dart';
import 'package:blood_donation/widgets/customTextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class UserProfile extends StatelessWidget {
  const UserProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    return PopScope(
      onPopInvoked: (did) async {
        // Prevent back navigation
        await _showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                'https://c1.wallpaperflare.com/preview/910/704/36/guardian-angel-doctor-health-angel.jpg',
              ),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: SizedBox(
            height: 100.h,
            width: 100.w,
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                alignment: Alignment.centerLeft,
                child: Text(
                  'User Profile',
                  style: TextStyle(
                    fontSize: 23.sp,
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              CustomTextfield(
                enabled: false,
                hintText: authProvider.name ?? 'No Name',
                keyboardType: TextInputType.name,
                icon: Icons.person_2_outlined,
                onChanged: (value) {
                  userProfileProvider.name = value.trim();
                },
              ),
              SizedBox(
                height: 1.3.h,
              ),
              CustomTextfield(
                hintText: 'Address',
                keyboardType: TextInputType.streetAddress,
                icon: Icons.place_outlined,
                onChanged: (value) {
                  userProfileProvider.address = value.trim();
                },
              ),
              SizedBox(
                height: 1.3.h,
              ),
              CustomTextfield(
                hintText: 'Phone',
                keyboardType: TextInputType.number,
                icon: Icons.phone_in_talk_outlined,
                onChanged: (value) {
                  userProfileProvider.phone = value.trim();
                },
              ),
              SizedBox(
                height: 1.3.h,
              ),
              Customdropdown(
                enabled: false,
                hintText: authProvider.bloodGroup ?? 'Blood Group',
              ),
              SizedBox(
                height: 1.3.h,
              ),
              CustomIdProof(),
              CustomCheckbox(
                  title: 'Willing Donate Organ',
                  isChecked: userProfileProvider.isChecked,
                  onChanged: (value) {
                    userProfileProvider.isChecked = value!;
                  }),
              SizedBox(
                height: 1.3.h,
              ),
              SizedBox(
                height: 3.h,
              ),
              // Submit Button
              CustomButton(
                text: 'Submit',
                isLoading:userProfileProvider.isLoading ,
                onPressed: () {
                  if (userProfileProvider.address == null ||
                      userProfileProvider.address!.isEmpty) {
                    // Show error message if any field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter Address.')),
                    );
                  } else if (userProfileProvider.phone == null ||
                      userProfileProvider.phone!.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Please enter Phone Number')),
                    );
                  } else if (userProfileProvider.idProofImage == null) {
                    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                        content: Text('Please select Id Proof Photo')));
                  } else {
                    // Proceed with Register User Profile
                    userProfileProvider.registerUserPofile(
                        context,
                        userProfileProvider.address,
                        userProfileProvider.phone,
                        userProfileProvider.idProofImage);
                  }
                },
                buttonType: ButtonType.Outlined,
              ),

              SizedBox(
                height: 2.h,
              ),
            ]),
          ),
        ),
      ),
    );
  }

  _showExitDialog(BuildContext context) async {
    return showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                  color: Color.fromARGB(255, 211, 211, 211),
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, '/welcomPage', (route) => false);
            },
            child: const Text(
              'Exit',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
