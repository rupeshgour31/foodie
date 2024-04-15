import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_bell/Api/Request/WSOrderStatusRequest.dart';
import 'package:foodie_bell/Api/api_manager.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/geoLocation.dart';
import 'package:foodie_bell/orderPickup/orderPickupWidgets.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPickupOne extends StatefulWidget {
  @override
  _OrderPickupOneState createState() => _OrderPickupOneState();
}

class _OrderPickupOneState extends State<OrderPickupOne> {
  CameraPosition _kGooglePlex;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  Set<Marker> sourceDestinationMarkers = {};
  var userName;
  var userImage;
  var userImageUrl;
  var shopLat;
  var shopLong;
  var shopUser;

  var myMarkers = HashSet<Marker>();
  List<Polyline> myPolyline = [];
  LatLng currentPostion;
  BitmapDescriptor customIcon1;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getUserProfile();
      await getLocation();
      await createPolyline();
      await createMarker();
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
        shopLat = json.decode(prefs.getString('shopLat'));
        shopLong = json.decode(prefs.getString('shopLong'));
      });
    }
  }

  @override
  createPolyline() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(2, 2)),
      'assets/images/drB.png',
    );
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(2, 2)),
      'assets/images/shB.png',
    );
    var position = await GeolocatorPlatform.instance
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      currentPostion = LatLng(position.latitude, position.longitude);
      _markers.add(
        Marker(
          markerId: MarkerId('sourcePin'),
          position: currentPostion,
          icon: sourceIcon,
          infoWindow: InfoWindow(
            title: userName,
            snippet: '',
          ),
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('destPin'),
          position: LatLng(
            double.parse(shopLat),
            double.parse(shopLong),
          ),
          infoWindow: InfoWindow(
            title: shopUser['name'],
            snippet: shopUser['address'],
          ),
          icon: destinationIcon,
        ),
      );
    });
    print('START COORDINATES: $position $shopLat $shopLong');
    myPolyline.add(
      Polyline(
        polylineId: PolylineId('1'),
        color: Colors.green,
        width: 3,
        // startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
        // endCap:
        //     Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(90)),
        points: [
          LatLng(
            position.latitude,
            position.longitude,
          ),
          LatLng(
            double.parse(shopLat),
            double.parse(shopLong),
          ),
        ],
      ),
    );
  }

  createMarker() {
    if (customIcon1 == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);

      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/rest.png')
          .then((icon) {
        setState(() {
          customIcon1 = icon;
        });
      });
    }
  }

  getLocation() async {
    var location = await GeoLocation.getCurrentLocation(context);
    var locationOn = await latLongMaps(location);

    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(
          double.parse(shopLat),
          double.parse(shopLong),
        ),
        zoom: 15,
      );
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId('My Location'),
        position: LatLng(
          double.parse(shopLat),
          double.parse(shopLong),
        ),
        infoWindow: InfoWindow(),
      );
      // _markers['My Location'] = marker;
    });
  }

  updateOrderDetails() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var user_token = json.decode(prefs.getString('token'));
    progressHUD.state.show();
    var otpRequest = WSOrderStatusRequest(
      endPoint: APIManager.endpoint,
      device_token: user_token,
      order_no: shopUser['order_id'].toString(),
      status: '2',
    );
    await APIManager.performRequest(otpRequest, showLog: true);
    try {
      var dataResponse = otpRequest.response;
      if (dataResponse['status'] == 'true') {
        progressHUD.state.dismiss();
        Navigator.pushNamed(
          context,
          '/orderPickupTwo',
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
    print('location lat long ${_kGooglePlex}');
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              (currentPostion != null)
                  ? Stack(
                      // alignment: Alignment.topCenter,
                      children: [
                        GoogleMap(
                          markers: _markers,
                          // myLocationEnabled: true,
                          mapType: MapType.normal,
                          myLocationButtonEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: currentPostion,
                            zoom: 8,
                          ),
                          polylines: myPolyline.toSet(),
                          onMapCreated: (GoogleMapController controller) {
                            setState(() {
                              myMarkers.add(
                                Marker(
                                  markerId: MarkerId('1'),
                                  position: currentPostion,
                                  icon: customIcon1,
                                  infoWindow: InfoWindow(),
                                ),
                              );
                            });
                          },
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            top: 70.0,
                            left: 25.0,
                            right: 25.0,
                          ),
                          padding: EdgeInsets.only(left: 20.0, right: 20.0),
                          height: 100,
                          width: double.infinity,
                          color: whiteColor,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                height: 80,
                                width: 100,
                                decoration: BoxDecoration(
                                  image: DecorationImage(
                                    image: userImage != ''
                                        ? AssetImage(
                                            '${userImageUrl}${userImage}',
                                          )
                                        : AssetImage(
                                            'assets/images/user.png',
                                          ),
                                    fit: BoxFit.fill,
                                  ),
                                  // Image.asset(
                                  //   'assets/images/Rectangle 18719.png',
                                  //   fit: BoxFit.fill,
                                  // ),
                                ),
                              ),
                              widthSizedBox(20.0),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // heightSizedBox(15.0),
                                  Text(
                                    userName ?? '',
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
                              ),
                            ],
                          ),
                        ),
                        Container(
                          alignment: Alignment.center,
                          margin: EdgeInsets.only(
                            top: 145,
                            left: MediaQuery.of(context).size.width * 0.75,
                          ),
                          height: 45.0,
                          width: 45.0,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
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
                            ' 30\nmin',
                            style: TextStyle(
                              color: whiteColor,
                            ),
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(
                            top: MediaQuery.of(context).size.height * 0.6,
                          ),
                          child: Stack(
                            alignment: Alignment.topCenter,
                            children: [
                              Container(
                                alignment: Alignment.bottomCenter,
                                margin: EdgeInsets.only(top: 40.0),
                                padding: EdgeInsets.only(bottom: 20.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.4,
                                width: double.infinity,
                                color: whiteColor,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    Text(
                                      userName ?? '',
                                      style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    heightSizedBox(10.0),
                                    restourantDelivery(context),
                                    heightSizedBox(30.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            // GestureDetector(
                                            //   onTap: () {
                                            //     Navigator
                                            //         .pushNamedAndRemoveUntil(
                                            //       context,
                                            //       '/checkOrderStatus',
                                            //       (Route<dynamic> route) =>
                                            //           false,
                                            //     );
                                            //   },
                                            //   child: Container(
                                            //     alignment: Alignment.center,
                                            //     height: 50.0,
                                            //     width: MediaQuery.of(context)
                                            //             .size
                                            //             .width *
                                            //         0.45,
                                            //     decoration: BoxDecoration(
                                            //       color: whiteColor,
                                            //       boxShadow: [
                                            //         BoxShadow(
                                            //           color: Colors.grey[300],
                                            //           blurRadius: 3.5,
                                            //           offset: Offset(0.0, 2.0),
                                            //         ),
                                            //       ],
                                            //       borderRadius:
                                            //           BorderRadius.only(
                                            //         topLeft:
                                            //             Radius.circular(30.0),
                                            //         bottomLeft:
                                            //             Radius.circular(30.0),
                                            //       ),
                                            //     ),
                                            //     child: Text(
                                            //       'Decline',
                                            //       style: TextStyle(
                                            //         fontSize: 15.0,
                                            //       ),
                                            //     ),
                                            //   ),
                                            // ),
                                            GestureDetector(
                                              onTap: () {
                                                updateOrderDetails();
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                // margin: EdgeInsets.only(
                                                //   left: MediaQuery.of(context)
                                                //           .size
                                                //           .width *
                                                //       0.38,
                                                // ),
                                                height: 50.0,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.8,
                                                decoration: BoxDecoration(
                                                  gradient: LinearGradient(
                                                    colors: [
                                                      Color(0xffDF6E3D),
                                                      Color(0xffFA8B01),
                                                    ],
                                                    end: Alignment.centerRight,
                                                    begin: Alignment.centerLeft,
                                                    // tileMode: TileMode.repeated,
                                                  ),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          30.0),
                                                ),
                                                child: Text(
                                                  'Pick Up',
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
                                    ),
                                  ],
                                ),
                              ),
                              Container(
                                alignment: Alignment.center,
                                height:
                                    MediaQuery.of(context).size.height * 0.1,
                                width:
                                    MediaQuery.of(context).size.height * 0.35,
                                padding: EdgeInsets.only(
                                  left: 25.0,
                                  right: 25.0,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
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
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '\$90',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: whiteColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Guaranteed',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: whiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                    verticalDivider(true, 50.0),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          '17 min',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: whiteColor,
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                        Text(
                                          'Total Duration',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                            color: whiteColor,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    )
                  : Center(
                      child: CircularProgressIndicator(
                        valueColor:
                            new AlwaysStoppedAnimation<Color>(themeColor),
                      ),
                    ),
            ],
          ),
          progressHUD,
        ],
      ),
    );
  }
}
