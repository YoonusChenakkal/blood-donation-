import 'package:blood_donation/Providers/authProvider.dart';
import 'package:blood_donation/Services/authService.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:blood_donation/widgets/customDropdown.dart';
import 'package:blood_donation/widgets/customTextfield.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Register extends StatelessWidget {
  const Register({super.key});

  @override
  Widget build(BuildContext context) {
    String responseMessage;
    final authProvider = Provider.of<AuthProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        authProvider.name = null;
        authProvider.email = null;
        authProvider.otp = null;
        authProvider.bloodGroup = null;
        authProvider.showOtpField = false;
      },
      child: Scaffold(
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
                    authProvider.bloodGroup = null;
                    authProvider.showOtpField = false;
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
                        style: GoogleFonts.nunito(
                          fontSize: 23.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),

                    CustomTextfield(
                      width: 85,
                      hintText: 'Enter Your Name',
                      keyboardType: TextInputType.name,
                      icon: Icons.person,
                      onChanged: (value) {
                        authProvider.name = value.trim();
                      },
                      enabled: authProvider.showOtpField ? false : true,
                    ), // Name Textfield
                    SizedBox(
                      height: 1.h,
                    ),
                    CustomTextfield(
                      width: 85,
                      hintText: 'Enter Your Email',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                      enabled: authProvider.showOtpField ? false : true,
                      onChanged: (value) {
                        authProvider.email = value.trim();
                      },
                    ), // Email Textfield
                    SizedBox(
                      height: 1.h,
                    ),
                    // Blood Type Dropdown
                    Customdropdown(
                      enabled: authProvider.showOtpField ? false : true,
                      hintText: 'Blood Group',
                      selectedValue: authProvider.bloodGroup,
                      onChanged: (value) {
                        authProvider.bloodGroup = value;
                      },
                    ),
                    // Show OTP field only if the response code was 201
                    if (authProvider.showOtpField) ...[
                      SizedBox(
                        height: 1.h,
                      ),
                      CustomTextfield(
                        width: 85,
                        hintText: 'Enter OTP',
                        keyboardType: TextInputType.number,
                        icon: Icons.lock,
                        onChanged: (value) {
                          authProvider.otp = value.trim();
                        },
                      ),
                    ],
                    SizedBox(
                      height: 4.5.h,
                    ),
                    // Submit Button
                    CustomButton(
                      width: 60,
                      text: authProvider.showOtpField ? 'Register' : 'Submit',
                      isLoading: authProvider.isLoading,
                      textColor: const Color.fromARGB(255, 230, 3, 3),
                      onPressed: authProvider.showOtpField
                          ? () async {
                              if (authProvider.otp!.isEmpty ||
                                  authProvider.otp == null) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please Enter OTP')),
                                );
                              } else {
                                responseMessage =
                                    await authService.verifyRegisterOtp(
                                        authProvider.email!,
                                        authProvider.otp!,
                                        context,
                                        authProvider);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(responseMessage)),
                                );
                              }
                            }
                          : () async {
                              // Check if all required fields are filled
                              if (authProvider.name == null ||
                                  authProvider.name!.isEmpty ||
                                  authProvider.email == null ||
                                  authProvider.email!.isEmpty ||
                                  authProvider.bloodGroup == null ||
                                  authProvider.bloodGroup!.isEmpty) {
                                // Show error message if any field is empty
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                      content: Text('Please fill all fields.')),
                                );
                              } else {
                                // Proceed with registration
                                responseMessage =
                                    await authService.registerUser(
                                        authProvider.name!,
                                        authProvider.email!,
                                        authProvider.bloodGroup!,
                                        authProvider);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(content: Text(responseMessage)),
                                );
                              }
                            },
                      buttonType: ButtonType.Outlined,
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
