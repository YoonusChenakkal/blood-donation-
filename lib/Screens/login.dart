import 'package:blood_donation/Proiders/authProvider.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:blood_donation/widgets/customTextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Login extends StatelessWidget {
  const Login({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
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
        child: Stack(children: [
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
            child:
                Column(mainAxisAlignment: MainAxisAlignment.center, children: [
              Container(
                padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
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
                enabled: authProvider.showOtpField ? false : true,
                hintText: 'Enter Your Email',
                icon: Icons.email,
                onChanged: (value) {
                  authProvider.email = value;
                },
              ), // Email Textfield
              if (authProvider.showOtpField) ...[
                SizedBox(
                  height: 2.h,
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
                text: authProvider.showOtpField ? 'Login' : 'Submit',
                onPressed: () {
                  // Check email fields is filled
                  if (authProvider.email == null ||
                      authProvider.email!.isEmpty) {
                    // Show error message if any field is empty
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter email.')),
                    );
                  } else if (authProvider.showOtpField &&
                      (authProvider.otp == null || authProvider.otp!.isEmpty)) {
                    // Check if OTP field is filled only when OTP field is visible
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Please enter OTP.')),
                    );
                  } else {
                    // Proceed with Login
                    authProvider.showOtpField
                        ? authProvider.verifyLoginOtp(
                            authProvider.email!, authProvider.otp!, context)
                        : authProvider.loginOtpRequest(
                            authProvider.email!, context);
                  }
                },
                buttonType: ButtonType.Outlined,
              ),

              SizedBox(
                height: 2.h,
              ),
            ]),
          )
        ]),
      ),
    );
  }
}
