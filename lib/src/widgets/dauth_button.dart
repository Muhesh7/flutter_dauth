import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/helpers/authorization_code_grant.dart';
import 'package:flutter_dauth/src/model/requests/grant_request.dart';
import 'package:flutter_dauth/src/model/response/result_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';

class DauthButton extends StatelessWidget {
  final Function onPressed;
  final AuthorizationGrantRequest request;
  const DauthButton({Key? key, required this.onPressed, required this.request})
      : super(key: key);

  Future<ResultResponse<TokenResponse, String>> _fetchToken(
          BuildContext context) =>
      AuthorizationCodeGrant().fetchTokenViaWebView(request, context);

  @override
  Widget build(BuildContext context) => Container(
        height: 50,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Expanded(
                flex: 1,
                child: Image.asset(
                  'lib/src/img/delta_logo.png',
                  height: 28,
                ),
              ),
              const Expanded(
                flex: 2,
                child: Text(
                  'Sign In With DeltaForce',
                  style: TextStyle(fontSize: 14, color: Colors.white),
                  textAlign: TextAlign.left,
                ),
              ),
            ],
          ),
          style: ButtonStyle(
              elevation: MaterialStateProperty.all<double>(16),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.black87),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(18.0),
                      side: const BorderSide(color: Colors.black)))),
          onPressed: () async {
            var response = await _fetchToken(context);
            onPressed(response);
          },
        ),
      );
}
