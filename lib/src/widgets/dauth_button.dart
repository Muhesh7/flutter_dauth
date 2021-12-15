import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/helpers/authorization_code_grant.dart';
import 'package:flutter_dauth/src/model/requests/token_request.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';

///[DAuthButton] is an Additional Widget Provided to Client-App to Ease the proccess of Retrival of TokenResponse
class DauthButton extends StatelessWidget {
  ///[onPressed] is a callback function which returns the `TokenResponse` as Response-Body Asynchronouslly when pressed.
  final Function onPressed;

  ///[request] is the `TokenRequest` input by client-App.
  final TokenRequest request;

  const DauthButton({Key? key, required this.onPressed, required this.request})
      : super(key: key);

  //Private method to call fetchToken() when the Button is Pressed.
  Future<TokenResponse> _requestToken(BuildContext context) =>
      AuthorizationCodeGrant().fetchToken(request, context);

  @override
  Widget build(BuildContext context) => Container(
        height: 50,
        width: 320,
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: TextButton(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              Expanded(
                  flex: 1,
                  child: SizedBox(
                    height: 28,
                    width: 28,
                    child: Image(
                        image: AssetImage('lib/src/img/delta_logo.png',
                            package: 'flutter_dauth')),
                  )),
              Expanded(
                flex: 2,
                child: Text(
                  'Sign In With DAuth',
                  style: TextStyle(fontSize: 15, color: Colors.white),
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
            //awaits and recieves the TokenResponse
            var response = await _requestToken(context);

            //sends the retrived response as callBack
            onPressed(response);
          },
        ),
      );
}
