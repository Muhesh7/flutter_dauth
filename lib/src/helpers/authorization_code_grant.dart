import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/api/api_service.dart';
import 'package:flutter_dauth/src/api/urls.dart';
import 'package:flutter_dauth/src/model/requests/grant_request.dart';
import 'package:flutter_dauth/src/model/response/resource_response.dart';
import 'package:flutter_dauth/src/model/response/result_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:webview_flutter/webview_flutter.dart';

class AuthorizationCodeGrant {
  late AuthorizationGrantRequest _authorizationGrantRequest;
  final Api _api = Api();

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

  String _getRedirectUri() {
    return _authorizationGrantRequest.redirectUri;
  }

  void _openWebView(BuildContext _context,
      Completer<ResultResponse<TokenResponse, String>> completer) async {
    if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();

    showDialog(
        context: _context,
        builder: (BuildContext context) => _webViewDialog(context, completer));
  }

  Widget _webViewDialog(BuildContext dialogContext,
          Completer<ResultResponse<TokenResponse, String>> completer) =>
      WebView(
        javascriptMode: JavascriptMode.unrestricted,
        initialUrl: _getAuthorizationUrl(),
        navigationDelegate: (navReq) async {
          if (navReq.url.startsWith(_getRedirectUri())) {
            Uri responseUrl = Uri.parse(navReq.url);
            String? code = responseUrl.queryParameters['code'];
            var res = await _requestToken(code!);
            completer.complete(res);
            Navigator.pop(dialogContext);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      );

  Future<ResultResponse<TokenResponse, String>> _requestToken(
          String code) async =>
      _api.fetchToken(_authorizationGrantRequest, code);

  Future<ResultResponse<ResourceResponse, String>> requestResource(
          String accessToken) async =>
      _api.fetchResources(accessToken);
}
