import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSForgotPasswordOne.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/ForgetPassword/forgetPasswordWidgets.dart';
import 'package:foodie_bell/ForgetPassword/forgotPasswordTwo.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordOne extends StatefulWidget {
  @override
  _ForgetPasswordOneState createState() => _ForgetPasswordOneState();
}

class _ForgetPasswordOneState extends State<ForgetPasswordOne> {
  final formKey = GlobalKey<FormState>();
  forgotPasswordStepOne() async {
    progressHUD.state.show();
    var otpRequest = WSForgotPasswordOne(
      endPoint: APIManager.endpoint,
      email: forgetPassEmailId.text,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == true) {
        progressHUD.state.dismiss();
        forgetPassEmailId.clear();
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ForgetPasswordTwo(dataResponse['user_id']),
          ),
        );
      } else {
        var messages = dataResponse['msg'];
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
                    messages ?? 'Server error',
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

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: height,
            width: width,
            child: SingleChildScrollView(
              child: Stack(
                children: [
                  SizedBox(
                    height: 260,
                    width: width,
                    child: Image.asset(
                      'assets/images/Group 12570.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(left: 25.0, top: height * 0.09),
                    child: IconButton(
                      icon: Icon(
                        Icons.arrow_back_ios,
                        color: whiteColor,
                        size: 25,
                      ),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.25),
                    padding: EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      top: 25.0,
                      bottom: 30.0,
                    ),
                    height: height,
                    width: width,
                    decoration: BoxDecoration(
                      color: Color(0xffFAFCFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    child: Form(
                      key: formKey,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            'Forgot Password',
                            style: TextStyle(
                              fontSize: 25.0,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          heightSizedBox(height * 0.18),
                          forgetPassEmail(),
                          heightSizedBox(50.0),
                          submitBtn(context, formKey, forgotPasswordStepOne),
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
    );
  }
}
