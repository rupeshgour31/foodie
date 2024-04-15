import 'dart:convert';

import 'package:foodie_bell/Api/request_manager.dart';
import 'package:http/http.dart' as http;

class WSRatingPerson extends APIRequest {
  String userId;
  String orderNo;
  String rate;
  String review;
  String deviceToken;

  WSRatingPerson({
    endPoint,
    this.userId,
    this.orderNo,
    this.rate,
    this.review,
    this.deviceToken,
  }) : super(endPoint + "rate_customer") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["user_id"] = this.userId;
    params["order_no"] = this.orderNo;
    params["rate"] = this.rate;
    params["review"] = this.review;
    // params["device_type"] = "Android";
    return params;
  }

  // @override
  Map<String, String> getHeaders() {
    Map<String, String> headers = Map<String, String>();
    headers["Content-Type"] = "application/json";
    headers["Authorization"] = "Bearer  ${deviceToken}";

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
