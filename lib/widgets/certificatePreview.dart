import 'package:blood_donation/Providers/certificateProvider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CertificatePreview extends StatelessWidget {
  const CertificatePreview({super.key});
  @override
  Widget build(BuildContext context) {
    final certificateProvider = Provider.of<CertificateProvider>(context);

    if (certificateProvider.isLoading) {
      return Center(child: CircularProgressIndicator());
    }
    return Container(
      height: 31.h,
      width: 90.w,
      margin: EdgeInsets.only(top: 3.h, bottom: 4.h),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          image: const DecorationImage(
              image: AssetImage('assets/certificate.png'), fit: BoxFit.cover)),
      child: Stack(
        children: [
          Center(
            child: Text(certificateProvider.fetchedUsername ?? 'Example',
                style: GoogleFonts.baskervville(fontSize: 20.sp)),
          ),
          Positioned(
              bottom: 11.h,
              left: 22.w,
              child: Text('Here He/She pledge for Organ Donation',
                  style: TextStyle(fontSize: 11.5.sp))),
          Positioned(
              bottom: 6.h,
              left: 21.w,
              child: Text(
                  certificateProvider.consentDate == null
                      ? 'Consent Date'
                      : DateFormat('dd-MM-yyyy').format(
                          DateTime.parse(certificateProvider.consentDate!)),
                  style: GoogleFonts.afacad(fontSize: 14.sp))),
          Positioned(
              bottom: 6.h,
              right: 25.w,
              child: certificateProvider.signImageUrl != null
                  ? Image.network(
                      certificateProvider.signImageUrl!,
                      height: 4.h,
                      width: 10.w,
                    )
                  : Text('Sign', style: TextStyle(fontSize: 14.sp))),
        ],
      ),
    );
  }
}
