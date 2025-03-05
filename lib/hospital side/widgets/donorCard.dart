import 'package:Life_Connect/hospital%20side/Models/donorModel.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:sizer/sizer.dart';

class DonorCard extends StatelessWidget {
  final DonorModel donor;

  const DonorCard({
    super.key,
    required this.donor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(horizontal: 3.5.w, vertical: 1.h),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(12),
        color: Colors.white,
        border: Border.all(color: Colors.red, width: 1.4),
        boxShadow: const [
          BoxShadow(
            blurRadius: 3,
            color: Color.fromARGB(90, 0, 0, 0),
            offset: Offset(2, 1),
          ),
        ],
      ),
      child: ListTile(
        onTap: () => Navigator.pushNamed(context, '/hospitalDonorDetails',
            arguments: donor),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(6),
            color: Colors.red,
          ),
          child: Text(
            donor.bloodGroup,
            style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18.sp),
          ),
        ),
        title: Text(
          donor.user,
          style: GoogleFonts.nunitoSans(
            fontSize: 17.sp,
            color: Colors.red,
            fontWeight: FontWeight.w700,
          ),
        ),
        subtitle: Text(
          donor.address,
          style: GoogleFonts.roboto(),
        ),
      ),
    );
  }
}
