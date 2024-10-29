import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../../../data/repository/barbershop_repo/barbershop_repo.dart';
import '../../../../data/services/map/direction_services.dart';
import '../../../../data/services/map/location_services.dart';
import '../../../auth/models/barbershop_model.dart';

class GetDirectionsController extends GetxController {
  static GetDirectionsController get instace => Get.find();
  final LocationService _locationService = LocationService();
  final DirectionsService _directionsService = DirectionsService();
  final BarbershopRepository _barbershopRepository = BarbershopRepository();

  RxList<BarbershopModel> barbershopsInfo = <BarbershopModel>[].obs;
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  Rx<LatLng?> selectedBarbershopLocation = Rx<LatLng?>(null);
  RxDouble mapHeightRatio = 0.8.obs;
  RxList<LatLng> routeCoordinates = <LatLng>[].obs;
  RxMap<int, double> barbershopDistances = <int, double>{}.obs;

  final geoJsonParser = GeoJsonParser();
  var markers = <Marker>[].obs;
  var polylines = <Polyline>[].obs;
  var polygons = <Polygon>[].obs;

  final bounds = LatLngBounds(
    const LatLng(7.4300, 125.7800),
    const LatLng(7.4800, 125.8200),
  );

  final mapController = MapController();

  @override
  void onInit() async {
    super.onInit();
    loadGeoJson();
    await getCurrentLocation();
    await fetchBarbershops();
    await calculateAllDistances();
  }

  Future<void> getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      currentLocation.value = location;
      mapController.move(location, 15.0);
    }
  }

  Future<void> fetchBarbershops() async {
    barbershopsInfo.value = await _barbershopRepository.fetchAllBarbershops();
  }

  Future<void> calculateAllDistances() async {
    if (currentLocation.value == null || barbershopsInfo.isEmpty) return;

    for (int i = 0; i < barbershopsInfo.length; i++) {
      final distance = await _directionsService.getDistance(
          currentLocation.value!,
          LatLng(barbershopsInfo[i].latitude, barbershopsInfo[i].longitude));

      if (distance != null) {
        barbershopDistances[i] = distance;
      }
    }

    update();
  }

  Future<void> fetchDirections(LatLng destination) async {
    if (currentLocation.value == null) return;
    routeCoordinates.value = await _directionsService.fetchDirections(
        currentLocation.value!, destination);
    update();
  }

  void zoomToLocation(LatLng location) {
    selectedBarbershopLocation.value = location;
    mapController.move(location, 15.0);
  }

  void updateMapHeight(double extent) {
    mapHeightRatio.value = 1.0 - extent;
  }

  void handleDraggableScrollNotification(
      DraggableScrollableNotification notification) {
    final double extent = notification.extent;
    // final double height = Get.height;

    if (extent < 0.5) {
      // Update map height ratio when below 50%
      updateMapHeight(extent);
    } else {
      // Optionally, you can set mapHeightRatio to a fixed value to stop resizing
      mapHeightRatio.value = 0.5; // Or any fixed value to stop resizing
    }
  }

  Future<void> loadGeoJson() async {
    try {
      final geoJsonString = await rootBundle.loadString('assets/tagum.geojson');
      geoJsonParser.parseGeoJsonAsString(geoJsonString);

      markers.value = geoJsonParser.markers;
      polylines.value = geoJsonParser.polylines;
      polygons.value = geoJsonParser.polygons;
    } catch (e) {
      throw ('Error loading GeoJSON: $e');
    }
  }

  void showBarbershopDetails(
      LatLng location, String name, String distance, String front) {
    Get.bottomSheet(
      barrierColor: Colors.transparent,
      isDismissible: false,
      Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: const BorderRadius.vertical(top: Radius.circular(16.0)),
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.1),
                spreadRadius: 5,
                blurRadius: 7,
                offset: const Offset(0, -2)),
          ],
        ),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.arrow_back),
                    onPressed: () => Get.back(),
                  ),
                  const SizedBox(width: 8.0),
                  Text('Barbershop Details',
                      style: Get.textTheme.headlineMedium),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 150,
                      decoration: BoxDecoration(border: Border.all(width: 1)),
                      child: front.isNotEmpty
                          ? Image.network(front, // Dummy image URL
                              fit: BoxFit.cover,
                              scale: 1.0)
                          : Image.asset('assets/images/barbershop.jpg',
                              fit: BoxFit.cover),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16.0),
              Text(name, style: Get.textTheme.headlineMedium),
              Text('Distance: $distance km', style: Get.textTheme.bodyMedium),
              const Row(
                children: [
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star, color: Colors.amber),
                  Icon(Icons.star_half, color: Colors.amber),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        // Add booking functionality here
                      },
                      child: const Text('Book Now'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
