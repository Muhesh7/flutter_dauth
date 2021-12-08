///[ResultResponse] is a Wrapper class which wraps Response-body and Response-message.
///Eases Network Handling for Developers.
///
class ResultResponse<T, String> {
  ///[response] is the json/dynamic response from the http request.
  final dynamic response;

  ///[message] is the response message from the http request
  final String message;

  ResultResponse(this.response, this.message);
}
