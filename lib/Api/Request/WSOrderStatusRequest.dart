import 'dart:convert';

import 'package:foodie_bell/Api/request_manager.dart';
import 'package:http/http.dart' as http;

class WSOrderStatusRequest extends APIRequest {
  String order_no;
  String device_token;
  String status;

  WSOrderStatusRequest({
    endPoint,
    this.device_token,
    this.order_no,
    this.status,
  }) : super(endPoint + "Update_orders") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["order_no"] = this.order_no;
    params["status"] = this.status;
    return params;
  }

  @override
  Map<String, String> getHeaders() {
    Map<String, String> headers = Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = "Bearer ${device_token}";
    return headers;
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
