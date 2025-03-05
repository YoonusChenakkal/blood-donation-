import 'package:Life_Connect/hospital%20side/Providers/donorProvider.dart';
import 'package:Life_Connect/hospital%20side/widgets/customButton.dart';
import 'package:Life_Connect/hospital%20side/widgets/donorCard.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HospitalDonorListPage extends StatelessWidget {
  const HospitalDonorListPage({super.key});

  @override
  Widget build(BuildContext context) {
    final List<String> bloodGroups = [
      'All',
      'A+',
      'A-',
      'B+',
      'B-',
      'AB+',
      'AB-',
      'O+',
      'O-'
    ];

    String selectedBloodGroup = 'All';

    void _filterByBloodGroup(BuildContext context, String group) {
      Provider.of<HospitalDonorProvider>(context, listen: false)
          .filterByBloodGroup(group);
    }

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 8.h,
        backgroundColor: Colors.white,
        title: Text(
          'Donor List',
          style:
              GoogleFonts.aBeeZee(fontSize: 23.sp, fontWeight: FontWeight.w600),
        ),
        automaticallyImplyLeading: false,
        centerTitle: true,
      ),
      // floatingActionButton: FloatingActionButton(
      //   heroTag: 'donors Chat', // Assign a unique tag

      //   //  shape: CircleBorder(),
      //   backgroundColor: Colors.red,
      //   onPressed: () => Navigator.pushNamed(context, '/chat'),
      //   child: const Icon(
      //     Icons.chat,
      //     color: Colors.white,
      //   ),
      // ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SizedBox(
                height: 5.h,
                width: 78.w,
                child: SearchBar(
                  onChanged: (query) =>
                      Provider.of<HospitalDonorProvider>(context, listen: false)
                          .searchDonors(query),
                  backgroundColor: const WidgetStatePropertyAll(
                      Color.fromARGB(255, 243, 243, 243)),
                  leading: Icon(Icons.search),
                  hintText: 'Search',
                  shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(6))),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 1.w),
                child: PopupMenuButton<String>(
                  icon: Icon(Icons.filter_list, size: 24.sp),
                  onSelected: (value) {
                    selectedBloodGroup = value;
                    _filterByBloodGroup(context, value);
                  },
                  itemBuilder: (context) {
                    return bloodGroups.map((group) {
                      return PopupMenuItem<String>(
                        value: group,
                        child: Text(
                          group,
                          style: TextStyle(fontSize: 16.sp),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ],
          ),
          SizedBox(
            height: 1.h,
          ),
          Expanded(
            child: Consumer<HospitalDonorProvider>(
              builder: (context, donorProvider, _) {
                if (donorProvider.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (donorProvider.errorMessage != null) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          donorProvider.errorMessage!,
                          style: TextStyle(color: Colors.red, fontSize: 16.sp),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        CustomButton(
                            text: 'Refresh',
                            buttonType: ButtonType.Outlined,
                            isLoading: donorProvider.isLoading,
                            onPressed: () => donorProvider.loadDonors())
                      ],
                    ),
                  );
                }

                if (donorProvider.donors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          'No Donors Available',
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        CustomButton(
                            text: 'Refresh',
                            buttonType: ButtonType.Outlined,
                            isLoading: donorProvider.isLoading,
                            onPressed: () => donorProvider.loadDonors())
                      ],
                    ),
                  );
                }

                if (donorProvider.filteredDonors.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "No donors match your search or filter.",
                          style: TextStyle(fontSize: 17.sp),
                        ),
                        SizedBox(
                          height: 2.h,
                        ),
                        CustomButton(
                            text: 'Refresh',
                            buttonType: ButtonType.Outlined,
                            isLoading: donorProvider.isLoading,
                            onPressed: () => donorProvider.loadDonors())
                      ],
                    ),
                  );
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    await donorProvider.loadDonors();
                  },
                  child: ListView.builder(
                    itemCount: donorProvider.filteredDonors.length,
                    itemBuilder: (context, index) {
                      final donor = donorProvider.filteredDonors[index];

                      return DonorCard(
                        donor: donor,
                      );
                    },
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
