import 'package:flutter/material.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:url_launcher/url_launcher.dart';

Widget orderNoShow(context, getOrderDetail) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.57,
        padding: EdgeInsets.only(
          left: 8.0,
          right: 8.0,
          top: 10.0,
          bottom: 10.0,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 0.1,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Order Number',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '# ${getOrderDetail != null ? getOrderDetail['order_id'] : ''}',
                  style: TextStyle(
                    fontSize: 15.0,
                    color: themeColor,
                  ),
                ),
                // Text(
                //   'Cash on delivery',
                //   style: TextStyle(
                //     fontSize: 13.0,
                //     color: themeColor,
                //   ),
                // ),
              ],
            )
          ],
        ),
      ),
      Container(
        height: MediaQuery.of(context).size.height * 0.1,
        width: MediaQuery.of(context).size.width * 0.23,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5.0),
          color: whiteColor,
          boxShadow: [
            BoxShadow(
              color: Colors.grey,
              blurRadius: 0.1,
              offset: Offset(0.0, 0.0),
            ),
          ],
        ),
        child: Image.network(
          '${getOrderDetail != null ? 'http://tenspark.com/restaurant/upload/restaurant/${getOrderDetail['resturant_image']}' : ''}',
          fit: BoxFit.fill,
        ),
      ),
    ],
  );
}

Widget distanceNavigator(context, orderDetail) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            children: [
              Icon(
                Icons.circle,
                color: Colors.grey,
                size: 17.0,
              ),
              Icon(
                Icons.fiber_manual_record,
                color: Colors.grey,
                size: 5,
              ),
              Icon(
                Icons.fiber_manual_record,
                color: Colors.grey,
                size: 5,
              ),
              Icon(
                Icons.fiber_manual_record,
                color: Colors.grey,
                size: 5,
              ),
              Icon(
                Icons.location_on,
                color: themeColor,
                size: 25,
              ),
            ],
          ),
          widthSizedBox(10.0),
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                orderDetail != null ? orderDetail['name'] : '',
                style: TextStyle(
                  fontSize: 15.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
              heightSizedBox(14.0),
              Container(
                width: MediaQuery.of(context).size.width * 0.6,
                child: Text(
                  orderDetail != null ? orderDetail['uaddress'] ?? '' : '',
                  style: TextStyle(
                    fontSize: 15.0,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 2,
                ),
              ),
            ],
          )
        ],
      ),
      Text(
        orderDetail != null
            ? '${orderDetail['distance_km'].toString().substring(0, 3)} KM' ??
                ''
            : '',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w500,
        ),
      ),
    ],
  );
}

Widget cafeDetail(context, orderDetail) {
  return Container(
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
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              orderDetail != null ? orderDetail['name'] : '',
            ),
            orderDetail != null
                ? rating(orderDetail['resturant_rating'] ?? 0)
                : Text(''),
          ],
        ),
        heightSizedBox(8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Flexible(
              child: Text(
                orderDetail != null ? orderDetail['address'] : '',
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
            Container(
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
          ],
        ),
        heightSizedBox(8.0),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Preparation Time',
              maxLines: 2,
              textAlign: TextAlign.start,
            ),
            Text(
              '${orderDetail != null ? orderDetail['preparation_time_min'] : '0'} Min.',
              maxLines: 2,
              textAlign: TextAlign.start,
            ),
          ],
        ),
        heightSizedBox(15.0),
        dividerCommon(indent: 1.0, height: 1.0, thickness: 1.0),
        heightSizedBox(15.0),
        orderDetail != null
            ? Column(
                children: [
                  for (var i = 0;
                      i < orderDetail['items'].length ?? 0;
                      i++) ...[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height * 0.09,
                          width: MediaQuery.of(context).size.width * 0.2,
                          child: Image.network(
                                'http://tenspark.com/restaurant/upload/menus/${orderDetail['items'][i]['image']}',
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
                              orderDetail['items'][i]['menu_name'] ?? '',
                              style: TextStyle(
                                fontSize: 15.0,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                            Text(
                              'Price \$${orderDetail['items'][i]['price']}' ??
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
                          'Qty ${orderDetail['items'][i]['quantity']}' ?? '',
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
  );
}

Widget customerDetail(context, orderDetail) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Text(
        'Customer',
        style: TextStyle(
          fontSize: 18.0,
          fontWeight: FontWeight.w600,
        ),
      ),
      heightSizedBox(15.0),
      Container(
        height: MediaQuery.of(context).size.height * 0.12,
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
        padding: EdgeInsets.all(10.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            heightSizedBox(8.0),
            heightSizedBox(5.0),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  orderDetail != null ? orderDetail['uname'] : '',
                  style: TextStyle(
                    fontSize: 18.0,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    _launched = _makePhoneCall(
                      'tel: ${orderDetail['ucontact']}',
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
            Flexible(
              child: Text(
                orderDetail != null ? orderDetail['uaddress'] ?? '' : '',
                maxLines: 2,
                textAlign: TextAlign.start,
              ),
            ),
          ],
        ),
      ),
    ],
  );
}

Widget chargesApplied(context, orderDetail) {
  return Column(
    mainAxisAlignment: MainAxisAlignment.start,
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Late Night Surcharge',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$${orderDetail != null ? orderDetail['service_charge'] : 0}',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      heightSizedBox(10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Moving Cart',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$${orderDetail != null ? orderDetail['delivery_charge'] ?? 0 : 0}',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      heightSizedBox(10.0),
      Text(
        'Additional Services',
      ),
      heightSizedBox(5.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Discount',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$${orderDetail != null ? orderDetail['discount'] : 0}',
            style: TextStyle(
              fontSize: 15.0,
              color: themeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      heightSizedBox(5.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Including all Texes:',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$${orderDetail != null ? orderDetail['tax'] : 0}',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
      heightSizedBox(10.0),
      dividerCommon(
        height: 1.0,
        thickness: 1.0,
      ),
      heightSizedBox(10.0),
      Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            'Total',
            style: TextStyle(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            ),
          ),
          Text(
            '\$${orderDetail != null ? orderDetail['final_price'] : 0}',
            style: TextStyle(
              fontSize: 15.0,
              color: themeColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    ],
  );
}

Widget acceptDecline(context, setLatLong, isAccept) {
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    crossAxisAlignment: CrossAxisAlignment.center,
    children: [
      Stack(
        children: [
          isAccept
              ? Text('')
              : GestureDetector(
                  onTap: () {
                    setLatLong('4');
                  },
                  child: Container(
                    alignment: Alignment.center,
                    height: 50.0,
                    width: MediaQuery.of(context).size.width * 0.45,
                    decoration: BoxDecoration(
                      color: whiteColor,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey[300],
                          blurRadius: 3.5,
                          offset: Offset(0.0, 2.0),
                        ),
                      ],
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30.0),
                        bottomLeft: Radius.circular(30.0),
                      ),
                    ),
                    child: Text(
                      'Decline',
                      style: TextStyle(
                        fontSize: 15.0,
                      ),
                    ),
                  ),
                ),
          GestureDetector(
            onTap: () {
              setLatLong('1');
            },
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                left: isAccept
                    ? MediaQuery.of(context).size.width * 0
                    : MediaQuery.of(context).size.width * 0.38,
              ),
              height: 50.0,
              width: isAccept
                  ? MediaQuery.of(context).size.width * 0.6
                  : MediaQuery.of(context).size.width * 0.4,
              decoration: BoxDecoration(
                color: themeColor,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Text(
                isAccept ? 'Pick Up' : 'Accept',
                style: TextStyle(
                  color: whiteColor,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ],
      ),
    ],
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
