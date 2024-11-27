import 'dart:async';

import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../data/models/notifications_model/notification_model.dart';

class BarbershopNotificationController extends GetxController {
  static BarbershopNotificationController get instance => Get.find();

  var isLoading = false.obs;
  var notifications = <NotificationModel>[].obs;
  final _repo = Get.put(NotificationsRepo());

  final Logger logger = Logger();

  StreamSubscription? _reviewsStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    bindNotificationsStream();
  }

  // fetch notification
  void bindNotificationsStream() {
    try {
      isLoading.value = true;
      notifications.bindStream(_repo.fetchNotificationsBarbershop());
    } catch (e) {
      ToastNotif(message: 'Error Fetching Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> sendNotifWhenBookingUpdated(
    BookingModel booking,
    String type,
    String title,
    String message,
    String status,
  ) async {
    try {
      await _repo.sendNotifWhenBookingUpdated(
          booking, type, title, message, status);
    } catch (e) {
      ToastNotif(message: 'Error Sending Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> updateNotifAsRead(NotificationModel notif) async {
    try {
      await _repo.updateNotifAsRead(notif);
    } catch (e) {
      ToastNotif(message: 'Error Updating Notifications $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // send notification to admin

  // send notification to customer

  @override
  void onClose() {
    // Cancel the stream subscription to prevent memory leaks
    _reviewsStreamSubscription?.cancel();
    super.onClose();
  }
}
