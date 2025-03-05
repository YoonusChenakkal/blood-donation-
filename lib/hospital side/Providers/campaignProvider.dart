import 'dart:convert';
import 'dart:io';
import 'package:Life_Connect/hospital%20side/Models/campRegistrationsModel.dart';
import 'package:Life_Connect/hospital%20side/Models/campsModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HospitalCampaignProvider with ChangeNotifier {
  String? location;
  String? description;
  DateTime? selectedDate;
  TimeOfDay? startTime;
  TimeOfDay? endTime;
  List<CampsModel> camp = [];
  List<CampsModel> filteredCamps = [];
  List<CampRegistrationsModel> campRegistrations = [];
  String? errorMessage;

  bool isLoading = false;

  void setLocation(String value) {
    location = value;
    notifyListeners();
  }

  void setDescription(String value) {
    description = value;
    notifyListeners();
  }

  void setDate(DateTime value) {
    selectedDate = value;
    notifyListeners();
  }

  void setStartTime(TimeOfDay value) {
    startTime = value;
    notifyListeners();
  }

  void setEndTime(TimeOfDay value) {
    endTime = value;
    notifyListeners();
  }

  bool isFormValid() {
    return location != null &&
        location!.isNotEmpty &&
        description != null &&
        description!.isNotEmpty &&
        selectedDate != null &&
        startTime != null &&
        endTime != null;
  }

  void clearForm() {
    location = null;
    description = null;
    selectedDate = null;
    startTime = null;
    endTime = null;
    notifyListeners();
  }

  Future<void> registerCampaign(
    BuildContext context,
  ) async {
    final url = Uri.parse(
        'https://lifeproject.pythonanywhere.com/hospital/hospital/blood-donation-camps/');

    isLoading = true;
    notifyListeners();
    try {
      // Format date as "yyyy-MM-dd"
      final formattedDate = selectedDate != null
          ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
          : '';

      // Format time as "HH:mm:ss.SSSSSS"
      String formatTimeOfDay(TimeOfDay? time) {
        if (time == null) return '';
        final now = DateTime.now();
        final dateTime =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00.000000';
      }

      final formattedStartTime = formatTimeOfDay(startTime);
      final formattedEndTime = formatTimeOfDay(endTime);

      final prefs = await SharedPreferences.getInstance();
      String? hospitalName = prefs.getString('hospitalName');

      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'hospital': hospitalName ?? '',
          'date': formattedDate,
          'location': location ?? '',
          'start_time': formattedStartTime,
          'end_time': formattedEndTime,
          'description': description ?? '',
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(data['message'] ?? 'Campaign registered successfully!'),
          duration: const Duration(seconds: 2),
        ));

        fetchCamps(context);
        clearForm();
        Navigator.pop(context);
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        String errorMessage = data['detail'] ??
            (data['date'] is List ? data['date'].join(', ') : 'Invalid data');
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        throw Exception(
            'Unexpected error occurred. Status: ${response.statusCode}');
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  fetchCamps(BuildContext context) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            'https://lifeproject.pythonanywhere.com/hospital/hospital/blood-donation-camps/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        camp.clear(); // Clear the existing camps
        final prefs = await SharedPreferences.getInstance();
        String? hospitalName = prefs.getString('hospitalName');
        camp = List<CampsModel>.from(data.map((x) => CampsModel.fromJson(x)));
        filteredCamps =
            camp.where((camp) => camp.hospital == hospitalName).toList();
      } else {
        errorMessage =
            'Failed to load camps. Server returned ${response.statusCode}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage!),
          duration: const Duration(seconds: 2),
        ));
      }
    } on SocketException {
      errorMessage = 'No Internet connection. Please try again later.';
    } catch (error) {
      errorMessage = 'Failed to fetch camps: ${error.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  fetchRegistrations(
    int? campId,
    BuildContext context,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            'https://lifeproject.pythonanywhere.com/hospital/camps/${campId}/donors/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        campRegistrations.clear(); // Clear the existing camps

        final parsedCampRegistration = CampRegistrationsModel.fromJson(data);

        campRegistrations.add(parsedCampRegistration);
      } else {
        errorMessage =
            'Failed to load camps. Server returned ${response.statusCode}';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage!),
          duration: const Duration(seconds: 2),
        ));
      }
    } on SocketException {
      errorMessage = 'No Internet connection. Please try again later.';
    } catch (error) {
      errorMessage = 'Failed to fetch camps: ${error.toString()}';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  deleteCamp(
    int? campId,
    BuildContext context,
  ) async {
    isLoading = true;
    errorMessage = null;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    String? hospitalName = prefs.getString('hospitalName');

    try {
      final response = await http.delete(
        Uri.parse(
            'https://lifeproject.pythonanywhere.com/hospital/hospital/blood-donation-camps/$hospitalName/$campId/'),
      );

      if (response.statusCode == 204) {
        fetchCamps(context);
        Navigator.pop(context);
      } else {
        errorMessage = 'Failed to Delete ${response.statusCode}';
      }
    } on SocketException {
      errorMessage = 'No Internet connection. Please try again later.';
    } catch (error) {
      errorMessage = 'Failed to Delete: ${error.toString()}';
    } finally {
      isLoading = false;

      notifyListeners();
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(errorMessage!),
        duration: const Duration(seconds: 2),
      ));
      errorMessage = null;
    }
  }
 
  editCamp(
    int? campId,
    BuildContext context,
  ) async {
    isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    String? hospitalName = prefs.getString('hospitalName');

    final url = Uri.parse(
        'https://lifeproject.pythonanywhere.com/hospital/hospital/blood-donation-camps/$hospitalName/$campId/');
    isLoading = true;
    try {
      // Format date as "yyyy-MM-dd"
      final formattedDate = selectedDate != null
          ? '${selectedDate!.year}-${selectedDate!.month.toString().padLeft(2, '0')}-${selectedDate!.day.toString().padLeft(2, '0')}'
          : '';

      // Format time as "HH:mm:ss.SSSSSS"
      String formatTimeOfDay(TimeOfDay? time) {
        if (time == null) return '';
        final now = DateTime.now();
        final dateTime =
            DateTime(now.year, now.month, now.day, time.hour, time.minute);
        return '${dateTime.hour.toString().padLeft(2, '0')}:${dateTime.minute.toString().padLeft(2, '0')}:00.000000';
      }

      final formattedStartTime = formatTimeOfDay(startTime);
      final formattedEndTime = formatTimeOfDay(endTime);

      final response = await http.patch(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          if (formattedDate.isNotEmpty) 'date': formattedDate,
          if (location != null) 'location': location,
          if (formattedStartTime.isNotEmpty) 'start_time': formattedStartTime,
          if (formattedEndTime.isNotEmpty) 'end_time': formattedEndTime,
          if (description != null) 'description': description,
        }),
      );

      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Camp Updated successfully!'),
          duration: Duration(seconds: 2),
        ));

        fetchCamps(context);
        clearForm();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/hospitalBottomBar',
          (route) => false,
        );
      } else {
        String errorMessage = 'Camp Does Not Exist';

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(e.toString()),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}
