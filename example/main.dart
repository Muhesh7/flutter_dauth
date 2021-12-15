import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/model/requests/token_request.dart';
import 'package:flutter_dauth/flutter_dauth.dart' as dauth;

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => const MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomePage(),
      );
}

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  State<StatefulWidget> createState() => HomeState();
}

class HomeState extends State<HomePage> {
  //A string object used in Text() widget as data.
  String _exampleText = 'Flutter Application';

  //Create a TokenRequest Object
  final dauth.TokenRequest _request = TokenRequest(
      //Your Client-Id provided by Dauth Server at the time of registration.
      clientId: 'YOUR CLIENT ID',
      //redirectUri provided by You to Dauth Server at the time of registration.
      redirectUri: 'YOUR REDIRECT URI',
      //A String which will retured with access_token for token verification in client side.
      state: 'STATE',
      //setting isUser to true to retrive UserDetails in ResourceResponse from Dauth server.
      scope: const dauth.Scope(isUser: true),
      //codeChallengeMethod Should be specified as `plain` or `S256` based on thier requirement.
      codeChallengeMethod: 'S256');

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
              body: Container(
        color: Colors.blue,
        child: Stack(
          children: [
            Center(
                child: Text(
              _exampleText,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            )),
            Positioned(
                left: 50,
                right: 50,
                bottom: 10,
                //DAuth button returns TokenResponse and ResponseMessage when pressed.
                child: dauth.DauthButton(
                    request: _request,
                    onPressed: (dauth.TokenResponse res) {
                      //changes the exampleText as Token_TYPE: <YOUR_TOKEN> from the previous string if the response is success'
                      setState(() {
                        _exampleText = 'Token: ' + res.tokenType.toString();
                      });
                    }))
          ],
        ),
      )));
}
