import 'package:blood_donation/Providers/campsProvider.dart';
import 'package:blood_donation/widgets/campCard.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Scheduledcamps extends StatelessWidget {
  const Scheduledcamps({super.key});

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
      body: Padding(
        padding: EdgeInsets.only(top: 2.h),
        child: Consumer<Campsprovider>(
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

            if (campsProvider.camp.isEmpty) {
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
                itemCount: campsProvider.camp.length,
                itemBuilder: (context, index) {
                  final camp = campsProvider.camp[index];
                  return CampCard(camp: camp);
                },
              ),
            );
          },
        ),
      ),
    );
  }
}
