import 'package:flutter_dauth/src/api/urls.dart';
import 'package:flutter_dauth/src/model/requests/grant_request.dart';
import 'package:flutter_dauth/src/model/response/resource_response.dart';
import 'package:flutter_dauth/src/model/response/result_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:http/http.dart' as http;

class Api {
  static var client = http.Client();

  Future<ResultResponse<TokenResponse, String>> fetchToken(
      AuthorizationGrantRequest request, String code) async {
    var tokenResponse = TokenResponse();
    var message = '';
    try {
      var response = await client.post(Uri.parse(Urls.tokenEndPoint), body: {
        'client_id': request.clientId,
        'client_secret': request.clientSecret,
        'redirect_uri': request.redirectUri,
        'grant_type': request.grantType,
        'code': code
      });
      if (response.statusCode == 200) {
        tokenResponse = tokenResponseFromJson(response.body);
        message = 'success';
      } else {
        message = 'failed';
      }
    } catch (e) {
      message = 'error';
    }
    return ResultResponse(tokenResponse, message);
  }

  Future<ResultResponse<ResourceResponse, String>> fetchResources(
      String token) async {
    var userResponse = ResourceResponse();
    var message = '';
    try {
      var response = await client.post(Uri.parse(Urls.resourceEndPoint),
          body: {'access_token': token});
      if (response.statusCode == 200) {
        userResponse = resourceResponseFromJson(response.body);
        message = 'success';
      } else {
        message = 'failed';
      }
    } catch (e) {
      message = 'error';
    }
    return ResultResponse(userResponse, message);
  }
}
