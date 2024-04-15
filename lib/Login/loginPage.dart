import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSLoginRequest.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Login/loginWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final formKey = GlobalKey<FormState>();
  signInRequest() async {
    // DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    // AndroidDeviceInfo androidInfo = await deviceInfo.androidInfo;
    progressHUD.state.show();
    var otpRequest = WSLoginRequest(
      endPoint: APIManager.endpoint,
      email: loginEmail.text,
      password: loginPassword.text,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('get api response ${dataResponse}');
      if (dataResponse['status'] == true) {
        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString(
          'login_user_id',
          json.encode(
            dataResponse['user_id'],
          ),
        );
        prefs.setString(
          'token',
          json.encode(
            dataResponse['token'],
          ),
        );
        prefs?.setBool("isLoggedIn", true);
        progressHUD.state.dismiss();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/checkOrderStatus',
          (Route<dynamic> route) => false,
        );
        // Navigator.pushAndRemoveUntil(
        //   context,
        //   MaterialPageRoute(
        //     builder: (context) => ServiceSelect(),
        //   ),
        //       (Route<dynamic> route) => false,
        // );

        setState(() {
          loginEmail.clear();
          loginPassword.clear();
        });
        // Navigator.of(context).pushNamedAndRemoveUntil(
        //   HomePage.routeName,
        //   (Route<dynamic> route) => false,
        //   arguments: {'print_type': 'express_print'},
        // );
      } else {
        var messages = dataResponse['message'];
        progressHUD.state.dismiss();
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: new Text('Message'),
              content: Row(
                children: [
                  Icon(
                    Icons.error_outline,
                    color: Colors.red,
                  ),
                  widthSizedBox(5.0),
                  Text(
                    messages ?? 'server error',
                    textAlign: TextAlign.center,
                    maxLines: 2,
                    // overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
              actions: <Widget>[
                FlatButton(
                  child: new Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
      }
    } catch (e) {
      print('Error: ${e.toString()}');
    }
  }

  var _blankFocusNode = new FocusNode();
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          FocusScope.of(context).requestFocus(_blankFocusNode);
        },
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Container(
                height: height,
                width: width,
                color: whiteColor,
                child: Column(
                  children: [
                    Stack(
                      alignment: Alignment.topCenter,
                      children: [
                        SizedBox(
                          height: height * 0.4,
                          width: width,
                          child: Image.asset(
                            'assets/images/Vector 6 copy.png',
                            fit: BoxFit.fill,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(top: 160.0),
                          child: Container(
                            height: height * 0.2,
                            width: width * 0.5,
                            decoration: BoxDecoration(
                              color: whiteColor,
                              borderRadius: BorderRadius.circular(20.0),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 30.0,
                                  offset: Offset(0.0, 25.0),
                                ),
                              ],
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  height: height * 0.1,
                                  width: width * 0.2,
                                  child: Image.asset(
                                    'assets/images/Group 12592.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                                SizedBox(
                                  height: height * 0.03,
                                  width: width * 0.25,
                                  child: Image.asset(
                                    'assets/images/Foodie Bell.png',
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Form(
                        key: formKey,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            heightSizedBox(30.0),
                            signInEmail(),
                            heightSizedBox(20.0),
                            signInPassword(),
                            heightSizedBox(20.0),
                            forgotPassword(context),
                            heightSizedBox(30.0),
                            loginBtn(context, formKey, signInRequest),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            progressHUD,
          ],
        ),
      ),
    );
  }
}
