import 'dart:async';
import 'dart:collection';
import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_polyline_points/flutter_polyline_points.dart';
import 'package:foodie_bell/Config/common_widgets.dart';
import 'package:foodie_bell/Config/secrets.dart';
import 'package:foodie_bell/orderPickup/orderPickupWidgets.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OrderPickupTwo extends StatefulWidget {
  @override
  _OrderPickupTwoState createState() => _OrderPickupTwoState();
}

class _OrderPickupTwoState extends State<OrderPickupTwo> {
  CameraPosition _initialLocation = CameraPosition(target: LatLng(0.0, 0.0));
  GoogleMapController mapController;

  Position _currentPosition;
  String _currentAddress;

  final startAddressController = TextEditingController();
  final destinationAddressController = TextEditingController();

  final startAddressFocusNode = FocusNode();
  final desrinationAddressFocusNode = FocusNode();

  String _startAddress = '';
  String _destinationAddress = '';
  String _placeDistance;

  Set<Marker> markers = {};
  var myMarkers = HashSet<Marker>();
  List<Polyline> myPolyline = [];
  LatLng currentPostion;
  BitmapDescriptor customIcon1;

  PolylinePoints polylinePoints;
  Map<PolylineId, Polyline> polylines = {};
  List<LatLng> polylineCoordinates = [];

