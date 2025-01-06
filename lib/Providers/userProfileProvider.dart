import 'dart:convert';
import 'dart:ffi';
import 'dart:io';

import 'package:blood_donation/Providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProfileProvider extends ChangeNotifier {
  String? _name;
  String? _address;
  String? _phone;
  String? _bloodGroup;
  String? _imageName;
  bool _isChecked = false;
  bool isLoading = false;
  File? _idProofImage;
  Map<String, dynamic> profileData = {};

  // Getters
  String? get name => _name;
  String? get address => _address;
  String? get phone => _phone;
  String? get bloodGroup => _bloodGroup;
  String? get imageName => _imageName;
  bool get isChecked => _isChecked;
  File? get idProofImage => _idProofImage;

  // Setters
  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  set address(String? value) {
    _address = value;
    notifyListeners();
  }

  set phone(String? value) {
    _phone = value;
    notifyListeners();
  }

  set bloodGroup(String? value) {
    _bloodGroup = value;
    notifyListeners();
  }

  set idProofImage(File? value) {
    _idProofImage = value;
    notifyListeners();
  }

  set isChecked(bool value) {
    _isChecked = value;
    notifyListeners();
  }

  fetchUserProfile() async {
    isLoading = true;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    print("Username: $username");

    try {
      final response = await http.get(
        Uri.parse(
            'https://lifeproject.pythonanywhere.com/donor/profiles/?user=${username}'),
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body); // Decode as a List
        print("Response Data: $data");

        // Access the first element in the list since the response is an array
        profileData = {
          'id': data[0]['id'] ?? 0, // Ensure id is an integer
          'unique_id': data[0]['unique_id'] ?? '',
          'name': data[0]['user'] ?? '',
          'email': data[0]['email'] ?? '',
          'address': data[0]['address'] ?? '',
          'phone':
              data[0]['contact_number']?.toString() ?? '', // Convert to string
          'bloodGroup': data[0]['blood_group'] ?? '',
          'donateOrgan':
              data[0]['willing_to_donate_organ'] ?? false, // Keep as bool
          'donateBlood':
              data[0]['willing_to_donate_blood'] ?? false, // Keep as bool
        };

        notifyListeners();
      } else {
        throw Exception(
            'Failed to load profile. Server returned ${response.statusCode}');
      }
    } catch (error) {
      print("Error: $error");
      throw Exception('Failed to fetch profile: ${error.toString()}');
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  registerUserPofile(BuildContext ctx, String? address, String? phone,
      File? idProofImage) async {
    final authProvider = Provider.of<AuthProvider>(ctx, listen: false);
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/user-profile/');

    isLoading = true;
    notifyListeners();

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add form fields
      request.fields['user'] = authProvider.name ?? '';
      request.fields['contact_number'] = phone ?? '';
      request.fields['address'] = address ?? '';
      request.fields['blood_group'] = authProvider.bloodGroup ?? '';
      request.fields['willing_to_donate_organ'] = _isChecked ? 'true' : 'false';

      // If there is an image, add it to the request
      if (idProofImage != null) {
        var file =
            await http.MultipartFile.fromPath('id_proof', idProofImage.path);
        request.files.add(file);
      }

      // Send the request
      var response = await request.send();
      final responseString = await response.stream.bytesToString();
      // Check if the request was successful
      if (response.statusCode == 201) {
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('username', authProvider.name!);
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully!'),
          duration: Duration(seconds: 2),
        ));
        Navigator.pushNamedAndRemoveUntil(
          ctx,
          '/bottomNavigationBar',
          (route) => false,
        );
      } else {
        // Handle different status codes
        final Map<String, dynamic> data = jsonDecode(responseString);

        // Check if there is an error in the response body
        String errorMessage = 'Failed to update profile';

        if (response.statusCode == 404) {
          // If it's a 404 error (user not found)
          errorMessage = data['error'] ?? 'User profile not found.';

          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 2),
          ));
        } else if (response.statusCode == 400) {
          // If it's a 400 error (bad request)
          errorMessage =
              data['error'] ?? 'Bad request, please check your data.';
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 2),
          ));
        } else if (response.statusCode == 500) {
          // If it's a 500 error (server issue)
          errorMessage = 'Server error, please try again later.';
          ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
            content: Text(errorMessage),
            duration: Duration(seconds: 2),
          ));
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text('An error occurred while uploading the profile!'),
        duration: Duration(seconds: 2),
      ));
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  pickIdProofImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _idProofImage = File(pickedFile.path);
      _imageName = basename(pickedFile.path);
      notifyListeners();
    }
  }

  reset() {
    address = null;
    idProofImage = null;
    phone = null;
  }
}
