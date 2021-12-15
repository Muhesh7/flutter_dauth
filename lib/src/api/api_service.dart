import 'dart:async';

import 'package:flutter_dauth/src/api/urls.dart';
import 'package:flutter_dauth/src/model/requests/token_request.dart';
import 'package:flutter_dauth/src/model/response/resource_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:http/http.dart' as http;

///[Api] class is a ApiManager which handles all the Network related processes by using [http].
class Api {
  var client = http.Client();

  ///This Method fetches and returns Future of [TokenResponse] along with the response-status-message.
  Future<TokenResponse> getToken(TokenRequest request, String code,
      Completer<TokenResponse> completer) async {
    try {
      //POST request is sent to DAuth Authorization-Server with TokenRequest parameters as request-body.
      var response = await client.post(Uri.parse(Urls.tokenEndPoint), body: {
        'client_id': request.clientId,
        'code_verifier': request.codeVerifier,
        'redirect_uri': request.redirectUri,
        'grant_type': request.grantType,
        'code': code
      });

      ///If response-code is 200 we return the [TokenResponse] else an Exception is thrown.
      if (response.statusCode == 200) {
        return tokenResponseFromJson(response.body);
      } else {
        var error =
            'failed with Response-Code:${response.statusCode} because: ${response.body}';
        completer.completeError(error);
        throw error;
      }
    } catch (e) {
      var error = 'error:${e.toString()}';
      completer.completeError(error);
      throw error;
    }
  }

  ///This Method fetches and returns Future of [ResourceResponse] along with the response-status-message.
  Future<ResourceResponse> getResources(String token) async {
    try {
      //POST request is sent to DAuth Resource-Server with access_token as request-body parameter.
      var response = await client.post(Uri.parse(Urls.resourceEndPoint),
          body: {'access_token': token});

      ///If response-code is 200 we return the [ResourceResponse] else an Exception is thrown.
      if (response.statusCode == 200) {
        return resourceResponseFromJson(response.body);
      } else {
        throw 'failed with Response-Code:${response.statusCode} because: ${response.body}';
      }
    } catch (e) {
      throw 'error:${e.toString()}';
    }
  }
}
