import 'package:flutter/material.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Widget orderAndRestourant(context, shopUser) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.25,
    width: MediaQuery.of(context).size.height * 0.45,
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
    child: SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heightSizedBox(8.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                shopUser['name'] ?? '',
              ),
              rating(shopUser['resturant_rating'] ?? 0),
            ],
          ),
          heightSizedBox(5.0),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Flexible(
                child: Text(
                  shopUser['address'] ?? '',
                  maxLines: 2,
                  textAlign: TextAlign.start,
                ),
              ),
              GestureDetector(
                onTap: () {
                  _launched = _makePhoneCall(
                    'tel: ${shopUser['contact_no']}',
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
          dividerCommon(indent: 1.0, height: 1.0, thickness: 1.0),
          heightSizedBox(15.0),
          shopUser != null
              ? Column(
                  children: [
                    for (var i = 0; i < shopUser['items'].length ?? 0; i++) ...[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: MediaQuery.of(context).size.height * 0.07,
                            width: MediaQuery.of(context).size.width * 0.2,
                            child: Image.network(
                                  'http://tenspark.com/restaurant/upload/menus/${shopUser['items'][i]['image']}',
                                ) ??
                                Image.asset(
                                  'assets/images/Rectangle 18758.png',
                                  fit: BoxFit.fill,
                                ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                shopUser['items'][i]['menu_name'] ?? '',
                                style: TextStyle(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                'Price \$${shopUser['items'][i]['price']}' ??
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
                            'Qty ${shopUser['items'][i]['quantity']}' ?? '',
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
              : Text('')
        ],
      ),
    ),
  );
}

Widget customerDetailView(context, shopUser) {
  return Container(
    height: MediaQuery.of(context).size.height * 0.12,
    width: MediaQuery.of(context).size.height * 0.45,
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
    padding: EdgeInsets.all(10.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              shopUser['uname'] ?? '',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            GestureDetector(
              onTap: () {
                _launched = _makePhoneCall(
                  'tel: ${shopUser['ucontact']}',
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
        Flexible(
          child: Text(
            shopUser['uaddress'] ?? '',
            maxLines: 2,
            textAlign: TextAlign.start,
          ),
        ),
      ],
    ),
  );
}

Widget restourantDelivery(context) {
  return Padding(
    padding: const EdgeInsets.only(left: 30.0, right: 30.0),
    child: Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              margin: EdgeInsets.only(top: 25.0),
              height: 15.0,
              width: 15.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '15 min',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25.0),
                  height: 1.0,
                  width: MediaQuery.of(context).size.width * 0.34,
                  color: Colors.grey,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 25.0),
              height: 15.0,
              width: 15.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.grey,
              ),
            ),
            Stack(
              alignment: Alignment.center,
              children: [
                Text(
                  '25 min',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 25.0),
                  height: 1.0,
                  width: MediaQuery.of(context).size.width * 0.34,
                  color: Colors.grey,
                ),
              ],
            ),
            Container(
              margin: EdgeInsets.only(top: 25.0),
              height: 15.0,
              width: 15.0,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.green,
              ),
            ),
          ],
        ),
        heightSizedBox(10.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'You',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Restaurant',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              'Customer',
              style: TextStyle(
                fontSize: 15.0,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        )
      ],
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
