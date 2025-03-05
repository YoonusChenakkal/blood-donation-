import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class HospitalProfileProvider extends ChangeNotifier {
  String? name;
  String? email;
  String? phone;
  String? address;
  String? editedPhone;
  String? editedAddress;
  String? image;
  String? createdDate;
  String? pickedImageName;
  int? id;
  File? pickedImage;
  bool isLoading = false;
  bool isLoadingProfileImage = false;

  fetchHospitalProfile() async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    name = prefs.getString('hospitalName');
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(
            'https://lifeproject.pythonanywhere.com/hospital/hospital/?name=${name}'),
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data.isEmpty) return;
        address = data['address'];
        phone = data['contact_number'];
        email = data['email'];
        image = data['image'];
        createdDate = data['created_at'];
        id = data['id'];
        notifyListeners();
        print('image ;  $image ');
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

  pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      print('image Picked');
      pickedImage = File(pickedFile.path);
      pickedImageName = basename(pickedFile.path);
      notifyListeners();
    }
  }

  updateProfilePicture(
    File? profileImage,
  ) async {
    final url = Uri.parse(
        'https://lifeproject.pythonanywhere.com/hospital/hospital-details/$name/');
    isLoadingProfileImage = true;
    notifyListeners();

    try {
      // Create a multipart request
      var request = http.MultipartRequest('PATCH', url);

      // If there is an image, add it to the request
      if (profileImage != null) {
        print('Profile Picture Present $profileImage');
        var file =
            await http.MultipartFile.fromPath('image', profileImage.path);
        request.files.add(file);
      }

      var response = await request.send();
      final responseString = await response.stream.bytesToString();
      print(response.statusCode);
      print('Response  :  $responseString');

      // Check if the request was successful
      if (response.statusCode == 200) {
        profileImage = null;

        fetchHospitalProfile();

        return 'Profile Photo Updtaed successfully!';
      } else {
        // Handle different status codes
        final data = jsonDecode(responseString);

        String errorMessage = 'Failed to update profile Photo';
        if (response.statusCode == 404) {
          errorMessage = data['error'] ?? ' profile Photo not found.';
        } else if (response.statusCode == 400) {
          errorMessage =
              data['error'] ?? 'Bad request, please check your data.';
        } else if (response.statusCode == 500) {
          errorMessage = 'Server error, please try again later.';
        }

        return errorMessage;
      }
    } catch (e) {
      print("erroe: $e");

      return 'An error occurred while updating the profile!';
    } finally {
      isLoadingProfileImage = false;
      notifyListeners();
    }
  }

  updateProfileDetails(
    BuildContext ctx,
    String? address,
    String? phone,
  ) async {
    final url = Uri.parse(
        'https://lifeproject.pythonanywhere.com/hospital/hospital-details/$name/');

    isLoading = true;

    notifyListeners();

    try {
      // Create a multipart request
      var request = http.MultipartRequest('PATCH', url);

      // Add form fields
      if (editedPhone != null)
        request.fields['contact_number'] = editedPhone.toString();
      if (editedAddress != null) request.fields['address'] = editedAddress!;

      // Send the request
      var response = await request.send();
      final responseString = await response.stream.bytesToString();
      print(response.statusCode);
      print('Response  :  $responseString');

      // Check if the request was successful
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
          content: Text('Profile updated successfully!'),
          duration: Duration(seconds: 2),
        ));
        fetchHospitalProfile();
        Navigator.pop(ctx);
      } else {
        // Handle different status codes
        final data = jsonDecode(responseString);

        String errorMessage = 'Failed to update profile';
        if (response.statusCode == 404) {
          errorMessage = data['error'] ?? 'User profile not found.';
        } else if (response.statusCode == 400) {
          errorMessage =
              data['error'] ?? 'Bad request, please check your data.';
        } else if (response.statusCode == 500) {
          errorMessage = 'Server error, please try again later.';
        }

        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (e) {
      print("erroe: $e");
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text('An error occurred while updating the profile!'),
        duration: Duration(seconds: 2),
      ));
    } finally {
      isLoading = false;
      editedAddress = null;
      editedPhone = null;
      notifyListeners();
    }
  }
}
