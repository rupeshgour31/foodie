import 'dart:convert';

import 'package:foodie_bell/Api/request_manager.dart';
import 'package:http/http.dart' as http;

class WSUpdateOrderRequest extends APIRequest {
  String order_no;
  String status;
  String token;

  WSUpdateOrderRequest({
    endPoint,
    this.order_no,
    this.status,
    this.token,
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
    headers['Authorization'] =
        'Bearer f225f963a8866da21e5920951c200f8546c09b08da8d612de3d4d828784e5e69';
    return headers;
  }

  @override
  String parseResponse(http.Response response, bool showLog) {
    super.parseResponse(response, showLog);

    String retVal = "Problem occured in parsing the response";
    if (response.statusCode == 200) {
      try {
        Map<String, Object> responseData = jsonDecode(response.body);

        if (responseData.containsKey("success")) {
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
