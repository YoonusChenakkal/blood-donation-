import 'dart:async';
import 'package:flutter/material.dart';

class AuthProvider with ChangeNotifier {
  String? _uniqueId;
  String? _name;
  String? _email;
  String? _bloodGroup;
  String? _otp;
  bool _isLoading = false;
  bool _showOtpField = false;
  bool _isResendEnabled = false; // Tracks if the resend OTP button is enabled
  int _timeLeft = 60; // Time left for the countdown timer
  Timer? _timer;

  // Getters and Setters
  String? get uniqueId => _uniqueId;
  String? get name => _name;
  String? get email => _email;
  String? get bloodGroup => _bloodGroup;
  String? get otp => _otp;
  bool get isLoading => _isLoading;
  bool get showOtpField => _showOtpField;
  bool get isResendEnabled => _isResendEnabled;
  int get timeLeft => _timeLeft;

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

  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  set uniqueId(String? value) {
    _uniqueId = value;
    notifyListeners();
  }

  set showOtpField(bool value) {
    _showOtpField = value;
    if (_showOtpField) {
      // Start timer when OTP field is shown
      startTimer();
    } else {
      stopTimer();
    }

    notifyListeners();
  }

  set isResendEnabled(bool value) {
    _isResendEnabled = value;
    notifyListeners();
  }

  reset() {
    _showOtpField = false;
    _isLoading = false;
    _uniqueId = null;
    notifyListeners();
  }

  startTimer() {
    _timeLeft = 60; // Reset the timer to 60 seconds
    _isResendEnabled = false; // Disable resend initially
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_timeLeft > 0) {
        _timeLeft--;
      } else {
        stopTimer();
        _isResendEnabled = true; // Enable resend after 60 seconds
      }
      notifyListeners();
    });
  }

  void stopTimer() {
    _timer?.cancel();
    _timeLeft = 60;
    notifyListeners();
  }

  // // Request OTP for Register
  // register(
  //     String name, String email, String bloodGroup, BuildContext ctx) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final url =
  //       Uri.parse('https://lifeproject.pythonanywhere.com/donor/register/');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'username': name,
  //         'email': email,
  //         'blood_type': bloodGroup,
  //         'is_organ_donor': true,
  //         'is_blood_donor': true
  //       }),
  //     );

  //     if (response.statusCode == 201) {
  //       final data = jsonDecode(response.body);
  //       final message = data['message'];
  //       _uniqueId = data['unique_id'];
  //       _showOtpField = true;

  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(message),
  //         duration: const Duration(seconds: 2),
  //       ));

  //       // Save uniqueId to SharedPreferences
  //       final prefs = await SharedPreferences.getInstance();
  //       prefs.setString('uniqueId', _uniqueId!);
  //     } else if (response.statusCode == 400) {
  //       final data = jsonDecode(response.body);
  //       String errorMessage = data['email']?.first ?? data['username']?.first;
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     } else {
  //       // Handling unknown error codes (e.g., 500 server error)
  //       final errorMessage = 'Unexpected error occurred. Please try again.';
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //       content: Text('Network error: Unable to connect to the server.'),
  //       duration: const Duration(seconds: 2),
  //     ));
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // //verify Otp for Registering User

  // verifyRegisterOtp(String otp, BuildContext ctx) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final url =
  //       Uri.parse('https://lifeproject.pythonanywhere.com/donor/verify-otp/');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'email': email, 'otp': otp}),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final message = data['message'];
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(message),
  //         duration: const Duration(seconds: 2),
  //       ));
  //       Navigator.pushReplacementNamed(ctx, '/userProfile');
  //     } else if (response.statusCode == 400) {
  //       final data = jsonDecode(response.body);
  //       final errorMessage =
  //           data['non_field_errors']?.first ?? 'Failed to verify OTP';
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     } else {
  //       final errorMessage = 'Unexpected error occurred. Please try again.';
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //       content: Text('Network error: Unable to connect to the server.'),
  //       duration: const Duration(seconds: 2),
  //     ));
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // loginOtpRequest(String email, BuildContext ctx) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final url =
  //       Uri.parse('https://lifeproject.pythonanywhere.com/donor/request-otp/');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({
  //         'email': email,
  //       }),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final message = data['message'];

  //       _showOtpField = true;
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(message),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     } else if (response.statusCode == 400) {
  //       final data = jsonDecode(response.body);
  //       final errorMessage =
  //           data['email']?.first ?? 'Failed, use another Email';
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     } else {
  //       // Handling other errors like server errors
  //       final errorMessage = 'Unexpected error occurred. Please try again.';
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //       content: Text('Network error: Unable to connect to the server.'),
  //       duration: const Duration(seconds: 2),
  //     ));
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }

  // // verify Otp of Login
  // verifyLoginOtp(String email, String otp, BuildContext ctx) async {
  //   _isLoading = true;
  //   notifyListeners();
  //   final url =
  //       Uri.parse('https://lifeproject.pythonanywhere.com/donor/login/');

  //   try {
  //     final response = await http.post(
  //       url,
  //       headers: {'Content-Type': 'application/json'},
  //       body: jsonEncode({'email': email, 'otp': otp}),
  //     );

  //     if (response.statusCode == 200) {
  //       final data = jsonDecode(response.body);
  //       final message = data['message'];

  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(message),
  //         duration: const Duration(seconds: 2),
  //       ));

  //       Navigator.pushNamedAndRemoveUntil(
  //         ctx,
  //         '/bottomNavigationBar',
  //         (route) => false,
  //       );
  //     } else if (response.statusCode == 400) {
  //       final data = jsonDecode(response.body);
  //       final errorMessage = data['non_field_errors']?.first ??
  //           'Incorrect OTP. Please try again.';
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     } else {
  //       final errorMessage = 'Unexpected error occurred. Please try again.';
  //       ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //         content: Text(errorMessage),
  //         duration: const Duration(seconds: 2),
  //       ));
  //     }
  //   } catch (e) {
  //     ScaffoldMessenger.of(ctx).showSnackBar(SnackBar(
  //       content: Text('Network error: Unable to connect to the server.'),
  //       duration: const Duration(seconds: 2),
  //     ));
  //   } finally {
  //     _isLoading = false;
  //     notifyListeners();
  //   }
  // }
}
