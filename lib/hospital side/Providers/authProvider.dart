import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HospitalAuthProvider with ChangeNotifier {
  String? _uniqueId;
  String? _name;
  String? _email;
  String? _phone;
  String? _address;
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
  String? get phone => _phone;
  String? get address => _address;
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

  set phone(String? value) {
    _phone = value;
    notifyListeners();
  }

  set address(String? value) {
    _address = value;
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

  reset() async {
    _uniqueId = null;
    _name = null;
    _email = null;
    _phone = null;
    _address = null;
    _otp = null;
    _isLoading = false;
    _showOtpField = false;
    _isResendEnabled = false;
    final prefs = await SharedPreferences.getInstance();
    prefs.remove('hospitalName');
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
}
