import 'dart:async';
import 'dart:convert';
import 'dart:math';
import 'package:crypto/crypto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/api/api_service.dart';
import 'package:flutter_dauth/src/api/urls.dart';
import 'package:flutter_dauth/src/model/requests/token_request.dart';
import 'package:flutter_dauth/src/model/response/resource_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:flutter_dauth/src/widgets/dauth_web_view.dart';

/// AuthorizationCodeGrant class allows developer to use DAuth Authentication & Resource Services
/// This class has all the required methods to automates the fetching proccess of `accessToken`
/// And provides method to fetch user Resources using it.

class AuthorizationCodeGrant {
  ///This Method takes `accessToken` as input parameters and returns Future of `ResourceResponse`
  ///This Method is a layer of abstraction for getResource() in Api service.

  Future<ResourceResponse> fetchResources(String accessToken) async =>
      Api().getResources(accessToken);

  ///This Method takes `TokenRequest` and context as input parameters and Automates the entire worflow for fetching `TokenResponse`
  ///This Method is a layer of abstraction for getToken() in Api service.
  Future<TokenResponse> fetchToken(
      TokenRequest request, BuildContext context) async {
    ///completer object ensures that the this function returns the Value only after the TokenResponse is fetched.
    final completer = Completer<TokenResponse>();

    //opening the webview
    _openWebView(context, completer, request);

    //returns only after we get the token response
    return completer.future;
  }

  ///This Method takes `TokenRequest` as parameter and generates `AuthorizationUrl` for the webview to render
  String getAuthorizationUrl(TokenRequest request) {
    String url =
        '${Urls.authorizationEndPoint}?client_id=${request.clientId}&code_challenge_method=${request.codeChallengeMethod}&redirect_uri=${request.redirectUri}&response_type=${request.responseType}&grant_type=${request.grantType}&state=${request.state}';

    request.codeVerifier = request.codeVerifier ?? _createCodeVerifier();

    url += '&code_challenge=${_generateCodeChallenge(request.codeVerifier!)}';

    if (request.scope != null) {
      url += '&scope=${request.scope!.scopeParser()}';
    }

    if (request.nonce != null) {
      url += '&nonce=${request.nonce}';
    }

    return url;
  }

  static const String _charset =
      'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-._~';

  ///This Method creates `codeVerifier` if client doesnt provide one.
  String _createCodeVerifier() => List.generate(
      128, (i) => _charset[Random.secure().nextInt(_charset.length)]).join();

  ///This Method takes `codeVerifier` as parameter and sHa256 encodes it and generates `codeChallenge`.
  String _generateCodeChallenge(String codeVerifier) => base64Url
      .encode(sha256.convert(ascii.encode(codeVerifier)).bytes)
      .replaceAll('=', '');

  ///This Method OpensUp the WebView by Building `DauthWebView` Widget
  Future<void> _openWebView(BuildContext _context,
      Completer<TokenResponse> completer, TokenRequest request) async {
    //This Completer is used to notify when the WebView is loading is finished
    final Completer<bool> _isPageLoaded = Completer<bool>();

    //Opens Up WebView in a FullScreenDialog
    showDialog(
        context: _context,
        builder: (BuildContext context) => DauthWebView(
            authorizationUrl: getAuthorizationUrl(request),
            redirectUri: request.redirectUri,
            completer: completer,
            loader: _isPageLoaded,
            request: request));
  }
}
