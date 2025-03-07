import 'package:location/location.dart';

abstract class LatLngDataSource {
  Future<LocationData> getCurrentPosition();
}

class LatLngDataSourceImpl implements LatLngDataSource {
  @override
  Future<LocationData> getCurrentPosition() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;
    LocationData locationData;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        return Future.error('Service is disabled');
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();

      if (permissionGranted != PermissionStatus.granted) {
        return Future.error('Permission is not granted');
      }
    }

    locationData = await location.getLocation();

    if (locationData.latitude == null || locationData.longitude == null) {
      return Future.error('Failed to get lat long');
    }
    return locationData;
  }
}
