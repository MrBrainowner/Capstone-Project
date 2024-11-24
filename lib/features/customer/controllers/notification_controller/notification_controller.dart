import 'package:barbermate/data/models/notifications_model/notification_model.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';

class CustomerNotificationController extends GetxController {
  static CustomerNotificationController get instance => Get.find();

  var isLoading = false.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final _repo = Get.put(NotificationsRepo());

  // fetch notification
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      notifications.value = await _repo.fetchNotificationsCustomers();
    } catch (e) {
      ToastNotif(message: 'Error Fetching Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  // receive notification

  // send notification
}
