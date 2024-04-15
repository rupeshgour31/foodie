import 'dart:convert';

import 'package:android_intent/android_intent.dart';
import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSOrderDetailsRequest.dart';
import 'package:foodie_bell/Api/Request/WSOrderStatusRequest.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/OrderDetails/orderDetailsWidgets.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderDetails extends StatefulWidget {
  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getOrderDetails();
    });
    super.initState();
  }

  bool isAccept = false;

  var getOrderId;
  var getOrderDetail;
  getOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_token = json.decode(prefs.getString('token'));
    setState(() {
      isAccept = prefs.getBool('orderAccept');
    });
    progressHUD.state.show();
    var otpRequest = WSOrderDetailsRequest(
      endPoint: APIManager.endpoint,
      device_token: user_token,
      order_no: getOrderId,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == 'true') {
        progressHUD.state.dismiss();
        setState(() {
          getOrderDetail = dataResponse['data'];
        });
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
  void setLatLong(status) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(
      'userLat',
      json.encode(
        getOrderDetail != null ? getOrderDetail['ulat'] : '',
      ),
    );
    prefs.setString(
      'userLong',
      json.encode(
        getOrderDetail != null ? getOrderDetail['ulong'] : '',
      ),
    );
    prefs.setString(
      'shopLat',
      json.encode(
        getOrderDetail != null ? getOrderDetail['lat'] : '',
      ),
    );
    prefs.setString(
      'shopLong',
      json.encode(
        getOrderDetail != null ? getOrderDetail['long'] : '',
      ),
    );
    prefs.setString(
      'shopUser',
      json.encode(
        getOrderDetail != null ? getOrderDetail : '',
      ),
    );
    var user_token = json.decode(prefs.getString('token'));
    progressHUD.state.show();
    var otpRequest = WSOrderStatusRequest(
      endPoint: APIManager.endpoint,
      device_token: user_token,
      order_no: getOrderDetail['order_id'].toString(),
      status: status,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == 'true') {
        progressHUD.state.dismiss();
        if (status == '1') {
          if (await Permission.locationAlways.serviceStatus.isEnabled) {
            Navigator.pushNamed(context, '/orderPickupOne');
          } else {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Can't get gurrent location"),
                    content: const Text(
                        'Please make sure you enable GPS and try again'),
                    actions: <Widget>[
                      FlatButton(
                          child: Text('Ok'),
                          onPressed: () {
                            final AndroidIntent intent = AndroidIntent(
                                action:
                                    'android.settings.LOCATION_SOURCE_SETTINGS');
                            intent.launch();
                            Navigator.of(context, rootNavigator: true).pop();
                          })
                    ],
                  );
                });
          }
        } else {
          Navigator.pushNamedAndRemoveUntil(
            context,
            '/checkOrderStatus',
            (Route<dynamic> route) => false,
          );
        }
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
    final Map product = ModalRoute.of(context).settings.arguments;
    print('order details check arguments ${product}');
    setState(() {
      getOrderId = product['order_id'];
    });
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
                    height: 250,
                    width: width,
                    child: Image.asset(
                      'assets/images/Group 12570.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50, left: 25.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pop(context),
                          child: Container(
                            height: height * 0.05,
                            width: width * 0.1,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              color: whiteColor,
                            ),
                            child: Center(
                              child: Icon(
                                Icons.arrow_back_ios_outlined,
                                color: Colors.black,
                                size: 18.0,
                              ),
                            ),
                          ),
                        ),
                        widthSizedBox(25.0),
                        Text(
                          'Order Detail',
                          style: TextStyle(
                            fontSize: 20.0,
                            color: whiteColor,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    margin: EdgeInsets.only(top: height * 0.2),
                    padding: EdgeInsets.only(
                      left: 25.0,
                      right: 25.0,
                      top: 45.0,
                      bottom: 40.0,
                    ),
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
                        orderNoShow(context, getOrderDetail),
                        heightSizedBox(30.0),
                        distanceNavigator(context, getOrderDetail),
                        heightSizedBox(30.0),
                        cafeDetail(context, getOrderDetail),
                        heightSizedBox(30.0),
                        customerDetail(context, getOrderDetail),
                        heightSizedBox(30.0),
                        chargesApplied(context, getOrderDetail),
                        heightSizedBox(30.0),
                        acceptDecline(context, setLatLong, isAccept),
                      ],
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
