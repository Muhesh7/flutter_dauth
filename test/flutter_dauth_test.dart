import 'package:flutter_dauth/flutter_dauth.dart';
import 'package:flutter_dauth/src/api/api_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/testing.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_dauth/flutter_dauth.dart' as dauth;

void main() {
  late TokenRequest tokenRequest;
  late AuthorizationCodeGrant grant;
  late Api apiProvider;
  setUp(() {
    apiProvider = Api();
    tokenRequest = TokenRequest(
        clientId: 'Id',
        clientSecret: 'clientSecret',
        redirectUri: 'http://example.com/redirect',
        state: 'XXXX');
    grant = dauth.AuthorizationCodeGrant();
  });

  group('.getAuthorizationUrl', () {
    test('builds the correct URL', () {
      expect(
          grant.getAuthorizationUrl(tokenRequest),
          allOf([
            startsWith('https://auth.delta.nitt.edu/authorize?'),
            contains('client_id=${tokenRequest.clientId}'),
            contains('&redirect_uri=${tokenRequest.redirectUri}'),
            contains('&state=${tokenRequest.state}'),
          ]));
    });

    test('getToken', () async {
      apiProvider.client = MockClient((request) async {
        final mapJson = TokenResponse(tokenType: 'Bearer');
        return http.Response(json.encode(mapJson), 200);
      });
      final item = await apiProvider.getToken(tokenRequest, 'code');
      expect((item.response as TokenResponse).tokenType, 'Bearer');
    });
  });
}
