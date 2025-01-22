import 'package:Life_Connect/Providers/campsProvider.dart';
import 'package:Life_Connect/Providers/donorCountProvider.dart';
import 'package:Life_Connect/Providers/hospitalProvider.dart';
import 'package:Life_Connect/Providers/tabIndexNotifier.dart';
import 'package:Life_Connect/Providers/userProfileProvider.dart';
import 'package:Life_Connect/widgets/customBanner.dart';
import 'package:Life_Connect/widgets/customCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sizer/sizer.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  Future<String> _getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'Guest';
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    final donorCountProvider = Provider.of<DonorCountProvider>(context);
    final hospitaProvider = Provider.of<HospitalProvider>(context);
    final campProvider = Provider.of<Campsprovider>(context);
    final tabIndexProvider = Provider.of<TabIndexNotifier>(context);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: FutureBuilder<String>(
          future: _getUsername(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text(
                'Guest',
                style: TextStyle(fontSize: 19.sp, color: Colors.red),
              );
            }
            final username = snapshot.data ?? 'Guest';
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Hello, $username',
                  style: GoogleFonts.archivo(
                    fontSize: 19.sp,
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  'welcome',
                  style: GoogleFonts.archivo(
                    fontSize: 18.sp,
                    color: Colors.black,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        backgroundColor: Colors.white,
        toolbarHeight: 9.h,
        actions: [
          Container(
            width: 7.h,
            padding: const EdgeInsets.all(1),
            margin: EdgeInsets.symmetric(horizontal: 3.w),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.red, width: 1.5),
                color: Colors.white,
                shape: BoxShape.circle,
                image: DecorationImage(
                    image: userProfileProvider.profileData['profileImage'] ==
                                null ||
                            userProfileProvider.profileData['profileImage'] ==
                                ''
                        ? const AssetImage('assets/man.png')
                        : NetworkImage(
                            userProfileProvider.profileData['profileImage'],
                          ),
                    fit: BoxFit.cover)),
          ),
        ],
      ),
      body: SizedBox(
        height: 100.h,
        width: 100.w,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 2.h,
              ),
              CustomBanner(
                title1: 'Donate If You Can\nSave One Life',
                title2: 'Make them happy',
                textColor: Colors.white,
                buttonText: 'View',
                onPressed: () => showDonationDialog(context),
                imageUrl: 'assets/bg_surgery.jpg',
              ),
              SizedBox(height: 2.h),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.5.w),
                child: Row(
                  children: [
                    CustomCard(
                      title: 'Total\nDonors',
                      count: donorCountProvider.donorCount,
                      image: Image.asset(
                        'assets/donors.png',
                        height: 3.h,
                      ),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    CustomCard(
                      title: 'Total\nHospitals',
                      count: hospitaProvider.hospitals.length.toString(),
                      image: Image.asset(
                        'assets/hospital-1.png',
                        height: 4.h,
                      ),
                    ),
                    SizedBox(
                      width: 6.w,
                    ),
                    CustomCard(
                      title: 'Total\nCamps',
                      count: campProvider.camp.length.toString(),
                      image: Image.asset(
                        'assets/camp.png',
                        height: 4.h,
                      ),
                    )
                  ],
                ),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 2.h,
                  left: 3.5.w,
                  bottom: 1.h,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'New Message',
                    style: TextStyle(
                      fontSize: 13.4.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomBanner(
                title1: campProvider.camp.isNotEmpty
                    ? DateFormat('MMMM dd')
                        .format(campProvider.camp.last.date ?? DateTime.now())
                    : 'No Recent Camp',
                title2: campProvider.camp.isNotEmpty
                    ? '${campProvider.camp.last.description.toString()}\nLocation : ${campProvider.camp.last.location.toString()}'
                    : 'There are no recent camps available at the moment.',
                buttonText: 'View',
                textColor: Colors.black,
                onPressed: () => tabIndexProvider.setIndex(1),
              ),
              Padding(
                padding: EdgeInsets.only(
                  top: 1.5.h,
                  left: 3.5.w,
                  bottom: 1.h,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Certificate',
                    style: TextStyle(
                      fontSize: 15.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              CustomBanner(
                title1: 'Graphical Analystics',
                title2: 'Analytics of Donors and Hospitals',
                textColor: Colors.white,
                buttonText: 'View',
                onPressed: () {
                  showPieChart(context, donorCountProvider, hospitaProvider);
                },
                imageUrl: 'assets/bg_graph.jpg',
              ),
            ],
          ),
        ),
      ),
    );
  }

  showPieChart(BuildContext context, DonorCountProvider donorCountProvider,
      HospitalProvider hospitalProvider) {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        final donorCount =
            double.tryParse(donorCountProvider.donorCount!) ?? 0.0;
        final hospitalCount = hospitalProvider.hospitals.length.toDouble();
        final total = hospitalCount + donorCount;

        return AlertDialog(
          contentPadding: const EdgeInsets.all(8),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'Donor and Hospital Ratio',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                  color: Colors.black,
                ),
              ),
              SizedBox(height: 2.h),
              SizedBox(
                height: 20.h,
                width: 60.w,
                child: SfCircularChart(
                  series: <PieSeries>[
                    PieSeries<dynamic, String>(
                      dataSource: [
                        {'category': 'Hospitals', 'value': hospitalCount},
                        {'category': 'Donors', 'value': donorCount},
                      ],
                      xValueMapper: (data, _) => data['category'] as String,
                      yValueMapper: (data, _) => data['value'] as double,
                      dataLabelMapper: (data, _) =>
                          '${((data['value'] as double) / total * 100).toStringAsFixed(1)}%',
                      dataLabelSettings: const DataLabelSettings(
                        isVisible: true,
                      ),
                      pointColorMapper: (data, _) {
                        if (data['category'] == 'Hospitals') {
                          return Colors.redAccent;
                        } else {
                          return Colors.blueAccent;
                        }
                      },
                    )
                  ],
                ),
              ),
              SizedBox(height: 2.h),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 2.w,
                        height: 2.w,
                        color: Colors.redAccent,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Hospitals',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Container(
                        width: 2.w,
                        height: 2.w,
                        color: Colors.blueAccent,
                      ),
                      SizedBox(width: 2.w),
                      Text(
                        'Donors',
                        style: TextStyle(fontSize: 12.sp),
                      ),
                    ],
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }

  showDonationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          content: Container(
            padding: EdgeInsets.all(4.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Donate If You Can Save One Life',
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight: FontWeight.bold,
                    color: Colors.redAccent,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                Text(
                  'Every donation can change a life! You have the power to save lives and make a positive impact on the community. Every drop counts!',
                  style: TextStyle(
                    fontSize: 14.sp,
                    color: Colors.black54,
                  ),
                  textAlign: TextAlign.center,
                ),
                SizedBox(height: 2.h),
                ElevatedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.redAccent),
                  ),
                  child: Text(
                    'Close',
                    style: TextStyle(color: Colors.white, fontSize: 14.sp),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
