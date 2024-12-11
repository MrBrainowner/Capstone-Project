import 'dart:async';
import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/models/notifications_model/notification_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/data/services/push_notification/push_notification.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';

class CustomerNotificationController extends GetxController {
  static CustomerNotificationController get instance => Get.find();

  var isLoading = false.obs;
  RxList<NotificationModel> notifications = <NotificationModel>[].obs;
  final NotificationsRepo _repo = Get.find();
  final _notificationServiceRepository = NotificationServiceRepository.instance;

  // Check for unread notifications
  bool get hasUnreadNotifications {
    return notifications
        .any((notification) => notification.status == 'notRead');
  }

  @override
  void onInit() {
    super.onInit();
    listenToNotificationsStream();
    _initializeFCMToken();
  }

  // fetch notification
  // Bind the stream to the notifications list
  void listenToNotificationsStream() {
    isLoading.value = true;

    // Listen to the notifications stream from the repository
    _repo.fetchNotificationsCustomers().listen(
      (List<NotificationModel> data) {
        // Check for new notifications by comparing the current list with the previous one
        // if (notifications.isNotEmpty) {
        //   for (var newNotification in data) {
        //     // Show a toast for new notifications
        //     if (!notifications.any((n) => n.id == newNotification.id)) {
        //       // Assuming `newNotification.message` holds the notification message
        //       ToastNotif(
        //         message: newNotification.message,
        //         title: 'New Notification',
        //       ).showSuccessNotif(Get.context!);
        //     }
        //   }
        // }

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

  // Call the repository method for FCM token handling
  Future<void> _initializeFCMToken() async {
    try {
      final String userId = AuthenticationRepository
          .instance.authUser!.uid; // Replace with your user ID
      await _notificationServiceRepository
          .fetchAndSaveFCMTokenCustomers(userId);
    } catch (e) {
      print('Error initializing FCM token in controller: $e');
    }
  }

  // Send a notification to a specific user
  Future<void> sendNotificationToUser({
    required String userType,
    required String userId,
    required String title,
    required String body,
  }) async {
    try {
      isLoading(true);
      String? token =
          await _notificationServiceRepository.getUserFCMToken(userId);
      if (token != null) {
        await _notificationServiceRepository.sendNotificationToUser(
          token: token,
          title: title,
          body: body,
          userType: userType,
        );
      } else {
        print('User does not have a valid FCM token');
      }
    } catch (e) {
      print('Error sending notification to user: $e');
    } finally {
      isLoading(false);
    }
  }

  // Send a notification to all users
  Future<void> sendNotificationToAllUsers({
    required String userType,
    required String token,
    required String title,
    required String body,
  }) async {
    try {
      isLoading(true);
      await _notificationServiceRepository.sendNotificationToAllUsers(
        title: title,
        body: body,
        userType: userType,
      );
    } catch (e) {
      print('Error sending notification to all users: $e');
    } finally {
      isLoading(false);
    }
  }
}
