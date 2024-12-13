import 'dart:convert';
import 'dart:io';

import 'package:blood_donation/Providers/authProvider.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';

class UserProfileProvider extends ChangeNotifier {
  String? _name;
  String? _address;
  String? _phone;
  String? _bloodGroup;
  File? _idProofImage;
  String? _imageName;

  // Getters
  String? get name => _name;
  String? get address => _address;
  String? get phone => _phone;
  String? get bloodGroup => _bloodGroup;
  String? get imageName => _imageName;
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

  registerUserPofile(BuildContext ctx, String? address, String? phone,
      File? idProofImage) async {
    final authProvider = Provider.of<AuthProvider>(ctx, listen: false);
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/user-profile/');

    authProvider.isLoading = true;
    notifyListeners();

    try {
      // Create a multipart request
      var request = http.MultipartRequest('POST', url);

      // Add form fields
      request.fields['user'] = authProvider.name ?? '';
      request.fields['contact_number'] = phone ?? '';
      request.fields['address'] = address ?? '';
      request.fields['blood_group'] = authProvider.bloodGroup ?? '';
      request.fields['willing_to_donate_organ'] = 'true';

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
        print(response.statusCode);
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
      print('Error: $e');
      ScaffoldMessenger.of(ctx).showSnackBar(const SnackBar(
        content: Text('An error occurred while uploading the profile!'),
        duration: Duration(seconds: 2),
      ));
    } finally {
      authProvider.isLoading = false;
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
}
