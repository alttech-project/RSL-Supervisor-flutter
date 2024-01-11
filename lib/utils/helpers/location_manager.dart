import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:rsl_supervisor/utils/helpers/basic_utils.dart';
import '../../routes/app_routes.dart';

class LocationManager {
  Future<LocationResult<Position>> getCurrentLocation() async {
    LocationPermission permission;

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return LocationResult.failure('Location permission denied');
      }
    }
    try {
      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );
      return LocationResult.success(position);
    } catch (e) {
      printLogs('Error getting location: ${e.toString()}');
      Get.toNamed(AppRoutes.locationPermissionDeniedPage);
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
