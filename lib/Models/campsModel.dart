import 'dart:convert';

List<CampsModel> campsModelFromJson(String str) =>
    List<CampsModel>.from(json.decode(str).map((x) => CampsModel.fromJson(x)));

String campsModelToJson(List<CampsModel> data) =>
    json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class CampsModel {
  int? id;
  String? hospital; // Changed to String
  DateTime? date;
  String? location;
  String? startTime;
  String? endTime;
  String? description;
  String? status; // Changed to String
  DateTime? createdAt;

  CampsModel({
    this.id,
    this.hospital,
    this.date,
    this.location,
    this.startTime,
    this.endTime,
    this.description,
    this.status,
    this.createdAt,
  });

  factory CampsModel.fromJson(Map<String, dynamic> json) => CampsModel(
        id: json["id"],
        hospital: json["hospital"], // Directly using String
        date: json["date"] != null ? DateTime.parse(json["date"]) : null,
        location: json["location"],
        startTime: json["start_time"],
        endTime: json["end_time"],
        description: json["description"],
        status: json["status"], // Directly using String
        createdAt: json["created_at"] != null
            ? DateTime.parse(json["created_at"])
            : null,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "hospital": hospital, // Directly using String
        "date": date?.toIso8601String(),
        "location": location,
        "start_time": startTime,
        "end_time": endTime,
        "description": description,
        "status": status, // Directly using String
        "created_at": createdAt?.toIso8601String(),
      };
}
