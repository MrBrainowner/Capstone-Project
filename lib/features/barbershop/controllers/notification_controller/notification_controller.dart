import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:get/get.dart';
import '../../../../data/models/notifications_model/notification_model.dart';

class BarbershopNotificationController extends GetxController {
  static BarbershopNotificationController get instance => Get.find();

  var isLoading = false.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final _repo = Get.put(NotificationsRepo());

  // fetch notification
  Future<void> fetchNotifications() async {
    isLoading.value = true;
    try {
      notifications.value = await _repo.fetchNotificationsBarbershop();
    } catch (e) {
      ToastNotif(message: 'Error Fetching Notifications', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  // send notification to admin

  // send notification to customer
}
