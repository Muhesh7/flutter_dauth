import 'dart:convert';

class AuthorizationGrantRequest {
  AuthorizationGrantRequest({
    required this.clientId,
    required this.clientSecret,
    required this.redirectUri,
    this.responseType = 'code',
    this.grantType = 'authorization_code',
    required this.state,
    this.scope,
    this.nonce,
  });

  final String clientId;
  final String clientSecret;
  final String redirectUri;
  final String responseType;
  final String grantType;
  final String state;
  final Scope? scope;
  final String? nonce;

  factory AuthorizationGrantRequest.fromRawJson(String str) =>
      AuthorizationGrantRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory AuthorizationGrantRequest.fromJson(Map<String, dynamic> json) =>
      AuthorizationGrantRequest(
        clientId: json['client_id'],
        clientSecret: json['client_secret'],
        redirectUri: json['redirect_uri'],
        responseType: json['response_type'],
        grantType: json['grant_type'],
        state: json['state'],
        scope: json['scope'],
        nonce: json['nonce'],
      );

  Map<String, dynamic> toJson() => {
        'client_id': clientId,
        'client_secret': clientSecret,
        'redirect_uri': redirectUri,
        'response_type': responseType,
        'grant_type': grantType,
        'state': state,
        'scope': scope ?? scope!.scopeParser(),
        'nonce': nonce,
      };
}

class Scope {
  const Scope(
      {this.isOpenId = false,
      this.isEmail = false,
      this.isProfile = false,
      this.isUser = false});
  final bool isOpenId;
  final bool isEmail;
  final bool isProfile;
  final bool isUser;

  String scopeParser() {
    var scopeList = <String>[];
    if (isOpenId) scopeList.add('openid');
    if (isEmail) scopeList.add('email');
    if (isProfile) scopeList.add('profile');
    if (isUser) scopeList.add('user');
    final end = scopeList.length;
    String scope = '';
    for (int i = 0; i < end; ++i) {
      scope += scopeList[i];
      if (i < end - 1) scope += '+';
    }
    return scope;
  }
}
