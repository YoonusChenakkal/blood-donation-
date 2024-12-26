import 'package:blood_donation/Providers/campsProvider.dart';
import 'package:blood_donation/widgets/campCard.dart';
import 'package:blood_donation/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class Sheduledcamps extends StatelessWidget {
  const Sheduledcamps({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Camps',
          style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      body: SizedBox(
        height: double.infinity,
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
                        onPressed: () => campsProvider.fetchCamps(context))
                  ],
                ),
              );
            }

            return ListView.builder(
              itemCount: campsProvider.camp.length,
              itemBuilder: (context, index) {
                final camp = campsProvider.camp[index];
                return Campcard(camp: camp);
              },
            );
          },
        ),
      ),
    );
  }
}
