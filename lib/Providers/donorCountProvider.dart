import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class DonorCountProvider extends ChangeNotifier {
  bool _isLoading = false;
  String? errorMessage;
  String? donorCount;

  Future<void> loadDonorCount() async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://lifeproject.pythonanywhere.com/hospital/donors/'),
      );

      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body); // Parse as a list
        donorCount =
            data.length.toString(); // Count the number of items in the list
        notifyListeners();
        print(donorCount);
      } else {
        print(response.statusCode);

        throw Exception(
            'Failed to load donor count. Server returned ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      errorMessage = 'Failed to fetch donor count: ${error.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
