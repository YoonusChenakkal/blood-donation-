import 'dart:convert';
import 'package:blood_donation/Models/hospitalModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HospitalProvider extends ChangeNotifier {
  List<HospitalModel> hospitals = [];
  List<HospitalModel> filteredhospitals = [];
  bool _isLoading = false;
  String? errorMessage;

  bool get isLoading => _isLoading; // Getter for _isLoading

  // Fetch hospitals from the API
  Future<void> fetchHospitals() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://lifeproject.pythonanywhere.com/hospital/hospitals/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        hospitals = List<HospitalModel>.from(
            data.map((x) => HospitalModel.fromJson(x)));
        filteredhospitals =
            List.from(hospitals); // Initialize filtered hospitals
      } else {
        throw Exception(
            'Failed to load hospitals. Server returned ${response.statusCode}');
      }
    } catch (error) {
      errorMessage = 'Failed to fetch hospitals: ${error.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search hospitals by query
  void searchhospitals(String query) {
    if (query.isEmpty) {
      filteredhospitals =
          List.from(hospitals); // Show all hospitals if the query is empty
    } else {
      filteredhospitals = hospitals.where((hospital) {
        final lowerQuery = query.toLowerCase();
        return hospital.name
            .toLowerCase()
            .contains(lowerQuery); // Match address
      }).toList();
    }
    notifyListeners();
  }
}
