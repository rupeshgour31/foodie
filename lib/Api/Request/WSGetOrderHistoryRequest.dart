import 'dart:convert';

import 'package:foodie_bell/Api/request_manager.dart';
import 'package:http/http.dart' as http;

class WSGetOrderHistoryRequest extends APIRequest {
  String deviceToken;

  WSGetOrderHistoryRequest({
    endPoint,
    this.deviceToken,
  }) : super(endPoint + "Order_history") {}

  @override
  Map<String, String> getHeaders() {
    Map<String, String> headers = Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = "Bearer ${deviceToken}";
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
