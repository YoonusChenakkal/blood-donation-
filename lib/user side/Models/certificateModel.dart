import 'dart:convert';

class CertificateModel {
  final String username;
  final String certificate;
  final String CertificateModelDate;
  final bool isCertificateModelGiven;

  CertificateModel({
    required this.username,
    required this.certificate,
    required this.CertificateModelDate,
    required this.isCertificateModelGiven,
  });

  // Factory constructor to create an instance from JSON
  factory CertificateModel.fromJson(Map<String, dynamic> json) {
    return CertificateModel(
      username: json['username'] ?? 'Unknown User',
      certificate: json['certificate'] ?? 'No Certificate',
      CertificateModelDate: json['CertificateModel_date'],
      isCertificateModelGiven: json['is_CertificateModel_given'],
    );
  }

  // Method to convert the model instance to JSON
  Map<String, dynamic> toJson() {
    return {
      'username': username,
      'certificate': certificate,
      'CertificateModel_date': CertificateModelDate,
      'is_CertificateModel_given': isCertificateModelGiven,
    };
  }

  // Static method to parse a JSON string into a list of CertificateModel objects
  static List<CertificateModel> fromJsonList(String jsonString) {
    final List<dynamic> jsonList = json.decode(jsonString);
    return jsonList.map((json) => CertificateModel.fromJson(json)).toList();
  }
}
