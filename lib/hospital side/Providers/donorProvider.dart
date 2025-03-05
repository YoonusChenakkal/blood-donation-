import 'dart:convert';
import 'package:Life_Connect/hospital%20side/Models/donorModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class HospitalDonorProvider extends ChangeNotifier {
  List<DonorModel> donors = [];
  List<DonorModel> filteredDonors = [];
  bool _isLoading = false;
  String? errorMessage;

  bool get isLoading => _isLoading; // Getter for _isLoading

  // Fetch donors from the API
  Future<void> loadDonors() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://lifeproject.pythonanywhere.com/hospital/donors/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        donors = List<DonorModel>.from(data.map((x) => DonorModel.fromJson(x)));
        filteredDonors = List.from(donors); // Initialize filtered donors
      } else {
        throw Exception(
            'Failed to load donors. Server returned ${response.statusCode}');
      }
    } catch (error) {
      errorMessage = 'Failed to fetch donors: ${error.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Search donors by query
  void searchDonors(String query) {
    if (query.isEmpty) {
      filteredDonors =
          List.from(donors); // Show all donors if the query is empty
    } else {
      filteredDonors = donors.where((donor) {
        final lowerQuery = query.toLowerCase();
        return donor.user.toLowerCase().contains(lowerQuery) || // Match name
            donor.bloodGroup
                .toLowerCase()
                .contains(lowerQuery) || // Match blood group
            donor.address.toLowerCase().contains(lowerQuery); // Match address
      }).toList();
    }
    notifyListeners();
  }

  // Filter donors by blood group
  void filterByBloodGroup(String group) {
    if (group == 'All') {
      filteredDonors =
          List.from(donors); // Show all donors if "All" is selected
    } else {
      filteredDonors = donors.where((donor) {
        return donor.bloodGroup.toLowerCase() == group.toLowerCase();
      }).toList();
    }
    notifyListeners();
  }
}
