import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:Life_Connect/Models/campModel.dart';
import 'package:flutter/material.dart';

class Campsprovider extends ChangeNotifier {
  List<CampsModel> camp = [];
  bool _isLoading = false;
  String? errorMessage;
  Map<int, bool> _registrationStatus =
      {}; // Track registration status by camp id

  bool get isLoading => _isLoading;

  // Check registration status for a specific camp
  bool isRegisteredForCamp(int? campId) {
    return _registrationStatus[campId] ?? false;
  }

  // Fetch camps and notify listeners
  fetchCamps(BuildContext context) async {
    _isLoading = true;
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
        camp = List<CampsModel>.from(data.map((x) => CampsModel.fromJson(x)));
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
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<String?> registerInCamp(
      String user, int campId) async {
    final url = Uri.parse(
        'https://lifeproject.pythonanywhere.com/donor/register-camp/');

   _isLoading = true;
    notifyListeners();

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'user': user, 'camp': campId}),
      );

      if (response.statusCode == 201) {
        _registrationStatus[campId] = true; // Update the registration status
        return 'Registration Complete';
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        _registrationStatus[campId] = true; // Mark as registered
        return data['error'] ??
            'You have already Registered or This Camp is Invalid';
      } else {
        return 'Unexpected error occurred. Please try again.';
      }
    } catch (e) {
      return 'Failed to Register: ${e.toString()}';
    } finally {
    _isLoading = false;
      notifyListeners();
    }
  }
}
