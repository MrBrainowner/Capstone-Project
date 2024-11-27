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
  final _repo = Get.put(NotificationsRepo());
  RxList<NotificationModel> notificationsss = <NotificationModel>[].obs;

  // Check for unread notifications
  bool get hasUnreadNotifications {
    return notificationsss
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

    // You can fetch notifications using a stream from the repository
    _repo.fetchNotificationsCustomers().listen(
      (data) {
        notifications.assignAll(data); // Updates the notifications list
        notificationsss.assignAll(notifications);
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
