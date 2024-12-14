import 'dart:convert';

import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:flutter/material.dart';
import 'package:location/location.dart';
import 'package:http/http.dart' as http;
import 'package:logger/logger.dart';
import '../../models/user_authenthication_model/barbershop_model.dart';

class GetDirectionsRepository extends GetxController {
  static GetDirectionsRepository get intance => Get.find();
  RxList<BarbershopModel> barbershopsInfo = <BarbershopModel>[].obs;
  late final FlutterMap map;
  final mapController = MapController(); // Initialize MapController

  Rx<LatLng?> selectedBarbershopLocation = Rx<LatLng?>(null);
  RxDouble mapHeightRatio = 0.8.obs; // Default to 80% of the screen height
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  RxList<LatLng> routeCoordinates = <LatLng>[].obs;
  var distances = <double>[].obs;
  var barbershopDistance = <int, double>{}.obs;
  final Logger logger = Logger();

  final bounds = LatLngBounds(
    const LatLng(7.4300, 125.7800),
    const LatLng(7.4800, 125.8200),
  );

  @override
  void onInit() async {
    super.onInit();
    await getCurrentLocation();
    calculateAllDistances();
  }

  Future<void> calculateAllDistances() async {
    if (currentLocation.value == null || barbershopsInfo.isEmpty) {
      return;
    }

    const accessToken =
        'pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY20wczJ0eHVyMGcwMzJqbjVyamMxemFncyJ9.8Sh3_L9HB32tr5ZQadPkig';
    final userLocation = currentLocation.value!;

    // Clear previous distances
    distances.clear();

    for (int index = 0; index < barbershopsInfo.length; index++) {
      final location = barbershopsInfo[index];

      // Construct the URL for each barbershop
      final url =
          'https://api.mapbox.com/directions/v5/mapbox/driving/${userLocation.longitude},${userLocation.latitude};${location.longitude},${location.latitude}?annotations=distance&access_token=$accessToken';

      try {
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final distance = data['routes'][0]['legs'][0]['distance'] as double;

          // Convert meters to kilometers and store the distance for this barbershop
          barbershopDistance[index] = distance / 1000;
        } else {
          logger.d("Error fetching distance: ${response.body}");
        }
      } catch (e) {
        throw ("Error fetching directions: $e");
      }
    }

    // Trigger a UI update
    update();
  }

  //=======================================
  Future<void> getCurrentLocation() async {
    Location location = Location();

    bool serviceEnabled;
    PermissionStatus permissionGranted;

    serviceEnabled = await location.serviceEnabled();
    if (!serviceEnabled) {
      serviceEnabled = await location.requestService();
      if (!serviceEnabled) {
        // Handle service not enabled
        return;
      }
    }

    permissionGranted = await location.hasPermission();
    if (permissionGranted == PermissionStatus.denied) {
      permissionGranted = await location.requestPermission();
      if (permissionGranted != PermissionStatus.granted) {
        // Handle permission not granted
        return;
      }
    }

    LocationData locationData = await location.getLocation();
    currentLocation.value =
        LatLng(locationData.latitude!, locationData.longitude!);

    // print("Current Location: ${currentLocation.value}"); // Debug print

    // Optionally, move the map to the current location
    if (currentLocation.value != null) {
      mapController.move(currentLocation.value!, 15.0);
    }
  }

  // Fetch directions from Mapbox API
  Future<void> fetchDirections(LatLng destination) async {
    final start = currentLocation.value;
    if (start == null) {
      throw ("Current location not available");
    }

    const accessToken =
        'pk.eyJ1IjoiZ2VvMTEwMDAiLCJhIjoiY20wczJ0eHVyMGcwMzJqbjVyamMxemFncyJ9.8Sh3_L9HB32tr5ZQadPkig'; // Replace with your Mapbox token
    final url =
        'https://api.mapbox.com/directions/v5/mapbox/walking/${start.longitude},${start.latitude};${destination.longitude},${destination.latitude}?geometries=geojson&annotations=distance&overview=full&access_token=$accessToken';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        // Print the entire response for debugging
        // print("API Response: ${jsonEncode(data)}");

        final route = data['routes'][0];
        final coordinates = route['geometry']['coordinates'] as List;
        final legs = route['legs'] as List;

        // Extract distances from legs
        final distanceAnnotations = legs
            .map((leg) => leg['annotation']['distance'] as List)
            .expand((x) => x)
            .toList();

        // Convert the coordinates to LatLng
        routeCoordinates.clear();
        for (var coord in coordinates) {
          routeCoordinates.add(LatLng(coord[1], coord[0]));
        }

        // Handle distance annotations
        distances.clear();
        for (var distance in distanceAnnotations) {
          distances.add(distance.toDouble());
        }

        // Update the map to display the polyline
        update();
      } else {
        logger.d("Error fetching directions: ${response.body}");
      }
    } catch (e) {
      throw ("Error fetching directions: $e");
    }
  }

  //=======================================
  void updateMapHeight(double sheetExtent) {
    // Update map height ratio based on the sheet extent
    // Calculate the new map height ratio. Adjust as needed.
    mapHeightRatio.value = 1.0 - sheetExtent;
  }

  //=======================================
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

  //=======================================
  void zoomToLocation(LatLng location) {
    selectedBarbershopLocation.value = location;
    mapController.move(location, 15.0);
  }

  //=======================================
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
