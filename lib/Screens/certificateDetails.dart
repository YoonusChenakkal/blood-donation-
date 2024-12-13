import 'package:blood_donation/widgets/customIdProof.dart';
import 'package:flutter/material.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:blood_donation/widgets/customCheckBox.dart';
import 'package:blood_donation/widgets/customDropdown.dart';
import 'package:blood_donation/widgets/customTextfield.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CertificateDetails extends StatefulWidget {
  const CertificateDetails({super.key});

  @override
  _CertificateDetailsState createState() => _CertificateDetailsState();
}

class _CertificateDetailsState extends State<CertificateDetails> {
  // TextEditingController _tcName = TextEditingController();
  // TextEditingController _tcPhone = TextEditingController();
  // TextEditingController _tcEmail = TextEditingController();
  String selectedBloodType = '';
  bool _isChecked = false;

  void _handleCheckboxChanged(bool? value) {
    setState(() {
      _isChecked = value ?? false;
    });
  }

  @override
  Widget build(BuildContext context) {
    // final authProvider = Provider.of<AuthProvider>(context);
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        height: 100.h,
        width: 100.w,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: NetworkImage(
              'https://t4.ftcdn.net/jpg/01/34/88/19/240_F_134881906_gdIsbeci13e4p6XZ3Kn0l0MYmrueJ20q.jpg',
            ),
            fit: BoxFit.cover,
            opacity: 0.5,
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Positioned(
              left: 0.7.w,
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
            Positioned(
              top: 14.h,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    'Hello, Please enter the details',
                    style: TextStyle(
                        fontSize: 19.sp,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
                  SizedBox(height: 3.h),
                  CustomTextfield(
                      hintText: 'Name',
                      keyboardType: TextInputType.name,
                      onChanged: (a) {},
                      //  tc: _tcName,
                      icon: Icons.person_2_outlined),
                  SizedBox(height: 3.h),
                  CustomTextfield(
                      hintText: 'Mobile Number',
                      keyboardType: TextInputType.number,
                      onChanged: (a) {},
                      //  tc: _tcPhone,
                      icon: Icons.phone_in_talk_outlined),
                  SizedBox(height: 3.h),
                  CustomTextfield(
                      hintText: 'Email',
                      keyboardType: TextInputType.emailAddress,
                      onChanged: (a) {},
                      //   tc: _tcEmail,
                      icon: Icons.email_outlined),
                  SizedBox(height: 3.h),
                  Customdropdown(
                    hintText: 'Blood Group',
                  ),
                  SizedBox(height: 3.h),
                  SizedBox(
                    width: 75.w,
                    child: Text(
                      'Id proof',
                      style: TextStyle(
                          fontSize: 17.sp,
                          fontWeight: FontWeight.bold,
                          color: Colors.white),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  CustomIdProof(),
                  SizedBox(height: 1.h),
                  CustomCheckbox(
                      title: 'Iam ready to donate my organs',
                      isChecked: _isChecked,
                      onChanged: _handleCheckboxChanged),
                  CustomCheckbox(
                      title: 'Iam ready to donate my organs',
                      isChecked: _isChecked,
                      onChanged: _handleCheckboxChanged),
                  SizedBox(height: 5.h),
                  CustomButton(
                    width: 65,
                    text: 'Generate Certificate',
                    onPressed: () {},
                    buttonType: ButtonType.Outlined,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
