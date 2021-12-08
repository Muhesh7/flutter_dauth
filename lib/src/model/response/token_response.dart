import 'dart:convert';

TokenResponse tokenResponseFromJson(String str) =>
    TokenResponse.fromJson(json.decode(str));

///[TokenResponse] is the response-body recieved from fetchToken()

class TokenResponse {
  ///[tokenType] is the accessToken type returned from Dauth-server.
  final String? tokenType;

  ///[accessToken] is the accessToken returned from Dauth-server.
  final String? accessToken;

  ///[state] is the same state that was sent by client in `TokenRequest`.
  ///This can be used for Token Verification and prevent CSRF attacks.
  final String? state;

  ///[expiresIn] is the expirationTime of the accessToken from the time of last Token Fetch from server.
  final int? expiresIn;

  ///[idToken] is the idToken of the resource-owner from server.
  final String? idToken;

  ///[errorResponse] is optional field provided to handle errors.
  final ErrorResponse? errorResponse;

  TokenResponse(
      {this.tokenType,
      this.accessToken,
      this.state,
      this.expiresIn,
      this.idToken,
      this.errorResponse});

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

///[ErrorResponse] is object for handling network errors.

class ErrorResponse {
  ///[error] is a string which notifies about the error
  final String error;

  ///[errorDescription] is a string which gives detailed description of the error
  final String errorDescription;

  ErrorResponse({
    required this.error,
    required this.errorDescription,
  });

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
