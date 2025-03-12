class HospitalModel {
  final int id;
  final String name;
  final String email;
  final String contactNumber;
  final String address;
  final String? otp;
  final DateTime? otpGeneratedAt;
  final bool isVerified;
  final bool isActive;
  final bool isStaff;
  final DateTime createdAt;
  final String image;

  HospitalModel({
    required this.id,
    required this.name,
    required this.email,
    required this.contactNumber,
    required this.address,
    this.otp,
    this.otpGeneratedAt,
    required this.isVerified,
    required this.isActive,
    required this.isStaff,
    required this.createdAt,
    this.image = '', // Default empty string for null images
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
      otpGeneratedAt: json['otp_generated_at'] != null
          ? DateTime.tryParse(json['otp_generated_at'] as String)
          : null,
      isVerified: json['is_verified'] as bool,
      isActive: json['is_active'] as bool,
      isStaff: json['is_staff'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      image: json['image'] ?? '', // Handle null images properly
    );
  }

  // Convert a HospitalModel instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'contact_number': contactNumber,
      'address': address,
      'otp': otp,
      'otp_generated_at': otpGeneratedAt?.toIso8601String(),
      'is_verified': isVerified,
      'is_active': isActive,
      'is_staff': isStaff,
      'created_at': createdAt.toIso8601String(),
      'image': image.isNotEmpty ? image : null, // Avoid sending empty strings
    };
  }
}
