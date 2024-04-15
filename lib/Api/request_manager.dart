import 'package:http/http.dart' as http;

class APIRequest {
  String endPoint;
  Map<String, Object> response = Map<String, Object>();

  APIRequest(this.endPoint);

  Map<String, Object> getParams() {
    return null;
  }

  Map<String, String> getHeaders() {
    Map<String, String> headers = Map<String, String>();
    // headers["Content-Type"] = "application/json";
    return headers;
  }

  String parseResponse(http.Response response, bool showLog) {
    String retVal = response.body;

    if (showLog) {
      print("API Response: $retVal ${this.endPoint}");
    }

    return retVal;
  }

  String dummyResponse() {
    return "";
  }
}
