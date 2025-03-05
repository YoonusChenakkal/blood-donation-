import 'dart:convert';

import 'package:Life_Connect/hospital%20side/Providers/authProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/campaignProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/donorProvider.dart';
import 'package:Life_Connect/hospital%20side/Providers/profileProvider.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';

class HospitalAuthService {
  final String baseUrl = 'https://lifeproject.pythonanywhere.com/hospital/';

  // Register user
  registerUser(
    String name,
    String email,
    String phone,
    String address,
    BuildContext context,
    HospitalAuthProvider authProvider,
  ) async {
    print('hospital');
    final url = Uri.parse('${baseUrl}hospital-register/');

    authProvider.isLoading = true; // Start loading state

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'name': name,
          'email': email,
          'contact_number': phone,
          'address': address,
        }),
      );

      if (response.statusCode == 201) {
        final data = jsonDecode(response.body);
        final message = data['message'];

        authProvider.showOtpField = true; // Show OTP field

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(message)),
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        String errorMessage =
            data['email']?.first ?? data['contact_number']?.first;
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        _handleErrorResponse(response, context, authProvider);
      }
    } catch (e) {
      authProvider.isLoading = false; // Stop loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Network error: Unable to connect to the server.')),
      );
    } finally {
      authProvider.isLoading = false;
    }
  }

  // Verify registration OTP
  verifyRegisterOtp(
    String email,
    String otp,
    BuildContext context,
    HospitalAuthProvider authProvider,
  ) async {
    print('hospital verifyRegisterOtp');

    final url = Uri.parse('${baseUrl}hospital-verify-otp/');

    authProvider.isLoading = true; // Start loading state
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hospitalName = data['hospital'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('hospitalName', hospitalName);
        prefs.setString('user_type', 'hospital');

        final message = data['message'];

        Provider.of<HospitalCampaignProvider>(context, listen: false)
            .fetchCamps(context);
        Provider.of<HospitalDonorProvider>(context, listen: false).loadDonors();
        await Provider.of<HospitalProfileProvider>(context, listen: false)
            .fetchHospitalProfile();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/hospitalBottomBar',
          (route) => false,
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage =
            data['non_field_errors']?.first ?? 'Failed to verify OTP';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        _handleErrorResponse(response, context, authProvider);
      }
    } catch (e) {
      authProvider.isLoading = false; // Stop loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Network error: Unable to connect to the server.')),
      );
    } finally {
      authProvider.isLoading = false;
    }
  }

  // Request login OTP
  requestLoginOtp(
    String email,
    BuildContext context,
    HospitalAuthProvider authProvider,
  ) async {
    print('Hospital requestLoginOtp');
    final url = Uri.parse('${baseUrl}hospital-request-otp/');

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
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage =
            data['email']?.first ?? 'Failed, use another Email';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        _handleErrorResponse(response, context, authProvider);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Network error: Unable to connect to the server.')),
      );
    } finally {
      authProvider.isLoading = false;
    }
  }

  // Verify login OTP
  verifyLoginOtp(
    String email,
    String otp,
    BuildContext context,
    HospitalAuthProvider authProvider,
  ) async {
    print('Hospital Verify LoginOtp');

    final url = Uri.parse('${baseUrl}hospital-login/');

    authProvider.isLoading = true;

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'otp': otp}),
      );
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final hospitalName = data['hospital'];
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('hospitalName', hospitalName);
        prefs.setString('user_type', 'hospital');

        final message = data['message'];
        Provider.of<HospitalCampaignProvider>(context, listen: false)
            .fetchCamps(context);
        Provider.of<HospitalDonorProvider>(context, listen: false).loadDonors();
        await Provider.of<HospitalProfileProvider>(context, listen: false)
            .fetchHospitalProfile();

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(message),
          duration: const Duration(seconds: 2),
        ));

        Navigator.pushNamedAndRemoveUntil(
          context,
          '/hospitalBottomBar',
          (route) => false,
        );
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        final errorMessage = data['non_field_errors']?.first ??
            'Incorrect OTP. Please try again.';
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(errorMessage),
          duration: const Duration(seconds: 2),
        ));
      } else {
        _handleErrorResponse(response, context, authProvider);
      }
    } catch (e) {
      authProvider.isLoading = false; // Stop loading state
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
            content: Text('Network error: Unable to connect to the server.')),
      );
    } finally {
      authProvider.isLoading = false;
    }
  }

  // Handle error response and update UI state
  void _handleErrorResponse(http.Response response, BuildContext context,
      HospitalAuthProvider authProvider) {
    const errorMessage = 'Unexpected error occurred. Please try again.';
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text(errorMessage)),
    );
  }
}
