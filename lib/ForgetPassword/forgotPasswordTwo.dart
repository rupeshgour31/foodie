import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSForgotPasswordOne.dart';
import 'package:foodie_bell/Api/Request/WSForgotPasswordTwo.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/toast.dart';
import 'package:foodie_bell/ForgetPassword/forgetPasswordWidgets.dart';
import 'package:foodie_bell/Login/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgetPasswordTwo extends StatefulWidget {
  final userId;
  ForgetPasswordTwo(this.userId);
  @override
  _ForgetPasswordTwoState createState() => _ForgetPasswordTwoState();
}

class _ForgetPasswordTwoState extends State<ForgetPasswordTwo> {
  final formKey = GlobalKey<FormState>();
  forgotPasswordStepTwo() async {
    progressHUD.state.show();
    var otpRequest = WSForgotPasswordTwo(
      endPoint: APIManager.endpoint,
      password: forgetPassSet.text,
      otp: forgetPassMobile.text,
      usreId: widget.userId,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == true) {
        progressHUD.state.dismiss();
        forgetPassSet.clear();
        forgetPassMobile.clear();
        Constants.showToast('Password changed.');
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else {
        var messages = dataResponse['messages'];
        print('false data get $messages');

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
                    messages ?? '',
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
                          forgetPassOtp(),
                          heightSizedBox(15.0),
                          forgetPassEnter(),
                          heightSizedBox(50.0),
                          forgotPassBtn(
                            context,
                            formKey,
                            forgotPasswordStepTwo,
                          ),
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
