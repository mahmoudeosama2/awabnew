import 'package:geolocator/geolocator.dart';

double? lat = 0.0, long = 0.0;

final GeolocatorPlatform _geolocatorPlatform = GeolocatorPlatform.instance;

class Prayertime {
  double getLat() {
    return lat!;
  }

  double getLong() {
    return long!;
  }

  getusercurrentloaction() async {
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);
    lat = position.latitude;
    long = position.longitude;
    return position;
  }


}
