import 'dart:convert';
import 'package:blood_donation/Providers/authProvider.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class AuthService {
  final String baseUrl = 'https://lifeproject.pythonanywhere.com/donor/';

  // Register user
  registerUser(
    String name,
    String email,
    String bloodGroup,
    AuthProvider authProvider,
  ) async {
    final url = Uri.parse('${baseUrl}register/');

    authProvider.isLoading = true; // Start loading state

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': name,
          'email': email,
          'blood_type': bloodGroup,
          'is_organ_donor': true,
          'is_blood_donor': true,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final message = data['message'];

        // Save uniqueId to SharedPreferences

        authProvider.uniqueId = data['unique_id']; // Update unique ID
        authProvider.showOtpField = true; // Show OTP field

        return message;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        String errorMessage = data['email']?.first ?? data['username']?.first;
        return errorMessage;
      } else {
        return 'Unexpected error occurred. Please try again.';
      }
    } catch (e) {
      authProvider.isLoading = false; // Stop loading state
      return 'Network error: Unable to connect to the server';
    } finally {
      authProvider.isLoading = false;
    }
  }

  // Verify registration OTP
  verifyRegisterOtp(
    String email,
    String otp,
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final url = Uri.parse('${baseUrl}verify-otp/');

    authProvider.isLoading = true; // Start loading state
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('uniqueId', authProvider.uniqueId!);

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/userProfile',
          (route) => false,
        );
        return message;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage =
            data['non_field_errors']?.first ?? 'Failed to verify OTP';
        return errorMessage;
      } else {
        return 'Unexpected error occurred. Please try again.';
      }
    } catch (e) {
      authProvider.isLoading = false; // Stop loading state

      return 'Network error: Unable to connect to the server';
    } finally {
      authProvider.isLoading = false;
    }
  }

  // Request login OTP
  requestLoginOtp(
    String email,
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final url = Uri.parse('${baseUrl}request-otp/');

    authProvider.isLoading = true; // Start loading state

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final message = data['message'];

        authProvider.showOtpField = true;
        return message;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage =
            data['email']?.first ?? 'Failed, use another Email';
        return errorMessage;
      } else {
        return 'Unexpected error occurred. Please try again.';
      }
    } catch (e) {
      authProvider.isLoading = false; // Stop loading state
      return 'Network error: Unable to connect to the server';
    } finally {
      authProvider.isLoading = false;
    }
  }

  // Verify login OTP
  verifyLoginOtp(
    String email,
    String otp,
    BuildContext context,
    AuthProvider authProvider,
  ) async {
    final url = Uri.parse('${baseUrl}login/');

    authProvider.isLoading = true;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final username = data['user'];

        final message = data['message'];

        final prefs = await SharedPreferences.getInstance();
        prefs.setString('username', username);

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/bottomNavigationBar',
          (route) => false,
        );
        return message;
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage = data['non_field_errors']?.first ??
            'Incorrect OTP. Please try again.';
        return errorMessage;
      } else {
        return 'Unexpected error occurred. Please try again.';
      }
    } catch (e) {
      authProvider.isLoading = false; // Stop loading state
      return 'Network error: Unable to connect to the server';
    } finally {
      authProvider.isLoading = false;
    }
  }
}
