import 'dart:async';

import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/models/notifications_model/notification_model.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';

class CustomerNotificationController extends GetxController {
  static CustomerNotificationController get instance => Get.find();

  var isLoading = false.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final NotificationsRepo _repo = Get.find();

  // Check for unread notifications
  bool get hasUnreadNotifications {
    return notifications
        .any((notification) => notification.status == 'notRead');
  }

  StreamSubscription? _reviewsStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    listenToNotificationsStream();
  }

  // fetch notification
  // Bind the stream to the notifications list
  void listenToNotificationsStream() {
    isLoading.value = true;

    // Listen to the notifications stream from the repository
    _repo.fetchNotificationsCustomers().listen(
      (List<NotificationModel> data) {
        // Check for new notifications by comparing the current list with the previous one
        if (notifications.isNotEmpty) {
          for (var newNotification in data) {
            // Show a toast for new notifications
            if (!notifications.any((n) => n.id == newNotification.id)) {
              // Assuming `newNotification.message` holds the notification message
              ToastNotif(
                message: newNotification.message,
                title: 'New Notification',
              ).showSuccessNotif(Get.context!);
            }
          }
        }

        // Update the lists after showing notifications
        notifications.assignAll(data);
      },
      onError: (error) {
        ToastNotif(message: 'Error Fetching Notifications', title: 'Error')
            .showErrorNotif(Get.context!);
      },
      onDone: () {
        isLoading.value = false;
      },
    );
  }

  Future<void> updateNotifAsReadCustomer(NotificationModel notif) async {
    try {
      await _repo.updateNotifAsReadCustomer(notif);
    } catch (e) {
      ToastNotif(message: 'Error Updating Notifications $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> sendNotifWhenBookingUpdatedCustomers(
    BookingModel booking,
    String type,
    String title,
    String message,
    String status,
  ) async {
    try {
      await _repo.sendNotifWhenBookingUpdatedCustomers(
          booking, type, title, message, status);
    } catch (e) {
      ToastNotif(message: 'Error Sending Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // receive notification

  // send notification

  @override
  void onClose() {
    // Cancel the stream subscription to prevent memory leaks
    _reviewsStreamSubscription?.cancel();
    super.onClose();
  }
}
