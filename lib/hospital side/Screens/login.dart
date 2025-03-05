import 'package:Life_Connect/hospital%20side/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:Life_Connect/hospital%20side/Providers/authProvider.dart';
import 'package:Life_Connect/hospital%20side/widgets/customButton.dart';
import 'package:Life_Connect/hospital%20side/widgets/customTextfield.dart';

class HospitalLogin extends StatelessWidget {
  const HospitalLogin({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<HospitalAuthProvider>(context);
    final authService = Provider.of<HospitalAuthService>(context);

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        authProvider.isResendEnabled = false;
        authProvider.stopTimer();
        authProvider.showOtpField = false;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/bg_angel.jpg',
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
                    authProvider.showOtpField = false;
                    authProvider.isResendEnabled = false;
                    authProvider.stopTimer();
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
                        'Login',
                        style: TextStyle(
                          fontSize: 23.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomTextfield(
                      enabled: !authProvider.showOtpField,
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                      onChanged: (value) {
                        authProvider.email = value.trim();
                      },
                    ),
                    if (authProvider.showOtpField) ...[
                      SizedBox(
                        height: 2.h,
                      ),
                      CustomTextfield(
                        hintText: 'Enter OTP',
                        keyboardType: TextInputType.number,
                        icon: Icons.lock,
                        onChanged: (data) {
                          authProvider.otp = data.trim();
                        },
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onTap: () {
                          if (authProvider.isResendEnabled) {
                            ScaffoldMessenger.of(context)
                                .showSnackBar(const SnackBar(
                              content: Text("OTP resent successfully!"),
                            ));
                            authProvider.startTimer();
                          }
                        },
                        child: Text(
                          authProvider.isResendEnabled
                              ? 'Resend OTP'
                              : 'Resend OTP (${authProvider.timeLeft}s)',
                          style: TextStyle(
                            color: authProvider.isResendEnabled
                                ? Colors.blue
                                : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                    SizedBox(
                      height: 4.5.h,
                    ),
                    CustomButton(
                      text: authProvider.showOtpField ? 'Login' : 'Submit',
                      isLoading: authProvider.isLoading,
                      onPressed: () {
                        if (authProvider.email == null ||
                            authProvider.email!.isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                                content: Text('Please enter email.')),
                          );
                        } else if (authProvider.showOtpField &&
                            (authProvider.otp == null ||
                                authProvider.otp!.isEmpty)) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(content: Text('Please enter OTP.')),
                          );
                        } else {
                          authProvider.showOtpField
                              ? authService.verifyLoginOtp(authProvider.email!,
                                  authProvider.otp!, context, authProvider)
                              : authService.requestLoginOtp(
                                  authProvider.email!, context, authProvider);
                        }
                      },
                      buttonType: ButtonType.Outlined,
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "Don't have an account?",
                          style: TextStyle(color: Colors.white),
                        ),
                        TextButton(
                            onPressed: () {
                              Navigator.pushReplacementNamed(
                                  context, '/hospitalRegister');
                            },
                            child: const Text(
                              'Register',
                              style: TextStyle(
                                  color: Color.fromARGB(255, 255, 17, 0)),
                            ))
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
