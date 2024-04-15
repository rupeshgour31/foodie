import 'dart:async';
import 'dart:collection';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapTest extends StatefulWidget {
  @override
  _MapTestState createState() => _MapTestState();
}

class _MapTestState extends State<MapTest> {
  var myMarkers = HashSet<Marker>();
  BitmapDescriptor customerMarker;
  List<Polyline> myPolyline = [];
  Position _currentPosition;
  String _startAddress = '';
  String _currentAddress;
  LatLng currentPostion;
  Set<Marker> _markers = {};
  BitmapDescriptor sourceIcon;
  BitmapDescriptor destinationIcon;
  @override
  void initState() {
    Future.delayed(Duration.zero, () async {
      await createPolyline();
    });
    super.initState();
  }

  createPolyline() async {
    sourceIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 2.5),
      'assets/images/driver.jpg',
    );
    destinationIcon = await BitmapDescriptor.fromAssetImage(
      ImageConfiguration(devicePixelRatio: 5.5),
      'assets/images/rest.png',
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
        ),
      );
      _markers.add(
        Marker(
          markerId: MarkerId('destPin'),
          // position: LatLng(22.724355, 75.8838944),
          icon: destinationIcon,
        ),
      );
    });
    print('START COORDINATES: $position');
    myPolyline.add(
      Polyline(
        polylineId: PolylineId('1'),
        color: Colors.purple,
        width: 3,
        jointType: JointType.round,
        startCap: Cap.customCapFromBitmap(BitmapDescriptor.defaultMarker),
        endCap:
            Cap.customCapFromBitmap(BitmapDescriptor.defaultMarkerWithHue(90)),
        points: [
          LatLng(
            position.latitude,
            position.longitude,
          ),
          LatLng(22.724355, 75.8838944),
        ],
      ),
    );
  }

  BitmapDescriptor customIcon1;

  createMarker(context) {
    if (customIcon1 == null) {
      ImageConfiguration configuration = createLocalImageConfiguration(context);

      BitmapDescriptor.fromAssetImage(configuration, 'assets/images/Vector.png')
          .then((icon) {
        setState(() {
          customIcon1 = icon;
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // print('location lat long ${sourceDestinationMarkers}');
    return Scaffold(
      body: Stack(
        children: [
          Stack(
            children: [
              GoogleMap(
                initialCameraPosition: CameraPosition(
                  target: currentPostion,
                  zoom: 14,
                ),
                markers: _markers,
                myLocationEnabled: true,
                myLocationButtonEnabled: false,
                mapType: MapType.normal,
                zoomGesturesEnabled: true,
                zoomControlsEnabled: false,
                polylines: myPolyline.toSet(),
                onMapCreated: (GoogleMapController controller) {
                  setState(() {
                    myMarkers.add(
                      Marker(
                        markerId: MarkerId('1'),
                        position: LatLng(29.990940, 31.149248),
                        icon: customIcon1,
                      ),
                    );
                  });
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
