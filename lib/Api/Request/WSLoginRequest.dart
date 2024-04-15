import 'dart:convert';

import 'package:foodie_bell/Api/request_manager.dart';
import 'package:http/http.dart' as http;

class WSLoginRequest extends APIRequest {
  String email;
  String password;
  String deviceToken;

  WSLoginRequest({
    endPoint,
    this.email,
    this.password,
    this.deviceToken,
  }) : super(endPoint + "Login") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["driver_email"] = this.email;
    params["password"] = this.password;
    // params["device_token"] = this.deviceToken;
    // params["login_type"] = "1";
    // params["device_type"] = "Android";
    return params;
  }

  // @override
  // Map<String, String> getHeaders() {
  //   Map<String, String> headers = Map<String, String>();
  //   headers["Content-Type"] = "application/json";
  // headers["Connection"] = "keep-alive";
  // headers["Accept-Encoding"] = "gzip, deflate, br";
  // headers["Accept"] = "*/*";
  // headers["User-Agent"] = "PostmanRuntime/7.26.8";
  // headers["Host"] = "<calculated when request is sent>";
  // headers["Content-Length"] = "<calculated when request is sent>";
  //   return headers;
  // }

  @override
  String parseResponse(http.Response response, bool showLog) {
    super.parseResponse(response, showLog);

    String retVal = "Problem occured in parsing the response";
    if (response.statusCode == 200) {
      try {
        Map<String, Object> responseData = jsonDecode(response.body);
        if (responseData.containsKey("status")) {
          this.response.addEntries(responseData.entries);
          retVal = "";
        }
      } catch (e) {
        retVal = e.toString();
      }
    }
    return retVal;
  }
}
