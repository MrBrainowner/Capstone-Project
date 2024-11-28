import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/barbershop/controllers/review_controller/review_controller.dart';
import 'package:get/get.dart';

class BarbershopBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BarbershopController>(() => BarbershopController(),
        fenix: true);
    Get.put<BarbershopNotificationController>(
        BarbershopNotificationController(),
        permanent: true);
    Get.lazyPut<BarbershopBookingController>(
        () => BarbershopBookingController(),
        fenix: true);

    Get.lazyPut<ReviewController>(() => ReviewController(), fenix: true);
  }
}
