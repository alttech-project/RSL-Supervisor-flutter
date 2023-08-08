import 'package:geolocator/geolocator.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';

class LocationManager {
  Future<LocationResult<Position>> getCurrentLocation() async {
    LocationPermission permission;

    // Request location permission
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult.failure('Location permission denied');
      }
    }

    // Get current location
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LocationResult.success(position);
    } catch (e) {
      printLogs('Error getting location: ${e.toString()}');
      return LocationResult.failure(e.toString());
    }
  }
}

class LocationResult<T> {
  final T? data;
  final String? error;

  LocationResult.success(this.data) : error = null;
  LocationResult.failure(this.error) : data = null;
}
