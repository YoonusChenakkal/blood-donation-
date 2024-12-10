import 'package:blood_donation/Providers/authProvider.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:blood_donation/widgets/customDropdown.dart';
import 'package:blood_donation/widgets/customTextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
                'https://img.freepik.com/free-photo/portrait-hospitalized-sick-girl-child-patient-holding-teddy-bear-resting-bed-medical-co_482257-12229.jpg'),
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
                      'Register',
                      style: TextStyle(
                        fontSize: 23.sp,
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Consumer<AuthProvider>(
                    builder: (context, authProvider, child) {
                      return Column(
                        children: [
                          CustomTextfield(
                            hintText: 'Enter Your Name',
                            icon: Icons.person,
                            onChanged: (value) {
                              authProvider.name = value;
                            },
                            enabled: authProvider.showOtpField ? false : true,
                          ), // Name Textfield
                          SizedBox(
                            height: 3.h,
                          ),
                          CustomTextfield(
                            hintText: 'Enter Your Email',
                            icon: Icons.email,
                            enabled: authProvider.showOtpField ? false : true,
                            onChanged: (value) {
                              authProvider.email = value;
                            },
                          ), // Email Textfield
                          SizedBox(
                            height: 3.h,
                          ),
                          // Blood Type Dropdown
                          Customdropdown(
                            enabled: authProvider.showOtpField ? false : true,
                          ),
                          // Show OTP field only if the response code was 201
                          if (authProvider.showOtpField) ...[
                            SizedBox(
                              height: 3.h,
                            ),
                            CustomTextfield(
                              hintText: 'Enter OTP',
                              icon: Icons.lock,
                              onChanged: (data) {
                                authProvider.otp = data;
                              },
                            ),
                          ],
                          SizedBox(
                            height: 4.5.h,
                          ),
                          // Submit Button
                          CustomButton(
                            text: authProvider.showOtpField
                                ? 'Submit'
                                : 'Generate OTP',
                            onPressed: authProvider.showOtpField
                                ? () {
                                    if (authProvider.otp!.isEmpty ||
                                        authProvider.otp == null) {
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text('Please Enter OTP')),
                                      );
                                    } else {
                                      authProvider.verifyRegisterOtp(
                                          authProvider.otp!, context);
                                    }
                                  }
                                : () {
                                    // Check if all required fields are filled
                                    if (authProvider.name == null ||
                                        authProvider.name!.isEmpty ||
                                        authProvider.email == null ||
                                        authProvider.email!.isEmpty ||
                                        authProvider.bloodGroup == null ||
                                        authProvider.bloodGroup!.isEmpty) {
                                      // Show error message if any field is empty
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(
                                        const SnackBar(
                                            content: Text(
                                                'Please fill all fields.')),
                                      );
                                    } else {
                                      // Proceed with registration
                                      authProvider.register(
                                        authProvider.name!,
                                        authProvider.email!,
                                        authProvider.bloodGroup!,
                                        context,
                                      );
                                    }
                                  },
                            buttonType: ButtonType.Outlined,
                          ),
                          // Conditionally show Cancel button if OTP field is visible
                          if (authProvider.showOtpField)
                            SizedBox(
                              height: 2.h,
                            ),
                          if (authProvider.showOtpField)
                            CustomButton(
                              text: 'Cancel',
                              onPressed: () =>
                                  // When cancel button is pressed, hide OTP field
                                  authProvider.showOtpField = false,
                              buttonType: ButtonType.Elevated,
                            ),
                        ],
                      );
                    },
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
