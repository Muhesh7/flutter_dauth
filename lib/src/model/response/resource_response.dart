import 'dart:convert';

ResourceResponse resourceResponseFromJson(String str) =>
    ResourceResponse.fromJson(json.decode(str));

class ResourceResponse {
  ResourceResponse({
    this.email,
    this.id,
    this.name,
    this.phoneNumber,
    this.gender,
    this.createdAt,
    this.updatedAt,
  });

  final String? email;
  final int? id;
  final String? name;
  final String? phoneNumber;
  final String? gender;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  factory ResourceResponse.fromRawJson(String str) =>
      ResourceResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ResourceResponse.fromJson(Map<String, dynamic> json) =>
      ResourceResponse(
        email: json['email'],
        id: json['id'],
        name: json['name'],
        phoneNumber: json['phoneNumber'],
        gender: json['gender'],
        createdAt: DateTime.parse(json['createdAt']),
        updatedAt: DateTime.parse(json['updatedAt']),
      );

  Map<String, dynamic> toJson() => {
        'email': email,
        'id': id,
        'name': name,
        'phoneNumber': phoneNumber,
        'gender': gender,
        'createdAt': createdAt!.toIso8601String(),
        'updatedAt': updatedAt!.toIso8601String(),
      };
}