  var userName;
  var userImage;
  var userImageUrl;
  var shopLat;
  var shopLong;
  // LatLng currentPostion;
  Set<Marker> _markers = {};
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await getUserProfile();
      // await getLocation();
      await _getCurrentLocation();
      await _calculateDistance();
      await createPolyline();
      await createMarker();
    });
    super.initState();
  }

  _getCurrentLocation() async {
    await Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.high)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
        print('CURRENT POS: $_currentPosition');
        mapController.animateCamera(
          CameraUpdate.newCameraPosition(
            CameraPosition(
              target: LatLng(position.latitude, position.longitude),
              zoom: 18.0,
            ),
          ),
        );
      });
      await _getAddress();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddress() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];

      setState(() {
        _currentAddress =
            "${place.name}, ${place.locality}, ${place.postalCode}, ${place.country}";
        startAddressController.text = _currentAddress;
        _startAddress = _currentAddress;
      });
    } catch (e) {
      print(e);
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

      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/00.png')
          .then((icon) {
        setState(() {
          customIcon1 = icon;
        });
      });
    }
  }

  var shopUser;
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

  Future<bool> _calculateDistance() async {
    try {
      // Retrieving placemarks from addresses
      List<Location> startPlacemark = await locationFromAddress(_startAddress);
      List<Location> destinationPlacemark =
          await locationFromAddress(_destinationAddress);

      if (startPlacemark != null && destinationPlacemark != null) {
        // Use the retrieved coordinates of the current position,
        // instead of the address if the start position is user's
        // current position, as it results in better accuracy.
        Position startCoordinates = _startAddress == _currentAddress
            ? Position(
                latitude: _currentPosition.latitude,
                longitude: _currentPosition.longitude,
              )
            : Position(
                latitude: startPlacemark[0].latitude,
                longitude: startPlacemark[0].longitude,
              );
        Position destinationCoordinates = Position(
          latitude: destinationPlacemark[0].latitude,
          longitude: destinationPlacemark[0].longitude,
        );
        print('START COORDINATES: $startCoordinates');
        // Start Location Marker
        Marker startMarker = Marker(
          markerId: MarkerId('$startCoordinates'),
          position: LatLng(
            startCoordinates.latitude,
            startCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Start',
            snippet: _startAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Destination Location Marker
        Marker destinationMarker = Marker(
          markerId: MarkerId('$destinationCoordinates'),
          position: LatLng(
            destinationCoordinates.latitude,
            destinationCoordinates.longitude,
          ),
          infoWindow: InfoWindow(
            title: 'Destination',
            snippet: _destinationAddress,
          ),
          icon: BitmapDescriptor.defaultMarker,
        );

        // Adding the markers to the list
        markers.add(startMarker);
        markers.add(destinationMarker);

        print('START COORDINATES: $startCoordinates');
        print('DESTINATION COORDINATES: $destinationCoordinates');

        Position _northeastCoordinates;
        Position _southwestCoordinates;

        // Calculating to check that the position relative
        // to the frame, and pan & zoom the camera accordingly.
        double miny =
            (startCoordinates.latitude <= destinationCoordinates.latitude)
                ? startCoordinates.latitude
                : destinationCoordinates.latitude;
        double minx =
            (startCoordinates.longitude <= destinationCoordinates.longitude)
                ? startCoordinates.longitude
                : destinationCoordinates.longitude;
        double maxy =
            (startCoordinates.latitude <= destinationCoordinates.latitude)
                ? destinationCoordinates.latitude
                : startCoordinates.latitude;
        double maxx =
            (startCoordinates.longitude <= destinationCoordinates.longitude)
                ? destinationCoordinates.longitude
                : startCoordinates.longitude;

        _southwestCoordinates = Position(latitude: miny, longitude: minx);
        _northeastCoordinates = Position(latitude: maxy, longitude: maxx);

        // Accommodate the two locations within the
        // camera view of the map
        mapController.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast: LatLng(
                _northeastCoordinates.latitude,
                _northeastCoordinates.longitude,
              ),
              southwest: LatLng(
                _southwestCoordinates.latitude,
                _southwestCoordinates.longitude,
              ),
            ),
            100.0,
          ),
        );

        await _createPolylines(startCoordinates, destinationCoordinates);

        double totalDistance = 0.0;

        // Calculating the total distance by adding the distance
        // between small segments
        for (int i = 0; i < polylineCoordinates.length - 1; i++) {
          totalDistance += _coordinateDistance(
            polylineCoordinates[i].latitude,
            polylineCoordinates[i].longitude,
            polylineCoordinates[i + 1].latitude,
            polylineCoordinates[i + 1].longitude,
          );
        }
        setState(() {
          _placeDistance = totalDistance.toStringAsFixed(2);
          print('DISTANCE: $_placeDistance km');
        });

        return true;
      }
    } catch (e) {
      print(e);
    }
    return false;
  }

  // Formula for calculating distance between two coordinates
  // https://stackoverflow.com/a/54138876/11910277
  double _coordinateDistance(lat1, lon1, lat2, lon2) {
    var p = 0.017453292519943295;
    var c = cos;
    var a = 0.5 -
        c((lat2 - lat1) * p) / 2 +
        c(lat1 * p) * c(lat2 * p) * (1 - c((lon2 - lon1) * p)) / 2;
    return 12742 * asin(sqrt(a));
  }

  _createPolylines(Position start, Position destination) async {
    // Initializing PolylinePoints
    polylinePoints = PolylinePoints();

    // Generating the list of coordinates to be used for
    // drawing the polylines
    PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
      Secrets.API_KEY, // Google Maps API Key
      PointLatLng(start.latitude, start.longitude),
      PointLatLng(destination.latitude, destination.longitude),
      travelMode: TravelMode.transit,
    );

    // Adding the coordinates to the list
    if (result.points.isNotEmpty) {
      result.points.forEach((PointLatLng point) {
        polylineCoordinates.add(LatLng(point.latitude, point.longitude));
      });
    }

    // Defining an ID
    PolylineId id = PolylineId('poly');

    // Initializing Polyline
    Polyline polyline = Polyline(
      polylineId: id,
      color: Colors.red,
      points: polylineCoordinates,
      width: 3,
    );

    // Adding the polyline to the map
    polylines[id] = polyline;
  }

  @override
  Widget build(BuildContext context) {
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
                          zoomControlsEnabled: false,

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
                                    orderAndRestourant(context, shopUser),
                                    heightSizedBox(15.0),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Stack(
                                          children: [
                                            GestureDetector(
                                              onTap: () {
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  '/checkOrderStatus',
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
                                              },
                                              child: Container(
                                                alignment: Alignment.center,
                                                height: 50.0,
                                                width: MediaQuery.of(context)
                                                        .size
                                                        .width *
                                                    0.45,
                                                decoration: BoxDecoration(
                                                  color: whiteColor,
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey[300],
                                                      blurRadius: 3.5,
                                                      offset: Offset(0.0, 2.0),
                                                    ),
                                                  ],
                                                  borderRadius:
                                                      BorderRadius.only(
                                                    topLeft:
                                                        Radius.circular(30.0),
                                                    bottomLeft:
                                                        Radius.circular(30.0),
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
                                                Navigator
                                                    .pushNamedAndRemoveUntil(
                                                  context,
                                                  '/orderPickupThree',
                                                  (Route<dynamic> route) =>
                                                      false,
                                                );
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
