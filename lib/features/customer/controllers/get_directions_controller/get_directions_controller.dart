import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:barbermate/features/customer/views/booking/choose_haircut.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_map_geojson/flutter_map_geojson.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../../../../data/services/map/direction_services.dart';
import '../../../../data/services/map/location_services.dart';

class GetDirectionsController extends GetxController {
  static GetDirectionsController get instace => Get.find();
  final LocationService _locationService = Get.find();
  final DirectionsService _directionsService = Get.find();

  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  Rx<LatLng?> selectedBarbershopLocation = Rx<LatLng?>(null);
  RxDouble mapHeightRatio = 0.8.obs;
  RxList<LatLng> routeCoordinates = <LatLng>[].obs;
  RxMap<int, double> barbershopDistances = <int, double>{}.obs;

  final GetHaircutsAndBarbershopsController barbershopsController = Get.find();

  final geoJsonParser = GeoJsonParser();
  var markers = <Marker>[].obs;
  var polylines = <Polyline>[].obs;
  var polygons = <Polygon>[].obs;

  final bounds = LatLngBounds(
    const LatLng(7.678178606609754, 126.04005688502966),
    const LatLng(7.219967451991697, 125.53193922489729),
  );

  final mapController = MapController();

  @override
  void onInit() async {
    super.onInit();
    loadGeoJson();
    await getCurrentLocation();
    await calculateAllDistances();

    // React to live location changes
    _locationService.liveLocation.listen((newLocation) {
      if (newLocation != null) {
        currentLocation.value = newLocation;

        // Fetch updated directions to the selected barbershop
        if (selectedBarbershopLocation.value != null) {
          fetchDirections(selectedBarbershopLocation.value!);
        }

        calculateAllDistances(); // Recalculate distances on update
      }
    });
  }

  Future<void> getCurrentLocation() async {
    final location = await _locationService.getCurrentLocation();
    if (location != null) {
      currentLocation.value = location;
    }
  }

  Future<void> calculateAllDistances() async {
    if (currentLocation.value == null) return;

    final barbershops = barbershopsController.barbershopCombinedModel
        .map((barbershopWithHaircuts) => barbershopWithHaircuts.barbershop)
        .toList();

    for (int i = 0; i < barbershops.length; i++) {
      final distance = await _directionsService.getDistance(
          currentLocation.value!,
          LatLng(barbershops[i].latitude, barbershops[i].longitude));

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

  void selectBarbershop(LatLng location) {
    selectedBarbershopLocation.value = location;
    fetchDirections(location);
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

  void showBarbershopDetails(LatLng location, String name, String distance,
      String front, BarbershopCombinedModel barbershop) {
    Get.bottomSheet(
      barrierColor: Colors.transparent,
      isDismissible: true,
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
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Text('Reviews'),
                  const SizedBox(width: 3),
                  const iconoir.StarSolid(
                    height: 15,
                  ),
                  const SizedBox(width: 3),
                  Flexible(
                    child: Text(
                      // Calculate the average rating
                      (barbershop.review.isEmpty
                              ? 0.0
                              : barbershop.review.fold(0.0,
                                      (sum, review) => sum + review.rating) /
                                  barbershop.review.length)
                          .toStringAsFixed(
                              1), // Average rating rounded to 1 decimal place
                      overflow: TextOverflow.clip,
                      maxLines: 1,
                    ),
                  ),
                  const SizedBox(width: 3),
                ],
              ),
              const SizedBox(height: 16.0),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() =>
                            ChooseHaircut(barbershopCombinedData: barbershop));
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
