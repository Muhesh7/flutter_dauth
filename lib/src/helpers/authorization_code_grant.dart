import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/api/urls.dart';
import 'package:flutter_dauth/src/model/requests/grant_request.dart';
import 'package:flutter_dauth/src/model/response/result_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:flutter_dauth/src/widgets/dauth_web_view.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthorizationCodeGrant {
  late AuthorizationGrantRequest _authorizationGrantRequest;

  Future<ResultResponse<TokenResponse, String>> fetchTokenViaWebView(
      AuthorizationGrantRequest authorizationGrantRequest,
      BuildContext context) async {
    _authorizationGrantRequest = authorizationGrantRequest;
    final completer = Completer<ResultResponse<TokenResponse, String>>();
    _openWebView(context, completer);
    return completer.future;
  }

  String _getAuthorizationUrl() {
    String url =
        '${Urls.authorizationEndPoint}?client_id=${_authorizationGrantRequest.clientId}&redirect_uri=${_authorizationGrantRequest.redirectUri}&response_type=${_authorizationGrantRequest.responseType}&grant_type=${_authorizationGrantRequest.grantType}&state=${_authorizationGrantRequest.state}';
    if (_authorizationGrantRequest.scope != null) {
      url += '&scope=${_authorizationGrantRequest.scope!.scopeParser()}';
    }
    if (_authorizationGrantRequest.nonce != null) {
      url += '&nonce=${_authorizationGrantRequest.nonce}';
    }
    return url;
  }

  String _getRedirectUri() => _authorizationGrantRequest.redirectUri;

  void _openWebView(BuildContext _context,
      Completer<ResultResponse<TokenResponse, String>> completer) async {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    showDialog(
        context: _context,
        builder: (BuildContext context) => DauthWebView(
            authorizationUrl: _getAuthorizationUrl(),
            redirectUri: _getRedirectUri(),
            completer: completer,
            request: _authorizationGrantRequest));
  }
}
