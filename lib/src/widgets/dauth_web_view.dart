import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/api/api_service.dart';
import 'package:flutter_dauth/src/model/requests/grant_request.dart';
import 'package:flutter_dauth/src/model/response/result_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:flutter_dauth/src/widgets/dauth_loader.dart';
import 'package:webviewx/webviewx.dart';

class DauthWebView extends StatelessWidget {
  final String authorizationUrl;
  final String redirectUri;
  final AuthorizationGrantRequest request;
  final Completer<ResultResponse<TokenResponse, String>> completer;
  const DauthWebView(
      {Key? key,
      required this.authorizationUrl,
      required this.redirectUri,
      required this.completer,
      required this.request})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Completer<bool> _loader = Completer<bool>();
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: Stack(children: [
      Center(
          child: WebViewX(
        width: size.width,
        height: size.height,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (src) => _loader.complete(true),
        initialContent: authorizationUrl,
        navigationDelegate: (navReq) async {
          if (navReq.content.source.startsWith(redirectUri)) {
            Uri responseUrl = Uri.parse(navReq.content.source);
            String? code = responseUrl.queryParameters['code'];
            var res = await Api().fetchToken(request, code!);
            completer.complete(res);
            Navigator.pop(context);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      )),
      WebViewAware(
          child: FutureBuilder<bool>(
              future: _loader.future, // async work
              builder: (BuildContext c, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DauthLoader();
                }
                return const SizedBox.shrink();
              }))
    ]));
  }
}
