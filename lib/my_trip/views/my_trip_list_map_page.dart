import 'dart:math';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_view.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:rsl_supervisor/my_trip/controller/my_trip_list_controller.dart';
import 'package:rsl_supervisor/my_trip/controller/my_trip_list_map_controller.dart';
import 'package:rsl_supervisor/shared/styles/app_color.dart';

class MyTripListMapPage extends GetView<MyTripListController> {
  const MyTripListMapPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
            color: AppColors
                .kPrimaryColor.value, // Change this to your desired color
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          title: const Text(''),
        ),
        body: Container(
          padding: const EdgeInsets.only(top: 0, left: 0, right: 0, bottom: 0),
          child: FutureBuilder<LatLngBounds>(
            future: _calculateBounds(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const CircularProgressIndicator();
              } else if (snapshot.hasError) {
                return Text('Error: ${snapshot.error}');
              } else {
                LatLngBounds bounds = snapshot.data!;
                LatLng center = _calculateCenter(bounds); // Calculate center
                double zoom =
                _calculateZoom(bounds, MediaQuery.of(context).size);
                if (zoom > 15.0) {
                  zoom = 20.0;
                }

                List<LatLng> polylinePoints = <LatLng>[];
                /* for (int i = 0; i < controller.mapdatas.length - 1; i++) {
                  polylinePoints = [
                    LatLng(controller.mapdatas.value[i].latitude ?? 0,
                        controller.mapdatas.value[i].longitude ?? 0)
                  ];
                }*/
                polylinePoints = [
                  LatLng(controller.mapdatas.value[0].latitude ?? 0,
                      controller.mapdatas.value[0].longitude ?? 0),
                  LatLng(
                      controller.mapdatas.value[controller.mapdatas.length - 1]
                          .latitude ??
                          0,
                      controller.mapdatas.value[controller.mapdatas.length - 1]
                          .longitude ??
                          0),
                ];

                Polyline polyline = Polyline(
                  polylineId: const PolylineId('polyline'),
                  color: Colors.black,
                  points: polylinePoints,
                  width: 5,
                );

                return GoogleMap(
                  initialCameraPosition: CameraPosition(
                    target: center,
                    zoom: zoom,
                  ),
                  markers: Set<Marker>.from(controller.markers),
                  // {_pickUpMarker(), _dropMarker()},
                  polylines: {
                    polyline,
                  },
                );
              }
            },
          ),
        ));
  }

  double _calculateZoom(LatLngBounds bounds, Size screenSize) {
    const double padding = 50.0;
    double zoom = 15.0;

    double horizontalZoom = screenSize.width /
        (bounds.northeast.longitude - bounds.southwest.longitude) -
        padding;
    double verticalZoom = screenSize.height /
        (bounds.northeast.latitude - bounds.southwest.latitude) -
        padding;

    if (horizontalZoom < verticalZoom) {
      zoom = horizontalZoom;
    } else {
      zoom = verticalZoom;
    }

    return zoom;
  }

  Future<LatLngBounds> _calculateBounds() async {
    double minLat = controller.mapdatas.value[0].latitude ?? 0;
    double maxLat = controller.mapdatas.value[0].latitude ?? 0;
    double minLng = controller.mapdatas.value[0].longitude ?? 0;
    double maxLng = controller.mapdatas.value[0].longitude ?? 0;

    for (int i = 0; i < controller.mapdatas.value.length; i++) {
      double lat = controller.mapdatas.value[i].latitude ?? 0;
      double lng = controller.mapdatas.value[i].longitude ?? 0;
      minLat = min(minLat, lat);
      maxLat = max(maxLat, lat);
      minLng = min(minLng, lng);
      maxLng = max(maxLng, lng);
    }

    LatLngBounds bounds = LatLngBounds(
      southwest: LatLng(minLat, minLng),
      northeast: LatLng(maxLat, maxLng),
    );

    return bounds;
  }

  LatLng _calculateCenter(LatLngBounds bounds) {
    double latCenter =
        (bounds.southwest.latitude + bounds.northeast.latitude) / 2;
    double lngCenter =
        (bounds.southwest.longitude + bounds.northeast.longitude) / 2;
    return LatLng(latCenter, lngCenter);
  }
}
