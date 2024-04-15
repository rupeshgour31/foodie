import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSGetOrderHistoryRequest.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/CheckOrderStatus/checkOrderStatus.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/toast.dart';
import 'package:foodie_bell/OrderHistory/orderHistoryWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderHistory extends StatefulWidget {
  @override
  _OrderHistoryState createState() => _OrderHistoryState();
}

class _OrderHistoryState extends State<OrderHistory> {
  List ordersDetail = [
    // {
    //   'name': 'abc df dsf sdf sdf',
    //   'description': 'this item is testy delicious ',
    // },
    // {
    //   'name': 'abc',
    //   'description': 'sdff',
    // },
    // {
    //   'name': 'abc',
    //   'description': 'sdff',
    // },
  ];
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getOrderHistoryDetails();
    });
    super.initState();
  }

  getOrderHistoryDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_token = json.decode(prefs.getString('token'));
    progressHUD.state.show();
    var otpRequest = WSGetOrderHistoryRequest(
      endPoint: APIManager.endpoint,
      deviceToken: user_token,
    );
    await APIManager.performGetRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == 'true') {
        progressHUD.state.dismiss();
        setState(() {
          ordersDetail = dataResponse['data'];
        });
      } else {
        var messages = dataResponse['messages'];
        print('false data get $messages');

        progressHUD.state.dismiss();
        messages == 'No order history'
            ? Constants.showToast('No order history')
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
                    height: 250,
                    width: width,
                    child: Image.asset(
                      'assets/images/Group 12570.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 80, left: 25.0),
                    child: Row(
                      children: [
                        GestureDetector(
                          onTap: () => Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CheckOrderStatus(),
                            ),
                            (Route<dynamic> route) => false,
                          ),
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
                        widthSizedBox(50.0),
                        Text(
                          'Order History',
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
                      left: 20.0,
                      right: 20.0,
                      top: 5.0,
                      bottom: 40.0,
                    ),
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: Color(0xffFAFCFF),
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        topRight: Radius.circular(30.0),
                      ),
                    ),
                    // child: Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children: [
                    child: orderHistoryDetails(context, ordersDetail),
                    // ],
                    // ),
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
