import 'package:Life_Connect/hospital%20side/Screens/SheduledCamp.dart';
import 'package:Life_Connect/hospital%20side/Screens/donorList.dart';
import 'package:Life_Connect/hospital%20side/Screens/home.dart';
import 'package:Life_Connect/hospital%20side/Screens/profile.dart';
import 'package:Life_Connect/tabIndexNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class HospitalCustomBottomNavigationBar extends StatelessWidget {
  const HospitalCustomBottomNavigationBar({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (did) {
        return _showExitDialog(context);
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Consumer<TabIndexNotifier>(
          builder: (context, tabIndexNotifier, child) {
            final screens = [
              const HospitalHomePage(),
              // const ChatsPage(),
              const HospitalScheduledcamps(),
              const HospitalDonorListPage(),
              const HospitalProfilePage(),
            ];

            return IndexedStack(
              index: tabIndexNotifier.currentIndex,
              children: screens,
            );
          },
        ),
        bottomNavigationBar: Consumer<TabIndexNotifier>(
          builder: (context, tabIndexNotifier, child) {
            return Padding(
              padding: EdgeInsets.only(right: 3.5.w, left: 3.5.w, top: 1.h),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: BottomNavigationBar(
                  currentIndex: tabIndexNotifier.currentIndex,
                  onTap: (index) {
                    tabIndexNotifier.setIndex(index);
                  },
                  elevation: 0,
                  backgroundColor: Colors.red,
                  selectedItemColor: Colors.white,
                  unselectedItemColor: const Color.fromARGB(255, 255, 184, 184),
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home_filled,
                        size: 20.sp,
                      ),
                      label: 'Home',
                    ),
                    // BottomNavigationBarItem(
                    //   icon: Icon(
                    //     Icons.message_outlined,
                    //     size: 20.sp,
                    //   ),
                    //   label: 'chat',
                    // ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.campaign_outlined,
                        size: 20.sp,
                      ),
                      label: 'Camp',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.list,
                        size: 20.sp,
                      ),
                      label: 'Donor List',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person_2_outlined,
                        size: 20.sp,
                      ),
                      label: 'Profile',
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  _showExitDialog(
    BuildContext context,
  ) async {
    return showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirm Exit'),
        content: const Text('Are you sure you want to exit?'),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pop(context, false); // Close dialog
            },
            child: const Text(
              'Cancel',
              style: TextStyle(
                  color: Colors.blue,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
          TextButton(
            onPressed: () {
              Navigator.popUntil(context, (route) => false);
              SystemNavigator.pop();
            },
            child: const Text(
              'Exit',
              style: TextStyle(
                  color: Colors.redAccent,
                  fontSize: 15,
                  fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
