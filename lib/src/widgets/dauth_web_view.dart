import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/api/api_service.dart';
import 'package:flutter_dauth/src/model/requests/token_request.dart';
import 'package:flutter_dauth/src/model/response/result_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:flutter_dauth/src/widgets/dauth_loader.dart';
import 'package:webviewx/webviewx.dart';

///[DauthWebView] is Widget which renders webview and automates the Authorization proccess.

class DauthWebView extends StatelessWidget {
  ///[authorizationUrl] is the url that the webview renders.
  final String authorizationUrl;

  ///[redirectUri] is the uri the webview redirects after the authorization request.
  final String redirectUri;

  ///[request] is the Object of `TokenRequest`
  final TokenRequest request;

  ///[completer] returns the future when `TokenResponse` is fetched.
  final Completer<ResultResponse<TokenResponse, String>> completer;

  ///[loader] returns the future when webView is loaded.
  final Completer<bool> loader;

  const DauthWebView(
      {Key? key,
      required this.authorizationUrl,
      required this.redirectUri,
      required this.completer,
      required this.request,
      required this.loader})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return SafeArea(
        child: SingleChildScrollView(
            child: Stack(children: [
      Center(
          child: WebViewX(
        width: size.width,
        height: size.height + 15,
        javascriptMode: JavascriptMode.unrestricted,
        onPageFinished: (src) {
          if (!loader.isCompleted) loader.complete(true);
        },
        initialContent: authorizationUrl,
        navigationDelegate: (navReq) async {
          //listens to NavigationRequest and checks for [redirectUri]
          if (navReq.content.source.startsWith(redirectUri)) {
            Uri responseUrl = Uri.parse(navReq.content.source);

            //parsing the `code` parameter from responseUrl
            String? code = responseUrl.queryParameters['code'];

            //fetchesToken using the `code` as a input parameter and returns future of [TokenResponse].
            var res = await Api().getToken(request, code!);

            //Completes the completer.
            completer.complete(res);

            ///Pops the webView form the WidgetStack
            Navigator.pop(context);
            return NavigationDecision.prevent;
          }
          return NavigationDecision.navigate;
        },
      )),

      //Loader Widget which renders until the [loader] is completed.
      WebViewAware(
          child: FutureBuilder<bool>(
              future: loader.future, // async work
              builder: (BuildContext c, AsyncSnapshot<bool> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const DauthLoader();
                } else {
                  return const SizedBox.shrink();
                }
              }))
    ])));
  }
}
