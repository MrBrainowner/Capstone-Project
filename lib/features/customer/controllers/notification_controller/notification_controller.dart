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
    return notificationsss.any((notification) => notification.status == 'read');
  }

  // fetch notification
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      notifications.value = await _repo.fetchNotificationsCustomers();
      notificationsss.assignAll(notifications);
    } catch (e) {
      ToastNotif(message: 'Error Fetching Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> updateNotifAsReadCustomer(NotificationModel notif) async {
    try {
      await _repo.updateNotifAsReadCustomer(notif);
      fetchNotifications();
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
      fetchNotifications();
    } catch (e) {
      ToastNotif(message: 'Error Sending Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // receive notification

  // send notification
}
