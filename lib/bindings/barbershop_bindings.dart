import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/barbershop/controllers/review_controller/review_controller.dart';
import 'package:get/get.dart';

class BarbershopBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<BarbershopController>(BarbershopController(), permanent: true);
    Get.put<BarbershopNotificationController>(
        BarbershopNotificationController(),
        permanent: true);
    Get.put<BarbershopBookingController>(BarbershopBookingController(),
        permanent: true);

    Get.put<ReviewController>(ReviewController(), permanent: true);
  }
}
