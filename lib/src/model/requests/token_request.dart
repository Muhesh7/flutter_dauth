import 'dart:convert';

///[TokenRequest] is the request-body used to fetch the `TokenResponse` from DAuth Server
class TokenRequest {
  ///[clientId] is a Public Id Provided by DAuth Server at the time of Client Registration.
  final String clientId;

  ///[code_verifier] is a Secret Provided by DAuth Server at the time of Client Registration.
  String? codeVerifier;

  ///[code_challenge_method] is a Secret Provided by DAuth Server at the time of Client Registration.
  final String codeChallengeMethod;

  ///[redirectUri] is usually the `callbackurl` given during Client Registration.
  final String redirectUri;

  ///[responseType] tells the authorization server which grant to execute.
  ///Uses response_type=`code` for authorization code by Default.
  final String responseType;

  ///Uses [grantType]=`authorization_code` for authorization grant flow by Default.
  final String grantType;

  ///[state] is Used for security purposes.
  ///It is returned back to the application as part of the `redirectUri`.
  final String state;

  ///[scope] is The authorization and token endpoints allow the client to specify the scope of the access request using the scope request parameter.
  final Scope? scope;

  ///[nonce] is a client generated string. It will be returned in the token and hence the client can validate the token.
  final String? nonce;

  TokenRequest({
    required this.clientId,
    this.codeVerifier,
    required this.codeChallengeMethod,
    required this.redirectUri,
    this.responseType = 'code',
    this.grantType = 'authorization_code',
    required this.state,
    this.scope,
    this.nonce,
  });

  //Following Methods are used for Json to Object and Vice-Versa convertions.
  factory TokenRequest.fromRawJson(String str) =>
      TokenRequest.fromJson(json.decode(str));

  String toRawJson() => json.encode(toJson());

  factory TokenRequest.fromJson(Map<String, dynamic> json) => TokenRequest(
        clientId: json['client_id'],
        codeVerifier: json['code_verifier'],
        redirectUri: json['redirect_uri'],
        responseType: json['response_type'],
        grantType: json['grant_type'],
        state: json['state'],
        scope: json['scope'],
        nonce: json['nonce'],
        codeChallengeMethod: json['code_challenge_method'],
      );

  Map<String, dynamic> toJson() => {
        'client_id': clientId,
        'code_verifier': codeVerifier,
        'redirect_uri': redirectUri,
        'response_type': responseType,
        'grant_type': grantType,
        'state': state,
        'scope': scope ?? scope!.scopeParser(),
        'nonce': nonce,
        'code_challenge_method': codeChallengeMethod,
      };
}

///[scope] has four boolean parameters to enable scope of `OpenId`, `Email`, `Profile`, `User` and by default all are false.
///To use the Respective scope assign it to true.
class Scope {
  ///Set [isOpenId] to true to recieve id_token in the response of `/api/token call`.
  final bool isOpenId;

  ///Set [isEmail] to true to recieve email of user in id_token.
  final bool isEmail;

  ///Set [isProfile] to true to recieve profile of user in id_token.
  final bool isProfile;

  ///Set [isUser] to true to recieve `ResourceResponse`.
  final bool isUser;

  const Scope(
      {this.isOpenId = false,
      this.isEmail = false,
      this.isProfile = false,
      this.isUser = false});

  ///Scope Parameter generator method for AuthorizationUrl
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
