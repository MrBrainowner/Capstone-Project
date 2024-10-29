import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';

import '../../../controllers/signup_controller/barbershop_sign_up_controller.dart';

class Step2 extends StatelessWidget {
  const Step2({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopSignUpController());

    return Obx(() {
      return Column(
        children: [
          Container(
            padding: const EdgeInsets.all(5),
            height: 370,
            decoration: BoxDecoration(
              border:
                  Border.all(width: 2, color: Theme.of(context).primaryColor),
              borderRadius: const BorderRadius.all(Radius.circular(10)),
            ),
            child: Stack(
              children: [
                FlutterMap(
                  mapController: controller.mapController,
                  options: MapOptions(
                    initialCenter: controller.selectedLatLng.value,
                    initialZoom: 12.3,
                    cameraConstraint: CameraConstraint.containCenter(
                        bounds: controller.bounds),
                    minZoom: 12.3,
                    onTap: (_, latLng) {
                      // ignore: no_wildcard_variable_uses
                      controller.setSelectedLocation(_, latLng);
                    },
                    interactionOptions: const InteractionOptions(
                        flags:
                            InteractiveFlag.pinchZoom | InteractiveFlag.drag),
                  ),
                  children: [
                    TileLayer(
                      urlTemplate:
                          'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
                    ),
                    MarkerLayer(
                      markers: controller.markers,
                    ),
                  ],
                ),
                Positioned(
                  bottom: 0,
                  right: 0,
                  child: IconButton(
                    onPressed: () {
                      controller.getCurrentLocation();
                    },
                    icon: const Icon(
                      Icons.my_location,
                      size: 30,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Street Address:',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              Text(
                controller.selectedAddress.value.isNotEmpty
                    ? controller.selectedAddress.value
                    : 'Tap on the map to select a location.',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ],
          ),
          const SizedBox(height: 10),
        ],
      );
    });
  }
}
