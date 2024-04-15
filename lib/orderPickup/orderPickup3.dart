import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/geoLocation.dart';
import 'package:foodie_bell/orderPickup/orderPickupWidgets.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPickupThree extends StatefulWidget {
  @override
  _OrderPickupThreeState createState() => _OrderPickupThreeState();
}

class _OrderPickupThreeState extends State<OrderPickupThree> {
  CameraPosition _kGooglePlex;
  Set<Marker> _markers = {};
  Completer<GoogleMapController> _controller = Completer();
  var userName;
  var userImage;
  var userImageUrl;
  var shopUser;
  var userLat;
  var userLong;
  var shopLat;
  var shopLong;

  var myMarkers = HashSet<Marker>();
  List<Polyline> myPolyline = [];
  LatLng currentPostion;
  BitmapDescriptor customIcon1;
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;

  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getLocation();
      await getUserProfile();
      await createPolyline();
      await createMarker();
    });
    super.initState();
  }

  @override
  getUserProfile() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    var status = prefs.getBool('isLoggedIn') ?? false;
    if (status) {
      setState(() {
        userName = json.decode(prefs.getString('userName'));
        userImageUrl = json.decode(prefs.getString('userImageUrl'));
        userImage = json.decode(prefs.getString('userImage'));
        shopUser = json.decode(prefs.getString('shopUser'));
        userLat = json.decode(prefs.getString('userLat'));
        userLong = json.decode(prefs.getString('userLong'));
        shopLat = json.decode(prefs.getString('shopLat'));
        shopLong = json.decode(prefs.getString('shopLong'));
      });
      print('shopUser shopUser ${shopUser}');
    }
  }

  createPolyline() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(2, 2)),
      'assets/images/drB.png',
    );
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5, size: Size(2, 2)),
      'assets/images/shB.png',
    );
    setState(() {
      currentPostion = LatLng(
        double.parse(shopLat),
        double.parse(shopLong),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('sourcePin'),
          position: LatLng(
            double.parse(shopLat),
            double.parse(shopLong),
          ),
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
            double.parse(userLat),
            double.parse(userLong),
          ),
          infoWindow: InfoWindow(
            title: shopUser['uname'],
            snippet: shopUser['ucontact'],
          ),
          // icon: destinationIcon,
        ),
      );
    });
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
            double.parse(shopLat),
            double.parse(shopLong),
          ),
          LatLng(
            double.parse(userLat),
            double.parse(userLong),
          ),
        ],
      ),
    );
  }

  createMarker() {
    if (customIcon1 == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);

      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/10.png')
          .then((icon) {
        setState(() {
          customIcon1 = icon;
        });
      });
    }
  }

  @override
  getLocation() async {
    var location = await GeoLocation.getCurrentLocation(context);
    var locationOn = await latLongMaps(location);

    setState(() {
      _kGooglePlex = CameraPosition(
        target: LatLng(
          double.parse(locationOn['latitude']),
          double.parse(locationOn['longitude']),
        ),
        tilt: 59.440717697143555,
        bearing: 192.8334901395799,
        zoom: 19.151926040649414,
      );
      _markers.clear();
      final marker = Marker(
        markerId: MarkerId('My Location'),
        position: LatLng(
          double.parse(locationOn['latitude']),
          double.parse(locationOn['longitude']),
        ),
        infoWindow: InfoWindow(),
      );
      // _markers['My Location'] = marker;
    });
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
                          // myLocationEnabled: true,
                          mapType: MapType.normal,
                          markers: _markers,
                          myLocationButtonEnabled: false,
                          // zoomControlsEnabled: false,
                          initialCameraPosition: CameraPosition(
                            target: currentPostion,
                            zoom: 10,
                          ),
                          polylines: myPolyline.toSet(),
                          onMapCreated: (GoogleMapController controller) {
                            setState(() {
                              myMarkers.add(
                                Marker(
                                  markerId: MarkerId('1'),
                                  position: currentPostion,
                                  // icon: customIcon1,
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
                                    userName,
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
                            top: MediaQuery.of(context).size.height * 0.54,
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
                                color: Colors.transparent,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    customerDetailView(context, shopUser),
                                    heightSizedBox(15.0),
                                    GestureDetector(
                                      onTap: () {
                                        Navigator.pushNamed(
                                            context, '/payAndDeliver');
                                      },
                                      child: Container(
                                        alignment: Alignment.center,
                                        height: 50.0,
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.75,
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
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.grey[300],
                                              blurRadius: 3.5,
                                              offset: Offset(0.0, 2.0),
                                            ),
                                          ],
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                        child: Text(
                                          'Delivery',
                                          style: TextStyle(
                                            fontSize: 15.0,
                                          ),
                                        ),
                                      ),
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
