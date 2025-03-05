import 'package:Life_Connect/user side/Providers/authProvider.dart';
import 'package:Life_Connect/user side/Providers/userProfileProvider.dart';
import 'package:Life_Connect/user side/widgets/customButton.dart';
import 'package:Life_Connect/user side/widgets/customCheckbox.dart';
import 'package:Life_Connect/user side/widgets/customDropdown.dart';
import 'package:Life_Connect/user side/widgets/customIdProof.dart';
import 'package:Life_Connect/user side/widgets/customMultiSelect.dart';
import 'package:Life_Connect/user side/widgets/customTextfield.dart';
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
        resizeToAvoidBottomInset: false,
        backgroundColor: Colors.black,
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/bg_nurse2.jpg',
              ),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: SizedBox(
            height: 100.h,
            width: 100.w,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Header
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

                // Name Textfield
                CustomTextfield(
                  enabled: false,
                  hintText:
                      authProvider.name ?? userProfileProvider.name ?? 'Name',
                  keyboardType: TextInputType.name,
                  icon: Icons.person_2_outlined,
                  onChanged: (value) {
                    userProfileProvider.name = value.trim();
                  },
                ),
                SizedBox(height: 1.3.h),

                // Address Textfield
                CustomTextfield(
                  hintText: 'Address',
                  keyboardType: TextInputType.streetAddress,
                  icon: Icons.place_outlined,
                  onChanged: (value) {
                    userProfileProvider.address = value.trim();
                  },
                ),
                SizedBox(height: 1.3.h),

                // Phone Textfield
                CustomTextfield(
                  hintText: 'Phone',
                  keyboardType: TextInputType.number,
                  icon: Icons.phone_in_talk_outlined,
                  maxLength: 10,
                  onChanged: (value) {
                    userProfileProvider.phone = value.trim();
                  },
                ),
                SizedBox(height: 1.3.h),

                // Blood Group Dropdown
                Customdropdown(
                  enabled: userProfileProvider.bloodGroup == null ||
                          userProfileProvider.bloodGroup!.isEmpty
                      ? true
                      : false,
                  hintText: authProvider.bloodGroup ?? 'Blood Group',
                  onChanged: (value) {
                    authProvider.bloodGroup = value;
                  },
                ),
                SizedBox(height: 1.3.h),

                // ID Proof Widget
                const CustomIdProof(),
                SizedBox(height: 1.3.h),
                CustomCheckbox(
                  title: 'Willing to Donate Organ',
                  textColor: Colors.white,
                  isChecked: userProfileProvider.isOrganChecked,
                  onChanged: (value) {
                    userProfileProvider.isOrganChecked = value!;
                  },
                ),
                if (userProfileProvider.isOrganChecked)
                  CustomMultiSelectDropdown(
                    title: 'Select Organs to Donate',
                    options: ['Heart', 'Liver', 'Kidney', 'Lungs', 'Eyes'],
                    selectedItems: userProfileProvider.organsToDonate,
                    onChanged: (selected) {
                      userProfileProvider.updateOrgansToDonate(selected);
                    },
                  ),
                SizedBox(height: 1.3.h),

                // Willing to Donate Blood Checkbox
                CustomCheckbox(
                  title: 'Willing to Donate Blood',
                  textColor: Colors.white,
                  isChecked: userProfileProvider.isBloodChecked,
                  onChanged: (value) {
                    userProfileProvider.isBloodChecked = value!;
                  },
                ),

                // Willing to Donate Organ Checkbox

                SizedBox(height: 3.h),

                // Submit Button
                CustomButton(
                  text: 'Submit',
                  textColor: const Color.fromARGB(255, 230, 3, 3),
                  isLoading: userProfileProvider.isLoading,
                  color: const Color.fromARGB(255, 230, 3, 3),
                  onPressed: () {
                    if (userProfileProvider.address == null ||
                        userProfileProvider.address!.isEmpty) {
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
                    } else if ((userProfileProvider.isOrganChecked &&
                        (userProfileProvider.organsToDonate as List).isEmpty)) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Select organs')),
                      );
                    } else if (userProfileProvider.phone!.length < 10) {
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content: Text('Number must be 10 digits')));
                    } else {
                      userProfileProvider.registerUserPofile(
                        context,
                        userProfileProvider.address,
                        userProfileProvider.phone,
                        userProfileProvider.idProofImage,
                        userProfileProvider.organsToDonate,
                      );
                    }
                  },
                  buttonType: ButtonType.Outlined,
                ),

                SizedBox(height: 2.h),
              ],
            ),
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
