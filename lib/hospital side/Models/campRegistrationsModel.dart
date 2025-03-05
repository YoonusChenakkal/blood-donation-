import 'dart:convert';

CampRegistrationsModel campRegistrationsModelFromJson(String str) => CampRegistrationsModel.fromJson(json.decode(str));

String campRegistrationsModelToJson(CampRegistrationsModel data) => json.encode(data.toJson());

class CampRegistrationsModel {
    Camp camp;
    List<Registration> registrations;

    CampRegistrationsModel({
        required this.camp,
        required this.registrations,
    });

    factory CampRegistrationsModel.fromJson(Map<String, dynamic> json) => CampRegistrationsModel(
        camp: Camp.fromJson(json["camp"]),
        registrations: List<Registration>.from(json["registrations"].map((x) => Registration.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "camp": camp.toJson(),
        "registrations": List<dynamic>.from(registrations.map((x) => x.toJson())),
    };
}

class Camp {
    String location;
    DateTime date;
    String hospital;

    Camp({
        required this.location,
        required this.date,
        required this.hospital,
    });

    factory Camp.fromJson(Map<String, dynamic> json) => Camp(
        location: json["location"],
        date: DateTime.parse(json["date"]),
        hospital: json["hospital"],
    );

    Map<String, dynamic> toJson() => {
        "location": location,
        "date": "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
        "hospital": hospital,
    };
}

class Registration {
    String username;
    String email;
    String bloodGroup;
    int contactNumber;
    String address;
    DateTime registrationDate;

    Registration({
        required this.username,
        required this.email,
        required this.bloodGroup,
        required this.contactNumber,
        required this.address,
        required this.registrationDate,
    });

    factory Registration.fromJson(Map<String, dynamic> json) => Registration(
        username: json["username"],
        email: json["email"],
        bloodGroup: json["blood_group"],
        contactNumber: json["contact_number"],
        address: json["address"],
        registrationDate: DateTime.parse(json["registration_date"]),
    );

    Map<String, dynamic> toJson() => {
        "username": username,
        "email": email,
        "blood_group": bloodGroup,
        "contact_number": contactNumber,
        "address": address,
        "registration_date": registrationDate.toIso8601String(),
    };
}
