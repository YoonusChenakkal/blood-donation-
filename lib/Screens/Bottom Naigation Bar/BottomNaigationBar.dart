import 'package:blood_donation/Providers/tabIndexNotifier.dart';
import 'package:blood_donation/Screens/certificatePage.dart';
import 'package:blood_donation/Screens/chat.dart';
import 'package:blood_donation/Screens/home.dart';
import 'package:blood_donation/Screens/profile.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';
import 'package:sizer/sizer.dart';
import 'package:provider/provider.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

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
              const HomePage(),
              const ChatsPage(),
              const CertificatePage(),
              const ProfilePage(),
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
              padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
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
                  unselectedItemColor: const Color.fromARGB(255, 240, 240, 240),
                  type: BottomNavigationBarType.fixed,
                  items: [
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.home,
                        size: 20.sp,
                      ),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.schedule,
                        size: 20.sp,
                      ),
                      label: 'Chat',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.edit_document,
                        size: 20.sp,
                      ),
                      label: 'Certificate',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(
                        Icons.person,
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

  _showExitDialog(BuildContext context) async {
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
                  color: Colors.green,
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
