import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/notification_controller/notification_controller.dart';
import '../../../../common/widgets/notifications_case.dart';

class CustomerNotifications extends StatelessWidget {
  const CustomerNotifications({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(CustomerNotificationController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Notifications'),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => controller.fetchNotifications(),
        child: Obx(() {
          // Sort notifications by creation date in descending order
          final sortedNotifications = controller.notifications.toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: sortedNotifications.length,
            itemBuilder: (context, index) {
              final notification = sortedNotifications[index];
              return GestureDetector(
                  onTap: () async {
                    await controller.updateNotifAsReadCustomer(notification);
                  },
                  child: buildNotificationWidget(notification));
            },
          );
        }),
      ),
    );
  }
}
