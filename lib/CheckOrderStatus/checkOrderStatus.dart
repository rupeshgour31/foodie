import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSGetCurrentOrdersRequest.dart';
import 'package:foodie_bell/Api/Request/WSGetUserProfile.dart';
import 'package:foodie_bell/Api/Request/WSLogoutRequest.dart';
import 'package:foodie_bell/Api/Request/WSOrderStatusRequest.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/CheckOrderStatus/checkoutOrderStatusWidgets.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/toast.dart';
import 'package:foodie_bell/Login/loginPage.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CheckOrderStatus extends StatefulWidget {
  @override
  _CheckOrderStatusState createState() => _CheckOrderStatusState();
}

class _CheckOrderStatusState extends State<CheckOrderStatus> {
  var userProfile;
  List ordersReceived = [];
  var refreshKey = GlobalKey<RefreshIndicatorState>();
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getUserProfile();
      await getCurrentOrders();
    });
    super.initState();
  }

  Future<Null> refreshList() async {
    refreshKey.currentState?.show(atTop: false);
    await Future.delayed(
      Duration(seconds: 2),
    );

    setState(
      () {
        getUserProfile();
        getCurrentOrders();
        // coursesGet = List.generate(random.nextInt(10), (i) => i);
      },
    );
    return null;
  }

  getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var us_token = json.decode(prefs.getString('token'));
    progressHUD.state.show();
    var otpRequest = WSGetUserProfile(
      endPoint: APIManager.endpoint,
      deviceToken: us_token.toString(),
      // password: loginPassword.text,
      // deviceToken: androidInfo.id,
    );
    await APIManager.performGetRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == true) {
        progressHUD.state.dismiss();
        setState(() {
          userProfile = dataResponse['data'];
        });
        prefs.setString(
          'userName',
          json.encode(
            userProfile['name'],
          ),
        );
        prefs.setString(
          'userImage',
          json.encode(
            userProfile['image'],
          ),
        );
        prefs.setString(
          'userImageUrl',
          json.encode(
            userProfile['image_path'],
          ),
        );
      } else {
        var messages = dataResponse['messages'];

        progressHUD.state.dismiss();
        messages == 'No orders'
            ? Constants.showToast('No orders')
            : showDialog(
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

  getCurrentOrders() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_token = json.decode(prefs.getString('token'));
    progressHUD.state.show();
    var otpRequest = WSGetCurrentOrdersRequest(
      endPoint: APIManager.endpoint,
      deviceToken: user_token.toString(),
      // password: loginPassword.text,
      // deviceToken: androidInfo.id,
    );
    await APIManager.performGetRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == 'true') {
        progressHUD.state.dismiss();
        setState(() {
          ordersReceived = dataResponse['data'];
        });
      } else {
        var messages = dataResponse['messages'];

        progressHUD.state.dismiss();
        messages == 'No orders'
            ? Constants.showToast('No orders')
            : showDialog(
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

  getOrderDetails(orderNo, status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_token = json.decode(prefs.getString('token'));
    progressHUD.state.show();
    var otpRequest = WSOrderStatusRequest(
      endPoint: APIManager.endpoint,
      device_token: user_token,
      order_no: orderNo.toString(),
      status: status.toString(),
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == 'true') {
        progressHUD.state.dismiss();
        if (status == '1') {
          Navigator.pushNamed(context, '/orderDetails', arguments: {
            'order_id': orderNo,
          });
        }
        refreshList();
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

  logoutUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_token = json.decode(prefs.getString('token'));
    progressHUD.state.show();
    var otpRequest = WSLogoutRequest(
      endPoint: APIManager.endpoint,
      deviceToken: user_token,
    );
    await APIManager.performGetRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == true) {
        prefs?.setBool("isLoggedIn", false);
        progressHUD.state.dismiss();
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
          (Route<dynamic> route) => false,
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

  void checkAcceptable(value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs?.setBool("orderAccept", value);
  }

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return SafeArea(
      child: Scaffold(
        body: RefreshIndicator(
          key: refreshKey,
          child: Stack(
            children: [
              Container(
                height: height,
                width: width,
                child: SingleChildScrollView(
                  child: Stack(
                    children: [
                      SizedBox(
                        height: 270,
                        width: width,
                        child: Image.asset(
                          'assets/images/Group 12570.png',
                          fit: BoxFit.fill,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 45, left: 20.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: height * 0.1,
                              width: width * 0.18,
                              child: userProfile != null &&
                                      userProfile['image'] != ''
                                  ? Image.network(
                                      '${userProfile['image_path']}${userProfile['image']}')
                                  : Image.asset(
                                      'assets/images/user.png',
                                      fit: BoxFit.fill,
                                    ),
                            ),
                            widthSizedBox(8.0),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                heightSizedBox(15.0),
                                Text(
                                  userProfile != null
                                      ? userProfile['name']
                                      : '',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                                Text(
                                  'Food delivery',
                                  style: TextStyle(
                                    fontSize: 15.0,
                                    fontWeight: FontWeight.w400,
                                  ),
                                  maxLines: 2,
                                  textAlign: TextAlign.start,
                                ),
                              ],
                            )
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(top: height * 0.2),
                        padding: EdgeInsets.only(
                          left: 25.0,
                          right: 25.0,
                          top: 45.0,
                          bottom: 30.0,
                        ),
                        // height: ,
                        width: width,
                        decoration: BoxDecoration(
                          color: Color(0xffFAFCFF),
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(30.0),
                            topRight: Radius.circular(30.0),
                          ),
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            orderEarnReview(context, userProfile),
                            heightSizedBox(25.0),
                            currentOrder(
                              context,
                              ordersReceived,
                              getOrderDetails,
                              checkAcceptable,
                            ),
                            heightSizedBox(25.0),
                            showHistoryView(context),
                            heightSizedBox(25.0),
                            logout(logoutUser),
                            // heightSizedBox(25.0),
                            // GestureDetector(
                            //     onTap: () => Navigator.push(
                            //           context,
                            //           MaterialPageRoute(
                            //             builder: (context) => MapTest(),
                            //           ),
                            //         ),
                            //     child: Text('test'))
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
              progressHUD,
            ],
          ),
          onRefresh: refreshList,
        ),
      ),
    );
  }
}
