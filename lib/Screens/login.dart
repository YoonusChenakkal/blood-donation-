import 'package:blood_donation/Services/authService.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';
import 'package:blood_donation/Providers/authProvider.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:blood_donation/widgets/customTextfield.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    String responseMessage;

    final authProvider = Provider.of<AuthProvider>(context);
    final authService = Provider.of<AuthService>(context);

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
              image: NetworkImage(
                'https://c1.wallpaperflare.com/preview/910/704/36/guardian-angel-doctor-health-angel.jpg',
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
                        style: GoogleFonts.nunito(
                          fontSize: 23.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomTextfield(
                      width: 85,
                      enabled: !authProvider.showOtpField,
                      hintText: 'Enter Your Email',
                      keyboardType: TextInputType.emailAddress,
                      icon: Icons.email,
                      onChanged: (value) {
                        authProvider.email = value;
                      },
                    ),
                    if (authProvider.showOtpField) ...[
                      SizedBox(
                        height: 1.5.h,
                      ),
                      CustomTextfield(
                        width: 85,
                        hintText: 'Enter OTP',
                        keyboardType: TextInputType.number,
                        icon: Icons.lock,
                        onChanged: (data) {
                          authProvider.otp = data;
                        },
                      ),
                      SizedBox(height: 2.h),
                      GestureDetector(
                        onTap: () async {
                          if (authProvider.isResendEnabled) {
                            responseMessage = await authService.requestLoginOtp(
                                authProvider.email!, context, authProvider);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                              content: Text(responseMessage),
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
                      width: 60,
                      text: authProvider.showOtpField ? 'Login' : 'Submit',
                      isLoading: authProvider.isLoading,
                      onPressed: () async {
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
                              ? responseMessage =
                                  await authService.verifyLoginOtp(
                                      authProvider.email!,
                                      authProvider.otp!,
                                      context,
                                      authProvider)
                              : responseMessage =
                                  await authService.requestLoginOtp(
                                      authProvider.email!,
                                      context,
                                      authProvider);

                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(responseMessage)),
                          );
                        }
                      },
                      buttonType: ButtonType.Outlined,
                    ),
                    SizedBox(height: 2.h),
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
