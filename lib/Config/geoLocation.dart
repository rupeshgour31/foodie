import 'package:foodie_bell/Config/flushBar.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocation {
  // check location service is enable or not?
  static locationAvailable() async {
    bool isLocationSerEnabled;
    isLocationSerEnabled = await isLocationServiceEnabled();
    return isLocationSerEnabled;
  }

  // to check the GPS permission
  static getPermission() async {
    LocationPermission chkPermission = await checkPermission();
    // LocationPermission.whileInUse
    // LocationPermission.always
    // LocationPermission.denied
    if (chkPermission == LocationPermission.denied) {
      await requestPermission();
    }
  }

  // to calculate the current location
  static getCurrentLocation(context) async {
    // await openAppSettings();
    // await openLocationSettings();

    // check services enable or not
    var geoAvailable = await locationAvailable();

    if (geoAvailable) {
      // check permission
      await getPermission();

      Position position;
      try {
        position =
            await getCurrentPosition(desiredAccuracy: LocationAccuracy.best);
      } catch (e) {
        position = await getLastKnownLocation();
      }
      return position;
    } else {
      var flushBarMsg = FlushBarMessage();

      flushBarMsg.showflushBarMessage(
          context, 'Geo-Location service is not available', 'error');

      return 'no-service';
    }
  }

  // to calculate the last known location
  static getLastKnownLocation() async {
    Position position;
    try {
      position = await getLastKnownPosition();
    } catch (e) {
      print(e);
    }
    return position;
  }
}
