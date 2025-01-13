import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:blood_donation/Models/chatModel.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ChatsProvider extends ChangeNotifier {
  List<ChatModel> chats = [];
  bool _isLoading = false;
  String? errorMessage;

  bool get isLoading => _isLoading; // Getter for _isLoading

  // Fetch chats from the API
  fetchChats(int? id) async {
    _isLoading = true;
    errorMessage = null;
    notifyListeners();

    try {
      final response = await http.get(
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/chat/${id}/'),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        chats = List<ChatModel>.from(data.map((x) => ChatModel.fromJson(x)));
      } else {
        throw Exception(
            'Failed to load chats. Server returned ${response.statusCode}');
      }
    } catch (error) {
      errorMessage = 'Failed to fetch chats: ${error.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  sendMessage(int? id, String? hospitalName, String? content) async {
    errorMessage = null;
    notifyListeners();
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('username');
    final url =
        Uri.parse('https://lifeproject.pythonanywhere.com/donor/chat/send/');

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'sender_name': username,
          'sender_type': 'donor',
          'hospital': hospitalName,
          'content': content,
        }),
      );
      print(username);
      print(hospitalName);
      if (response.statusCode == 201) {
        fetchChats(id);
        return 'Sent';
      } else if (response.statusCode == 400) {
        final data = jsonDecode(response.body);
        return data ?? 'This Hospital Not Valid';
      } else {
        return 'Unexpected error occurred. Please try again.';
      }
    } catch (e) {
      return 'Failed to Sent: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
