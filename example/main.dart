import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dauth/src/model/requests/grant_request.dart';
import 'package:flutter_dauth/src/model/response/result_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:flutter_dauth/src/widgets/dauth_button.dart';

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
  final String _exampleText = 'Flutter Application';
  final AuthorizationGrantRequest _authorizationGrantRequest =
      AuthorizationGrantRequest(
          clientId: 'YOUR CLIENT ID',
          clientSecret: 'YOUR CLIENT SECRET',
          redirectUri: 'YOUR REDIRECT URI',
          state: 'STATE');

  @override
  Widget build(BuildContext context) => SafeArea(
          child: Scaffold(
              body: Container(
        color: Colors.blueGrey,
        child: Stack(
          children: [
            Center(
                child: Text(
              _exampleText,
              style: const TextStyle(fontSize: 35, fontWeight: FontWeight.bold),
            )),
            Positioned(
                left: 50,
                right: 50,
                bottom: 10,
                child: DauthButton(
                    request: _authorizationGrantRequest,
                    onPressed: (ResultResponse<TokenResponse, String> res) {
                      setState(() => (res.response as TokenResponse)
                          .accessToken
                          .toString());
                    }))
          ],
        ),
      )));
}
