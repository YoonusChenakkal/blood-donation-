import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthProvider with ChangeNotifier {
  String? _uniqueId;
  String? _name;
  String? _email;
  String? _bloodGroup;
  String? _otp;
  bool _isLoading = false;
  bool _showOtpField = false;

  // Getters and Setters
  String? get uniqueId => _uniqueId;
  String? get name => _name;
  String? get email => _email;
  String? get bloodGroup => _bloodGroup;
  String? get otp => _otp;
  bool get isLoading => _isLoading;
  bool get showOtpField => _showOtpField;

  set name(String? value) {
    _name = value;
    notifyListeners();
  }

  set email(String? value) {
    _email = value;
    notifyListeners();
  }

  set bloodGroup(String? value) {
    _bloodGroup = value;
    notifyListeners();
  }

  set otp(String? value) {
    _otp = value;
    notifyListeners();
  }

  set showOtpField(bool value) {
    _showOtpField = value;
    notifyListeners();
  }

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

 

  // Request OTP for Register
  register(
      String name, String email, String bloodGroup, BuildContext ctx) async {
    _isLoading = true;
    notifyListeners();
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/register/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'email': email,
          'blood_type': bloodGroup,
          'is_organ_donor': true,
          'is_blood_donor': true
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final message = data['message'];
        _uniqueId = data['unique_id'];
        _showOtpField = true;

        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));

        // Save uniqueId to SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('uniqueId', _uniqueId!);
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        String errorMessage = data['email']?.first ?? data['username']?.first;
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        // Handling unknown error codes (e.g., 500 server error)
        final errorMessage = 'Unexpected error occurred. Please try again.';
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Network error: Unable to connect to the server.'),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  //verify Otp for Registering User

  verifyRegisterOtp(String otp, BuildContext ctx) async {
    _isLoading = true;
    notifyListeners();
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/verify-otp/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'];
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));
        Navigator.pushReplacementNamed(ctx, '/userProfile');
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage =
            data['non_field_errors']?.first ?? 'Failed to verify OTP';
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        final errorMessage = 'Unexpected error occurred. Please try again.';
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Network error: Unable to connect to the server.'),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  loginOtpRequest(String email, BuildContext ctx) async {
    _isLoading = true;
    notifyListeners();
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/request-otp/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'email': email,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'];

        _showOtpField = true;
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage =
            data['email']?.first ?? 'Failed, use another Email';
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        // Handling other errors like server errors
        final errorMessage = 'Unexpected error occurred. Please try again.';
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Network error: Unable to connect to the server.'),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // verify Otp of Login
  verifyLoginOtp(String email, String otp, BuildContext ctx) async {
    _isLoading = true;
    notifyListeners();
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/login/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'];

        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));

        Navigator.pushNamedAndRemoveUntil(
          ctx,
          '/home',
          (route) => false,
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage = data['non_field_errors']?.first ??
            'Incorrect OTP. Please try again.';
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        final errorMessage = 'Unexpected error occurred. Please try again.';
        ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      }
    } catch (e) {
      ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
        content: Text('Network error: Unable to connect to the server.'),
        duration: const Duration(seconds: 2),
      ));
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
