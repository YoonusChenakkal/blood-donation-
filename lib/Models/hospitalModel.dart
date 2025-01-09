class HospitalModel {
  final int id;
  final String name;
  final String email;
  final String contactNumber;
  final String address;
  final String? otp;
  final DateTime otpGeneratedAt;
  final bool isVerified;
  final bool isActive;
  final bool isStaff;
  final DateTime createdAt;
  final String? image; // Added image field (nullable)

  HospitalModel({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.address,
    this.otp,
    required this.otpGeneratedAt,
    required this.isVerified,
    required this.isActive,
    required this.isStaff,
    required this.createdAt,
    this.image, // Initialize the image field
  });

  // Factory method to create a HospitalModel from JSON
  factory HospitalModel.fromJson(Map<String, dynamic> json) {
    return HospitalModel(
      id: json['id'] as int,
      name: json['name'] as String,
      email: json['email'] as String,
      contactNumber: json['contact_number'] as String,
      address: json['address'] as String,
      otp: json['otp'] as String?,
      otpGeneratedAt: DateTime.parse(json['otp_generated_at'] as String),
      isVerified: json['is_verified'] as bool,
      isActive: json['is_active'] as bool,
      isStaff: json['is_staff'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      image: json['image'] as String?, // Parse the image field
    );
  }

  // Method to convert a HospitalModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact_number': contactNumber,
      'address': address,
      'otp': otp,
      'otp_generated_at': otpGeneratedAt.toIso8601String(),
      'is_verified': isVerified,
      'is_active': isActive,
      'is_staff': isStaff,
      'created_at': createdAt.toIso8601String(),
      'image': image, // Include the image field
    };
  }
}
