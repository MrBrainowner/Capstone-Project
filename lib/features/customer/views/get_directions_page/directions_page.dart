import 'package:barbermate/features/customer/views/get_directions_page/barbershop_list.dart';
import 'package:barbermate/features/customer/views/get_directions_page/directions_map.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/get_directions_controller/get_directions_controller.dart';

class GetDirectionsPage2 extends StatelessWidget {
  const GetDirectionsPage2({super.key});

  @override
  Widget build(BuildContext context) {
    final GetDirectionsController controller =
        Get.put(GetDirectionsController());

    return Scaffold(
      body: Stack(
        children: [
          // Separated Map Widget
          const MapWidget(),

          // Draggable Scrollable Sheet for displaying barbershop info cards
          NotificationListener<DraggableScrollableNotification>(
            onNotification: (notification) {
              controller.handleDraggableScrollNotification(notification);
              return true;
            },
            child: DraggableScrollableSheet(
              initialChildSize: 0.2,
              minChildSize: 0.2,
              maxChildSize: 0.5,
              builder:
                  (BuildContext context, ScrollController scrollController) {
                return BarbershopList(
                    controller: controller, scrollController: scrollController);
              },
            ),
          ),
        ],
      ),
    );
  }
}
