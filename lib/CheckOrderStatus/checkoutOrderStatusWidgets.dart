import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Widget orderEarnReview(context, userProfile) {
  var size = MediaQuery.of(context).size;
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      Container(
        alignment: Alignment.center,
        height: size.height * 0.12,
        width: size.width * 0.25,
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: themeColor,
              blurRadius: 0.7,
              // offset: Offset(0.0, 25.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userProfile != null
                  ? userProfile['served_orders'].toString()
                  : '',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            heightSizedBox(5.0),
            Text(
              'Total Order',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      Container(
        height: size.height * 0.125,
        width: size.width * 0.25,
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: themeColor,
              blurRadius: 0.7,
              // offset: Offset(0.0, 25.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userProfile != null
                  ? userProfile['total_earning'].toString()
                  : '',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            heightSizedBox(5.0),
            Text(
              'Total Earn',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
      Container(
        height: size.height * 0.125,
        width: size.width * 0.25,
        decoration: BoxDecoration(
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: themeColor,
              blurRadius: 0.7,
              // offset: Offset(0.0, 25.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              userProfile != null
                  ? userProfile['total_reviews'].toString()
                  : '',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            heightSizedBox(5.0),
            Text(
              'Total Review',
              style: TextStyle(
                fontSize: 15.0,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget currentOrder(context, ordersReceived, getOrderDetails, checkAcceptable) {
  return ordersReceived.length == 0
      ? Container(
          alignment: Alignment.center,
          height: MediaQuery.of(context).size.height * 0.35,
          child: Text(
            'No orders received',
          ),
        )
      : Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Current Order',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            heightSizedBox(15.0),
            Container(
              alignment: Alignment.topCenter,
              height: ordersReceived.length > 1 ? 400 : 320.0,
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: ordersReceived.length,
                itemBuilder: (BuildContext context, int index) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          checkAcceptable(false);
                          Navigator.pushNamed(context, '/orderDetails',
                              arguments: {
                                'order_id': ordersReceived[index]['order_id'],
                              });
                        },
                        child: Container(
                          // height: MediaQuery.of(context).size.height * 0.25,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            color: whiteColor,
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey[300],
                                blurRadius: 2.5,
                                offset: Offset(0.0, 0.0),
                              ),
                            ],
                          ),
                          padding: EdgeInsets.all(8.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              heightSizedBox(8.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    ordersReceived[index]['name'] ?? '',
                                    style: TextStyle(
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  rating(ordersReceived[index]
                                          ['resturant_rating'] ??
                                      '0'),
                                ],
                              ),
                              heightSizedBox(5.0),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Flexible(
                                    child: Text(
                                      ordersReceived[index]['address'] ?? '',
                                      maxLines: 2,
                                      textAlign: TextAlign.start,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      _launched = _makePhoneCall(
                                        'tel: ${ordersReceived[index]['contact_no']}',
                                      );
                                    },
                                    child: Container(
                                      height: 30.0,
                                      width: 30.0,
                                      decoration: BoxDecoration(
                                        color: themeColor,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Center(
                                        child: Icon(
                                          Icons.call,
                                          size: 20.0,
                                          color: whiteColor,
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              heightSizedBox(15.0),
                              dividerCommon(
                                  indent: 1.0, height: 1.0, thickness: 1.0),
                              heightSizedBox(15.0),
                              Column(
                                children: [
                                  for (var i = 0;
                                      i <
                                              ordersReceived[index]['items']
                                                  .length ??
                                          0;
                                      i++) ...[
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        SizedBox(
                                          height: MediaQuery.of(context)
                                                  .size
                                                  .height *
                                              0.09,
                                          width: MediaQuery.of(context)
                                                  .size
                                                  .width *
                                              0.2,
                                          child: Image.network(
                                                'http://tenspark.com/restaurant/upload/menus/${ordersReceived[index]['items'][i]['image']}',
                                              ) ??
                                              Image.asset(
                                                'assets/images/Rectangle 18758.png',
                                                fit: BoxFit.fill,
                                              ),
                                        ),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              ordersReceived[index]['items'][i]
                                                      ['menu_name'] ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            Text(
                                              'Price \$${ordersReceived[index]['items'][i]['price']}' ??
                                                  '',
                                              style: TextStyle(
                                                fontSize: 12.0,
                                                fontWeight: FontWeight.w400,
                                              ),
                                              maxLines: 2,
                                              textAlign: TextAlign.start,
                                            ),
                                          ],
                                        ),
                                        Text(
                                          'Qty ${ordersReceived[index]['items'][i]['quantity']}' ??
                                              '',
                                          style: TextStyle(
                                            fontSize: 14.0,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ],
                              )
                            ],
                          ),
                        ),
                      ),
                      heightSizedBox(18.0),
                      acceptDeclineBtn(
                        context,
                        ordersReceived[index]['order_id'],
                        getOrderDetails,
                        checkAcceptable,
                      ),
                      heightSizedBox(10.0),
                      dividerCommon(
                        thickness: 0.5,
                        indent: 20.0,
                        endIndent: 20.0,
                      ),
                      heightSizedBox(
                        25.0,
                      ),
                    ],
                  );
                },
              ),
            ),
          ],
        );
}

Widget acceptDeclineBtn(context, orderId, getOrderDetails, checkAcceptable) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      GestureDetector(
        onTap: () {
          checkAcceptable(true);
          Navigator.pushNamed(context, '/orderDetails', arguments: {
            'order_id': orderId,
          });
        },
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: Color(0xffD6D5E0),
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            'Accept',
            style: TextStyle(
              color: whiteColor,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
      GestureDetector(
        onTap: () {
          getOrderDetails(orderId, '4');
        },
        child: Container(
          alignment: Alignment.center,
          height: 50.0,
          width: MediaQuery.of(context).size.width * 0.4,
          decoration: BoxDecoration(
            color: themeColor,
            borderRadius: BorderRadius.circular(30.0),
          ),
          child: Text(
            'Decline',
            style: TextStyle(
              color: whiteColor,
              fontSize: 15.0,
            ),
          ),
        ),
      ),
    ],
  );
}

Widget showHistoryView(context) {
  return Container(
    decoration: BoxDecoration(
      color: whiteColor,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0,
          offset: Offset(0.0, 0.0),
        ),
      ],
    ),
    child: ListTile(
      onTap: () {
        Navigator.pushNamed(context, '/orderHistory');
      },
      title: Text(
        'History',
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
    ),
  );
}

Widget logout(logoutUser) {
  return Container(
    decoration: BoxDecoration(
      color: whiteColor,
      boxShadow: [
        BoxShadow(
          color: Colors.grey,
          blurRadius: 5.0,
          offset: Offset(0.0, 0.0),
        ),
      ],
    ),
    child: ListTile(
      onTap: () {
        logoutUser();
      },
      title: Text(
        'Logout',
      ),
      trailing: Icon(Icons.arrow_forward_ios_outlined),
    ),
  );
}

Future<void> _launched;

Future<void> _makePhoneCall(String url) async {
  if (await canLaunch(url)) {
    await launch(url);
  } else {
    throw 'Could not launch $url';
  }
}
