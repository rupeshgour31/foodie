import 'dart:convert';

import 'package:foodie_bell/Api/request_manager.dart';
import 'package:http/http.dart' as http;

class WSForgotPasswordTwo extends APIRequest {
  String otp;
  String password;
  String usreId;

  WSForgotPasswordTwo({
    endPoint,
    this.otp,
    this.password,
    this.usreId,
  }) : super(endPoint + "Forget_otp_verify") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["otp"] = this.otp;
    params["password"] = this.password;
    params["driver_id"] = this.usreId;
    return params;
  }

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
