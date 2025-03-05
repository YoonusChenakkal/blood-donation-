import 'package:Life_Connect/hospital%20side/Models/campsModel.dart';
import 'package:Life_Connect/hospital%20side/Providers/campaignProvider.dart';
import 'package:Life_Connect/hospital%20side/widgets/customButton.dart';
import 'package:Life_Connect/hospital%20side/widgets/customTextfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class HospitalEditCampDetails extends StatelessWidget {
  const HospitalEditCampDetails({super.key});

  @override
  Widget build(BuildContext context) {
    final campaignProvider = Provider.of<HospitalCampaignProvider>(context);
    final CampsModel filteredCamp =
        ModalRoute.of(context)!.settings.arguments as CampsModel;

    _pickDate(BuildContext context) async {
      final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2100),
      );
      if (picked != null) {
        campaignProvider.setDate(picked);
      }
    }

    _pickTime(BuildContext context, {required bool isStartTime}) async {
      final TimeOfDay? picked = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );
      if (picked != null) {
        if (isStartTime) {
          campaignProvider.setStartTime(picked);
        } else {
          campaignProvider.setEndTime(picked);
        }
      }
    }

    TimeOfDay? parseTime(String? time) {
      if (time == null || time.isEmpty) return null;
      final parts = time.split(':');
      if (parts.length != 2) return null;
      final hour = int.tryParse(parts[0]);
      final minute = int.tryParse(parts[1]);
      if (hour == null || minute == null) return null;
      return TimeOfDay(hour: hour, minute: minute);
    }

    String formatDate(DateTime? date) {
      if (date == null) return 'Select Date';
      return '${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString().substring(2)}';
    }

    String formatTime(TimeOfDay? time, {required bool isStartTime}) {
      if (time == null) return isStartTime ? 'Start Time' : 'End Time';

      // Convert to 12-hour format with AM/PM
      final hour =
          time.hour > 12 ? time.hour - 12 : (time.hour == 0 ? 12 : time.hour);
      final period = time.hour >= 12 ? 'PM' : 'AM';
      final minute = time.minute.toString().padLeft(2, '0');

      return '$hour:$minute $period';
    }

    print('Start Time: ${filteredCamp.startTime}');
    print('End Time: ${filteredCamp.endTime}');

    return WillPopScope(
      onWillPop: () async {
        campaignProvider.clearForm();
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Container(
          height: 100.h,
          width: 100.w,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage(
                'assets/bg_threenurse.jpg',
              ),
              fit: BoxFit.cover,
              opacity: 0.3,
            ),
          ),
          child: Stack(
            children: [
              Positioned(
                top: 4.h,
                child: IconButton(
                  onPressed: () {
                    campaignProvider.clearForm();
                    Navigator.pop(context);
                  },
                  icon: Icon(
                    Icons.arrow_back,
                    color: const Color.fromARGB(255, 209, 209, 209),
                    size: 24.sp,
                  ),
                ),
              ),
              SizedBox(
                height: 100.h,
                width: 100.w,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 8.w, vertical: 3.h),
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Edit Camp',
                        style: TextStyle(
                          fontSize: 23.sp,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    CustomTextfield(
                        hintText: filteredCamp.location ?? 'Location',
                        icon: Icons.place_outlined,
                        onChanged: (value) =>
                            campaignProvider.setLocation(value),
                        keyboardType: TextInputType.streetAddress),
                    SizedBox(height: 2.h),
                    InkWell(
                      onTap: () => _pickDate(context),
                      child: CustomTextfield(
                          enabled: false,
                          hintText: formatDate(campaignProvider.selectedDate),
                          icon: Icons.date_range_outlined,
                          onChanged: (value) {},
                          keyboardType: TextInputType.none),
                    ),
                    SizedBox(height: 2.h),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        InkWell(
                          onTap: () => _pickTime(context, isStartTime: true),
                          child: CustomTextfield(
                            width: 40,
                            enabled: false,
                            hintText: formatTime(campaignProvider.startTime,
                                isStartTime: true),
                            icon: Icons.access_time_rounded,
                            onChanged: (value) {},
                            keyboardType: TextInputType.none,
                          ),
                        ),
                        SizedBox(width: 5.w),
                        InkWell(
                          onTap: () => _pickTime(context, isStartTime: false),
                          child: CustomTextfield(
                            width: 40,
                            enabled: false,
                            hintText: campaignProvider.endTime == null
                                ? formatTime(parseTime(filteredCamp.endTime),
                                    isStartTime: false)
                                : formatTime(campaignProvider.endTime,
                                    isStartTime: false),
                            icon: Icons.access_time_outlined,
                            onChanged: (value) {},
                            keyboardType: TextInputType.none,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 2.h),
                    CustomTextfield(
                        height: 7,
                        hintText: filteredCamp.description ?? 'Description',
                        icon: Icons.notes,
                        onChanged: (value) =>
                            campaignProvider.setDescription(value),
                        keyboardType: TextInputType.multiline),
                    SizedBox(height: 4.5.h),
                    CustomButton(
                      text: 'Submit',
                      isLoading: campaignProvider.isLoading,
                      onPressed: () =>
                          campaignProvider.editCamp(filteredCamp.id, context),
                      buttonType: ButtonType.Outlined,
                    ),
                    SizedBox(height: 2.h),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
