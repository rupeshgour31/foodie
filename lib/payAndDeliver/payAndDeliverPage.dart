import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSOrderStatusRequest.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/payAndDeliver/payAndDeliverWidgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PayAndDeliver extends StatefulWidget {
  @override
  _PayAndDeliverState createState() => _PayAndDeliverState();
}

class _PayAndDeliverState extends State<PayAndDeliver> {
  var userName;
  var userImage;
  var userImageUrl;
  var shopUser;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getUserProfile();
    });
    super.initState();
  }

  getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(() {
        userName = json.decode(prefs.getString('userName'));
        userImageUrl = json.decode(prefs.getString('userImageUrl'));
        userImage = json.decode(prefs.getString('userImage'));
        shopUser = json.decode(prefs.getString('shopUser'));
      });
      print('sdfkldsflds ${shopUser}');
    }
  }

  updateOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_token = json.decode(prefs.getString('token'));
    progressHUD.state.show();
    var otpRequest = WSOrderStatusRequest(
      endPoint: APIManager.endpoint,
      device_token: user_token,
      order_no: shopUser['order_id'].toString(),
      status: '3',
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      print('false data get $dataResponse');
      if (dataResponse['status'] == 'true') {
        progressHUD.state.dismiss();
        Navigator.pushNamed(context, '/successPage');
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
            width: width,
            padding: EdgeInsets.only(
              top: 100.0,
              left: 20.0,
              right: 20.0,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                deliveryPerson(
                  context,
                  userName,
                  userImageUrl,
                  userImage,
                ),
                heightSizedBox(45.0),
                paymentTypeSelecet(context),
                heightSizedBox(30.0),
                paymentDetails(context, shopUser),
                heightSizedBox(30.0),
                successDeliveryBtn(context, updateOrderDetails),
              ],
            ),
          ),
          progressHUD,
        ],
      ),
    );
  }
}
