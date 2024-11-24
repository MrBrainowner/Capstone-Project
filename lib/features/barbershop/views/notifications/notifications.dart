import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/common/widgets/notifications_case.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbershopNotifications extends StatelessWidget {
  const BarbershopNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopNotificationController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.fetchNotifications(),
        child: Obx(() {
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.notifications.length,
            itemBuilder: (context, index) {
              final notification = controller.notifications[index];
              return buildNotificationWidget(notification);
            },
          );
        }),
      ),
    );
  }
}
