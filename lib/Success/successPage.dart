import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSRatingPerson.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:smooth_star_rating/smooth_star_rating.dart';

class SuccessPage extends StatefulWidget {
  @override
  _SuccessPageState createState() => _SuccessPageState();
}

class _SuccessPageState extends State<SuccessPage> {
  var rating = 0.0;
  var shopUser;
  var user_token;
  TextEditingController reviewController = TextEditingController();
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getUserProfile();
    });
    super.initState();
  }

  @override
  getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(() {
        // userName = json.decode(prefs.getString('userName'));
        // userImageUrl = json.decode(prefs.getString('userImageUrl'));
        // userImage = json.decode(prefs.getString('userImage'));
        user_token = json.decode(prefs.getString('token'));
        shopUser = json.decode(prefs.getString('shopUser'));
      });
      print('shopUser shopUser ${shopUser}');
    }
  }

  void ratingCustomer() async {
    progressHUD.state.show();
    var otpRequest = WSRatingPerson(
      endPoint: APIManager.endpoint,
      userId: shopUser['uid'].toString(),
      deviceToken: user_token,
      orderNo: shopUser['order_id'].toString(),
      rate: rating.toString(),
      review: reviewController.text,
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['status'] == 'true') {
        progressHUD.state.dismiss();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/checkOrderStatus',
          (Route<dynamic> route) => false,
        );
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              width: double.infinity,
              child: Stack(
                alignment: Alignment.topCenter,
                children: [
                  SizedBox(
                    height: 300,
                    width: double.infinity,
                    child: Image.asset(
                      'assets/images/delivery bg.png',
                      fit: BoxFit.fill,
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.only(top: 150, bottom: 50.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(
                          alignment: Alignment.center,
                          height: 110.0,
                          width: 110.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff33B71E),
                          ),
                          child: Icon(
                            Icons.check,
                            size: 75,
                            color: whiteColor,
                          ),
                        ),
                        heightSizedBox(20.0),
                        Text(
                          'Payment Received',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        heightSizedBox(15.0),
                        Text(
                          'You Got',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        heightSizedBox(10.0),
                        Text(
                          '\$50',
                          style: TextStyle(
                            fontSize: 18,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        heightSizedBox(15.0),
                        dividerCommon(
                          height: 1.0,
                          thickness: 1.0,
                          indent: 40.0,
                          endIndent: 40.0,
                        ),
                        heightSizedBox(15.0),
                        Text(
                          'Rate The Customer',
                          style: TextStyle(
                            fontSize: 15,
                            color: Colors.grey,
                            fontWeight: FontWeight.w600,
                            fontFamily: 'Nunito',
                          ),
                        ),
                        heightSizedBox(25.0),
                        Padding(
                          padding:
                              const EdgeInsets.only(left: 15.0, right: 15.0),
                          child: SmoothStarRating(
                            rating: rating,
                            isReadOnly: false,
                            size: 40,
                            color: themeColor,
                            borderColor: Colors.grey,
                            filledIconData: Icons.star,
                            halfFilledIconData: Icons.star_half,
                            defaultIconData: Icons.star,
                            starCount: 5,
                            allowHalfRating: true,
                            spacing: 2.0,
                            onRated: (value) {
                              print("rating value -> $value");
                            },
                          ),
                        ),
                        heightSizedBox(25.0),
                        Padding(
                          padding: const EdgeInsets.only(
                            left: 20.0,
                            right: 20.0,
                          ),
                          child: Container(
                            padding: EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              color: Color(0xffFAFCFF),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 10.0,
                                  // offset: Offset(0.0, 2.0),
                                ),
                              ],
                            ),
                            child: TextFormField(
                              minLines: 4,
                              controller: reviewController,
                              keyboardType: TextInputType.multiline,
                              maxLines: null,
                              decoration: InputDecoration(
                                focusedBorder: InputBorder.none,
                                enabledBorder: InputBorder.none,
                                errorBorder: InputBorder.none,
                                disabledBorder: InputBorder.none,
                                hintText: 'Leave Comments Here...',
                              ),
                            ),
                          ),
                        ),
                        heightSizedBox(40.0),
                        GestureDetector(
                          onTap: () {
                            ratingCustomer();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            height: 48,
                            width: MediaQuery.of(context).size.width * 0.8,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50.0),
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xffDF6E3D),
                                  Color(0xffFA8B01),
                                ],
                                end: Alignment.centerRight,
                                begin: Alignment.centerLeft,
                                // tileMode: TileMode.repeated,
                              ),
                            ),
                            child: Text(
                              'Submit',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w500,
                                color: whiteColor,
                              ),
                            ),
                          ),
                        ),
                        heightSizedBox(18.0),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamedAndRemoveUntil(
                              context,
                              '/checkOrderStatus',
                              (Route<dynamic> route) => false,
                            );
                          },
                          child: Text(
                            'Skip Rating',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                              fontFamily: 'Nunito',
                            ),
                          ),
                        ),
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
