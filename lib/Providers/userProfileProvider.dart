import 'dart:convert';
import 'dart:io';

import 'package:Life_Connect/Providers/authProvider.dart';
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
  String? _idProofimageName;
  String? _profileImageName;
  String? editedAddress;
  String? editedPhone;
  String? _editedBloodGroup;
  bool _isBloodChecked = false;
  bool isBloodCheckedEdited = false;
  bool _isOrganChecked = false;
  bool isOrganCheckedEdited = false;
  bool isLoadingProfileImage = false;
  bool isLoading = false;
  File? _idProofImage;
  File? _profileImage;
  Map<String, dynamic> profileData = {};
  List<String> organsToDonate = [];
  List<String> editedOrgansToDonate = [];

  // Getters
  String? get name => _name;
  String? get address => _address;
  String? get phone => _phone;
  String? get bloodGroup => _bloodGroup;
  String? get imageName => _idProofimageName;
  String? get profileImageName => _profileImageName;

  String? get editedBloodGroup => _editedBloodGroup;

  bool get isBloodChecked => _isBloodChecked;
  bool get isOrganChecked => _isOrganChecked;

  File? get idProofImage => _idProofImage;
  File? get profileImage => _profileImage;

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

  set editedBloodGroup(String? value) {
    _editedBloodGroup = value;
    notifyListeners();
  }

  set idProofImage(File? value) {
    _idProofImage = value;
    notifyListeners();
  }

  set profileImage(File? value) {
    _profileImage = value;
    notifyListeners();
  }

  set isBloodChecked(bool value) {
    _isBloodChecked = value;
    notifyListeners();
  }

  set isOrganChecked(bool value) {
    _isOrganChecked = value;
    notifyListeners();
  }

  updateOrgansToDonate(List<String> selectedOrgans) {
    organsToDonate = selectedOrgans;
    notifyListeners(); // Notify listeners to rebuild UI when this changes
  }

  updateEditedOrgansToDonate(List<String> selectedOrgans) {
    editedOrgansToDonate = selectedOrgans;
    notifyListeners(); // Notify listeners to rebuild UI when this changes
  }

  reset() {
    address = null;
    idProofImage = null;
    phone = null;
  }

  resetEdited() {
    editedAddress = null;
    editedPhone = null;
    editedBloodGroup = null;
  }

  fetchUserProfile() async {
    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    final _name = prefs.getString('username');

    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            'https://lifeproject.pythonanywhere.com/donor/profiles/?user=${_name}'),
      );
      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final List<dynamic> data =
            jsonDecode(response.body); // Decode as a List
        // print("Response Data: $data");
        if (data.isEmpty) return;
        profileData = {
          'id': data[0]['id'] ?? 0, // Ensure id is an integer
          'unique_id': data[0]['unique_id'] ?? '',
          'name': data[0]['user'] ?? '',
          'email': data[0]['email'] ?? '',
          'address': data[0]['address'] ?? '',
          'phone':
              data[0]['contact_number']?.toString() ?? '', // Convert to string
          'bloodGroup': data[0]['blood_group'] ?? '',
          'profileImage': data[0]['profile_image'] ?? '',
          'donateOrgan': organsToDonate =
              List<String>.from(data[0]['organs_to_donate'] ?? []),
          'willingDonateOrgan':
              data[0]['willing_to_donate_organ'] ?? false, // Keep as bool

          'willingDonateBlood':
              data[0]['willing_to_donate_blood'] ?? false, // Keep as bool
        };
        name = profileData['name'];
        address = profileData['address'];
        phone = profileData['phone'];
        bloodGroup = profileData['bloodGroup'];
        isBloodChecked = profileData['willingDonateBlood'];
        isOrganChecked = profileData['willingDonateOrgan'];
        organsToDonate = profileData['donateOrgan'];
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
      File? idProofImage, List<String>? organsToDonate) async {
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
      request.fields['willing_to_donate_organ'] =
          _isOrganChecked ? 'true' : 'false';
      request.fields['willing_to_donate_blood'] =
          _isBloodChecked ? 'true' : 'false';

      // Add organs_to_donate field as a JSON array
      if (organsToDonate != null && organsToDonate.isNotEmpty) {
        request.fields['organs_to_donate'] = jsonEncode(organsToDonate);
      }

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
        idProofImage = null;
        await fetchUserProfile();
        Navigator.pushNamedAndRemoveUntil(
          ctx,
          '/bottomNavigationBar',
          (route) => false,
        );
      } else {
        // Handle different status codes
        final Map<String, dynamic> data = jsonDecode(responseString);
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
      _idProofimageName = basename(pickedFile.path);
      notifyListeners();
    }
  }

  pickProfileImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      _profileImage = File(pickedFile.path);
      _idProofimageName = basename(pickedFile.path);
      notifyListeners();
    }
  }

  updateProfilePicture(
    int? id,
    File? profileImage,
  ) async {
    final url = Uri.parse(
        'https://lifeproject.pythonanywhere.com/donor/user-profile/$id/');
    isLoadingProfileImage = true;
    notifyListeners();
    try {
      // Create a multipart request
      var request = http.MultipartRequest('PATCH', url);

      // If there is an image, add it to the request
      if (profileImage != null) {
        print('Profike Picture Present $profileImage');
        var file = await http.MultipartFile.fromPath(
            'profile_image', profileImage.path);
        request.files.add(file);
      }

      var response = await request.send();
      final responseString = await response.stream.bytesToString();
      print(response.statusCode);
      print('Response  :  $responseString');

      // Check if the request was successful
      if (response.statusCode == 200) {
        profileImage = null;

        fetchUserProfile();

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

  updateUserProfile(
      BuildContext ctx,
      int? id,
      String? address,
      String? phone,
      File? idProofImage,
      String? bloodGroup,
      List<String> organsToDonate,
      bool isBloodChecked,
      bool isOrganChecked) async {
    final url = Uri.parse(
        'https://lifeproject.pythonanywhere.com/donor/user-profile/$id/');

    isLoading = true;
    final prefs = await SharedPreferences.getInstance();
    final name = prefs.getString('username');

    notifyListeners();

    try {
      // Create a multipart request
      var request = http.MultipartRequest('PATCH', url);

      // Add form fields
      request.fields['user'] = name ?? '';
      if (phone != null) request.fields['contact_number'] = phone.toString();
      if (address != null) request.fields['address'] = address;
      if (bloodGroup != null) request.fields['blood_group'] = bloodGroup;
      if (organsToDonate.isNotEmpty) {
        request.fields['organs_to_donate'] = jsonEncode(organsToDonate);
      }
      request.fields['willing_to_donate_blood'] =
          isBloodChecked ? 'true' : 'false';
      request.fields['willing_to_donate_organ'] =
          isOrganChecked ? 'true' : 'false';
      print('id: $id');
      print(name);
      print('addrss $address');
      print("phone :$phone");
      print('Willing to BLood : $isBloodChecked');
      print('wiilimg to Organ:  $isOrganChecked');
      print('Blood Group :$bloodGroup');

      // If there is an image, add it to the request
      if (idProofImage != null) {
        print('id Proof Present ');
        var file =
            await http.MultipartFile.fromPath('id_proof', idProofImage.path);
        request.files.add(file);
      }

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
        fetchUserProfile();
        resetEdited();
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
      notifyListeners();
    }
  }
}
