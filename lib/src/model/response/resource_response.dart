import 'dart:convert';

ResourceResponse resourceResponseFromJson(String str) =>
    ResourceResponse.fromJson(json.decode(str));

///[ResourceResponse] is the response-body received from Dauth server when requested for Resources using the `accessToken`
class ResourceResponse {
  ///[email] is the emailId of the resource-owner/user.
  final String? email;

  ///[id] is the id of the resource-owner/user in DAuth DB.
  final int? id;

  ///[email] is the name of the resource-owner/user.
  final String? name;

  ///[phoneNumber] is the phoneNumber of the resource-owner/user.
  final String? phoneNumber;

  ///[gender] is the gender of the resource-owner/user.
  final String? gender;

  ///[createdAt] is the DateTime when the resource is added to DB.
  final DateTime? createdAt;

  ///[createdAt] is the DateTime when the resource is updated in DB.
  final DateTime? updatedAt;

  ResourceResponse({
    this.email,
    this.id,
    this.name,
    this.phoneNumber,
    this.gender,
    this.createdAt,
    this.updatedAt,
  });

  //Following Methods are used for Json to Object and Vice-Versa convertions.
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
