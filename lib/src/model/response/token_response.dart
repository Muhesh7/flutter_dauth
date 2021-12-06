import 'dart:convert';

TokenResponse tokenResponseFromJson(String str) =>
    TokenResponse.fromJson(json.decode(str));

class TokenResponse {
  TokenResponse(
      {this.tokenType,
      this.accessToken,
      this.state,
      this.expiresIn,
      this.idToken,
      this.status,
      this.errorResponse});

  final String? tokenType;
  final String? accessToken;
  final String? state;
  final int? expiresIn;
  final String? idToken;
  final String? status;
  final ErrorResponse? errorResponse;

  factory TokenResponse.fromRawJson(String str) =>
      TokenResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenResponse.fromJson(Map<String, dynamic> json) => TokenResponse(
        tokenType: json['token_type'],
        accessToken: json['access_token'],
        state: json['state'],
        expiresIn: json['expires_in'],
        idToken: json['id_token'],
      );

  Map<String, dynamic> toJson() => {
        'token_type': tokenType,
        'access_token': accessToken,
        'state': state,
        'expires_in': expiresIn,
        'id_token': idToken,
      };
}

class ErrorResponse {
  ErrorResponse({
    required this.error,
    required this.errorDescription,
  });

  final String error;
  final String errorDescription;

  factory ErrorResponse.fromRawJson(String str) =>
      ErrorResponse.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory ErrorResponse.fromJson(Map<String, dynamic> json) => ErrorResponse(
        error: json['error'],
        errorDescription: json['error_description'],
      );

  Map<String, dynamic> toJson() => {
        'error': error,
        'error_description': errorDescription,
      };
}
