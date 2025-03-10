import 'package:Life_Connect/hospital%20side/Models/campRegistrationsModel.dart';
import 'package:Life_Connect/hospital%20side/Models/campsModel.dart';
import 'package:Life_Connect/hospital%20side/Providers/campaignProvider.dart';
import 'package:Life_Connect/hospital%20side/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class userRegisteredListSection extends StatefulWidget {
  const userRegisteredListSection({super.key, required this.filteredCamp});
  final CampsModel filteredCamp;

  @override
  State<userRegisteredListSection> createState() =>
      _userRegisteredListSectionState();
}

class _userRegisteredListSectionState extends State<userRegisteredListSection> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<HospitalCampaignProvider>(context)
        .fetchRegistrations(widget.filteredCamp.id, context);
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
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
                      onPressed: () => campsProvider.fetchRegistrations(
                          widget.filteredCamp.id, context))
                ],
              ),
            );
          }

          if (campsProvider.campRegistrations.isEmpty) {
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
                      onPressed: () => campsProvider.fetchRegistrations(
                          widget.filteredCamp.id, context))
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await campsProvider.fetchRegistrations(
                  widget.filteredCamp.id, context);
            },
            child: Column(
              children: [
                // Pull down to refresh text

                // List of registered users
                Expanded(
                  child: ListView.builder(
                    itemCount: campsProvider.campRegistrations.isNotEmpty
                        ? campsProvider
                            .campRegistrations[0].registrations.length
                        : 0,
                    itemBuilder: (context, index) {
                      final registeredUserList = campsProvider
                          .campRegistrations[0].registrations[index];
                      return Container(
                        margin: EdgeInsets.symmetric(
                            horizontal: 3.5.w, vertical: .6.h),
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
                          trailing: Container(
                            padding:
                                const EdgeInsets.symmetric(horizontal: 8.0),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(6),
                              color: Colors.red,
                            ),
                            child: Text(
                              registeredUserList.bloodGroup,
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18.sp,
                              ),
                            ),
                          ),
                          title: Text(
                            registeredUserList.username,
                            style: GoogleFonts.nunitoSans(
                              fontSize: 17.sp,
                              color: Colors.red,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          subtitle: Text(
                            registeredUserList.address,
                            style: GoogleFonts.roboto(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: .5.h),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.arrow_downward,
                      ),
                      SizedBox(
                        width: 2.w,
                      ),
                      Text(
                        'Pull down to refresh',
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w500,
                          color: Colors.black54,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
