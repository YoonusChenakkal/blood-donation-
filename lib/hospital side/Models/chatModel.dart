class ChatModel {
  final int id;
  final String senderType;
  final String senderName;
  final String hospitalName;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  ChatModel({
    required this.id,
    required this.senderType,
    required this.senderName,
    required this.hospitalName,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  // Factory constructor for creating a ChatModel from JSON
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'], // Directly maps to id in JSON
      senderType: json['sender_type'], // Maps sender_type
      senderName: json['sender_name'], // Maps sender_name
      hospitalName: json['hospital_name'], // Maps hospital_name
      content: json['content'], // Maps content
      timestamp: DateTime.parse(json['timestamp']), // Converts timestamp string to DateTime
      isRead: json['is_read'], // Maps is_read
    );
  }

  // Converts a ChatModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_type': senderType,
      'sender_name': senderName,
      'hospital_name': hospitalName,
      'content': content,
      'timestamp': timestamp.toIso8601String(), // Converts DateTime to ISO 8601 string
      'is_read': isRead,
    };
  }
}
