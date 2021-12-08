import 'package:flutter_dauth/src/api/urls.dart';
import 'package:flutter_dauth/src/model/requests/token_request.dart';
import 'package:flutter_dauth/src/model/response/resource_response.dart';
import 'package:flutter_dauth/src/model/response/result_response.dart';
import 'package:flutter_dauth/src/model/response/token_response.dart';
import 'package:http/http.dart' as http;

///[Api] class is a ApiManager which handles all the Network related processes by using [http].
class Api {
  static var client = http.Client();

  ///This Method fetches and returns Future of [TokenResponse] along with the response-status-message.
  Future<ResultResponse<TokenResponse, String>> getToken(
      TokenRequest request, String code) async {
    var tokenResponse = TokenResponse();
    var message = '';
    try {
      //POST request is sent to DAuth Authorization-Server with TokenRequest parameters as request-body.
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
        message =
            'failed with Response-Code:${response.statusCode} because: ${response.body}';
      }
    } catch (e) {
      message = 'error:${e.toString()}';
    }

    ///If response-code is 200 we return the [TokenResponse] else an Empty Object of it with corresponding message.
    return ResultResponse(tokenResponse, message);
  }

  ///This Method fetches and returns Future of [ResourceResponse] along with the response-status-message.
  Future<ResultResponse<ResourceResponse, String>> getResources(
      String token) async {
    var userResponse = ResourceResponse();
    var message = '';
    try {
      //POST request is sent to DAuth Resource-Server with access_token as request-body parameter.
      var response = await client.post(Uri.parse(Urls.resourceEndPoint),
          body: {'access_token': token});
      if (response.statusCode == 200) {
        userResponse = resourceResponseFromJson(response.body);
        message = 'success';
      } else {
        message =
            'failed with Response-Code:${response.statusCode} because: ${response.body}';
      }
    } catch (e) {
      message = 'error:${e.toString()}';
    }

    ///If response-code is 200 we return the [ResourceResponse] else an Empty Object of it with corresponding message.
    return ResultResponse(userResponse, message);
  }
}
