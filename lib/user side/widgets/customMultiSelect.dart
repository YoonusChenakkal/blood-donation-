import 'package:Life_Connect/user side/Providers/userProfileProvider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sizer/sizer.dart';

class CustomMultiSelectDropdown extends StatelessWidget {
  final String title;
  final List<String> options;
  final List<String> selectedItems;
  final ValueChanged<List<String>> onChanged;

  const CustomMultiSelectDropdown({
    required this.title,
    required this.options,
    required this.selectedItems,
    required this.onChanged,
    Key? key,
  }) : super(key: key);

  // Toggle selection and update the parent widget
  void _toggleSelection(String item, List<String> selectedItems) {
    if (selectedItems.contains(item)) {
      selectedItems.remove(item);
    } else {
      selectedItems.add(item);
    }
    onChanged(selectedItems);
  }

  // Open dialog to select multiple items
  Future<void> _openSelectionDialog(BuildContext context) async {
    final selected = await showDialog<List<String>>(
      context: context,
      builder: (BuildContext context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Padding(
            padding: EdgeInsets.all(2.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Select Organs to Donate',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 1.h),
                StatefulBuilder(
                  builder: (BuildContext context, setState) {
                    return ListView(
                      shrinkWrap: true,
                      children: options.map((option) {
                        return CheckboxListTile(
                          activeColor: Colors.red,
                          title: Text(option),
                          value: selectedItems.contains(option),
                          onChanged: (bool? value) {
                            if (value != null) {
                              _toggleSelection(option, selectedItems);
                              setState(
                                  () {}); // Rebuild the dialog to reflect state change
                            }
                          },
                        );
                      }).toList(),
                    );
                  },
                ),
                SizedBox(height: 2.h),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context, selectedItems);
                      },
                      child: const Text(
                        'Done',
                        style: TextStyle(fontSize: 18, color: Colors.red),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (selected != null) {
      onChanged(selected);
    }
  }

  @override
  Widget build(BuildContext context) {
    final userProfileProvider = Provider.of<UserProfileProvider>(context);
    return Container(
      height: 6.h,
      width: 85.w,
      padding: EdgeInsets.symmetric(horizontal: 2.w),
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 231, 231),
        borderRadius: BorderRadius.circular(6),
      ),
      child: InkWell(
        onTap: () => _openSelectionDialog(context),
        child: Row(
          children: [
            Padding(
              padding: EdgeInsets.only(right: 4.w),
              child: const Icon(Icons.medical_services_outlined),
            ),
            Text(
              selectedItems.isEmpty
                  ? (userProfileProvider.organsToDonate.isEmpty
                      ? 'Select Organs'
                      : userProfileProvider.organsToDonate.join(', '))
                  : selectedItems.join(', '),
              style: const TextStyle(
                color: Color.fromARGB(255, 102, 102, 102),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
