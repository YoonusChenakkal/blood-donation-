import 'dart:convert';
import 'package:Life_Connect/hospital%20side/Models/chatModel.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HospitalChatsProvider extends ChangeNotifier {
  List<ChatModel> chats = [];
  bool _isLoading = false;
  String? errorMessage;

  bool get isLoading => _isLoading; // Getter for _isLoading

  // Fetch chats from the API
  fetchChats(String? donorName) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse(
            'https://lifeproject.pythonanywhere.com/donor/donor/chats/?username=${donorName}'),
      );
      print(response.body);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        chats = List<ChatModel>.from(data.map((x) => ChatModel.fromJson(x)));
      } else {
        throw Exception(
            'Failed to load chats. Server returned ${response.statusCode}');
      }
    } catch (error) {
      print(error);
      errorMessage = 'Failed to fetch chats: ${error.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  sendMessage(String? donorName, String? content) async {
    errorMessage = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final hospitalName = prefs.getString('hospitalName');
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/chat/send/');
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender_name': donorName,
          'sender_type': 'hospital',
          'hospital': hospitalName,
          'content': content,
        }),
      );
      print(hospitalName);
      print(donorName);

      // print(response.body);
      if (response.statusCode == 201) {
        fetchChats(donorName);
        return 'Sent';
      } else if (response.statusCode == 400) {
        // final data = jsonDecode(response.body);
        return 'This Hospital Not Valid';
      } else {
        return 'Unexpected error occurred. Please try again.';
      }
    } catch (e) {
      print(e);
      return 'Failed to Sent: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
