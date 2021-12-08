///Urls class Wraps all the required Url endpoints to [DAuth] Server
class Urls {
  //BASE_URL
  static const baseUrl = 'https://auth.delta.nitt.edu';
  //Authorization-End-Point used by Webview
  static const authorizationEndPoint = '$baseUrl/authorize';
  //Token-End-Point used by fetchToken() Network Method
  static const tokenEndPoint = '$baseUrl/api/oauth/token';
  //Resource-End-Point used by fetchResource() Network Method
  static const resourceEndPoint = '$baseUrl/api/resources/user';
}
