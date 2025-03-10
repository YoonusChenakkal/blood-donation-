import 'package:Life_Connect/hospital%20side/Providers/campaignProvider.dart';
import 'package:Life_Connect/hospital%20side/widgets/campCard.dart';
import 'package:Life_Connect/hospital%20side/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HospitalScheduledcamps extends StatelessWidget {
  const HospitalScheduledcamps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Colors.white,
        title: Text(
          'Camps',
          style:
              GoogleFonts.aBeeZee(fontSize: 23.sp, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.red,
        onPressed: () => Navigator.pushNamed(context, '/hospitalSheduledCamp'),
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Consumer<HospitalCampaignProvider>(
          builder: (context, campsProvider, child) {
            if (campsProvider.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (campsProvider.errorMessage != null) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      campsProvider.errorMessage!,
                      style: TextStyle(color: Colors.red, fontSize: 16.sp),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomButton(
                        text: 'Retry',
                        buttonType: ButtonType.Outlined,
                        isLoading: campsProvider.isLoading,
                        onPressed: () => campsProvider.fetchCamps(context))
                  ],
                ),
              );
            }

            if (campsProvider.filteredCamps.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "No Camps Available",
                      style: TextStyle(fontSize: 17.sp),
                    ),
                    SizedBox(
                      height: 2.h,
                    ),
                    CustomButton(
                        text: 'Refresh',
                        buttonType: ButtonType.Outlined,
                        isLoading: campsProvider.isLoading,
                        onPressed: () => campsProvider.fetchCamps(context))
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () => campsProvider.fetchCamps(context),
              child: ListView.builder(
                itemCount: campsProvider.filteredCamps.length,
                itemBuilder: (context, index) {
                  final filteredCamp = campsProvider.filteredCamps[index];
                  return CampCard(filteredCamp: filteredCamp);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
