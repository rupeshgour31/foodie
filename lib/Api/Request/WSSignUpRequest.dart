import 'dart:convert';

import 'package:foodie_bell/Api/request_manager.dart';
import 'package:http/http.dart' as http;

class WSSignUpRequest extends APIRequest {
  String f_name;
  String l_name;
  String email;
  String password;
  String mobile;
  String address;

  WSSignUpRequest({
    endPoint,
    this.f_name,
    this.l_name,
    this.email,
    this.password,
    this.mobile,
    this.address,
  }) : super(endPoint + "user_resgister") {}

  @override
  Map<String, Object> getParams() {
    Map<String, Object> params = Map<String, Object>();
    params["f_name"] = this.f_name;
    params["email"] = this.email;
    params["password"] = this.password;
    params["l_name"] = this.l_name;
    params["mobile"] = this.mobile;
    params["address"] = this.address;
    params['latitude'] = "22.7488902";
    params['longitude'] = "75.8947843";
    return params;
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
