import 'package:Life_Connect/hospital%20side/widgets/customButton.dart';
import 'package:flutter/material.dart';
import 'package:sizer/sizer.dart';

class HospitalShedulePage extends StatelessWidget {
  const HospitalShedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          centerTitle: true,
          title: Text(
            'Shedules',
            style: TextStyle(fontSize: 23.sp, fontWeight: FontWeight.w600),
          ),
        ),
        body: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 5.h,
                  width: 75.w,
                  child: SearchBar(
                    backgroundColor: WidgetStatePropertyAll(Colors.red[50]),
                    leading: Icon(Icons.search),
                    hintText: 'Search',
                    shape: WidgetStatePropertyAll(RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(6))),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 1.w),
                  child: IconButton(
                      onPressed: () {}, icon: Icon(Icons.filter_list)),
                )
              ],
            ),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(12),
                children: [
                  Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                      left: 2.8.w,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'November',
                        style: TextStyle(
                            fontSize: 17.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 92.w,
                    child: ListTile(
                        title: Text(
                          '● Organ Donation',
                          style: TextStyle(
                              fontSize: 16.2.sp, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '    Kidney Transplataion Of Meera',
                          style: TextStyle(
                              fontSize: 14.5.sp, fontWeight: FontWeight.w500),
                        ),
                        trailing: CustomButton(
                            height: 4,
                            width: 22,
                            text: ' View Details',
                            buttonType: ButtonType.Ovelshaped,
                            onPressed: () {})),
                  ),
                  SizedBox(
                    width: 92.w,
                    child: ListTile(
                        title: Text(
                          '● Blood Donation',
                          style: TextStyle(
                              fontSize: 16.2.sp, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '    A+ blood 1L - Muhammed\n    Donor - Mathew',
                          style: TextStyle(
                              fontSize: 14.5.sp, fontWeight: FontWeight.w500),
                        ),
                        trailing: CustomButton(
                            height: 4,
                            width: 22,
                            text: ' View Details',
                            buttonType: ButtonType.Ovelshaped,
                            onPressed: () {})),
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 2.h,
                      left: 2.8.w,
                    ),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'October',
                        style: TextStyle(
                            fontSize: 17.sp, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  SizedBox(
                    width: 92.w,
                    child: ListTile(
                        title: Text(
                          '● Organ Donation',
                          style: TextStyle(
                              fontSize: 16.2.sp, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '    Kidney Transplataion Of Meera',
                          style: TextStyle(
                              fontSize: 14.5.sp, fontWeight: FontWeight.w500),
                        ),
                        trailing: CustomButton(
                            height: 4,
                            width: 22,
                            text: ' View Details',
                            buttonType: ButtonType.Ovelshaped,
                            onPressed: () {})),
                  ),
                  SizedBox(
                    width: 92.w,
                    child: ListTile(
                        title: Text(
                          '● Blood Donation',
                          style: TextStyle(
                              fontSize: 16.2.sp, fontWeight: FontWeight.w600),
                        ),
                        subtitle: Text(
                          '    A+ blood 1L - Muhammed\n    Donor - Mathew',
                          style: TextStyle(
                              fontSize: 14.5.sp, fontWeight: FontWeight.w500),
                        ),
                        trailing: CustomButton(
                            height: 4,
                            width: 22,
                            text: ' View Details',
                            buttonType: ButtonType.Ovelshaped,
                            onPressed: () {})),
                  ),
                  SizedBox(
                    height: 10.h,
                  ),
                  CustomButton(
                      width: 30,
                      text: 'View All Month',
                      buttonType: ButtonType.Outlined,
                      onPressed: () {})
                ],
              ),
            ),
          ],
        ));
  }
}
