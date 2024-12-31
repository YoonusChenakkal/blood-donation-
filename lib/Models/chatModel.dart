class ChatModel {
  final int id;
  final String senderType;
  final String senderName;
  final int hospital;
  final String content;
  final DateTime timestamp;
  final bool isRead;

  ChatModel({
    required this.id,
    required this.senderType,
    required this.senderName,
    required this.hospital,
    required this.content,
    required this.timestamp,
    required this.isRead,
  });

  // Factory method to create a ChatModel from JSON
  factory ChatModel.fromJson(Map<String, dynamic> json) {
    return ChatModel(
      id: json['id'],
      senderType: json['sender_type'],
      senderName: json['sender_name'],
      hospital: json['hospital'],
      content: json['content'],
      timestamp: DateTime.parse(json['timestamp']),
      isRead: json['is_read'],
    );
  }

  // Method to convert a ChatModel object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'sender_type': senderType,
      'sender_name': senderName,
      'hospital': hospital,
      'content': content,
      'timestamp': timestamp.toIso8601String(),
      'is_read': isRead,
    };
  }
}
