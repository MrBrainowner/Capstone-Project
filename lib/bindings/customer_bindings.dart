import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:barbermate/features/customer/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/customer/controllers/review_controller/review_controller.dart';
import 'package:get/get.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<CustomerController>(CustomerController(), permanent: true);

    Get.put<ReviewControllerCustomer>(ReviewControllerCustomer(),
        permanent: true);

    Get.put<CustomerNotificationController>(CustomerNotificationController(),
        permanent: true);

    Get.put<GetHaircutsAndBarbershopsController>(
        GetHaircutsAndBarbershopsController(),
        permanent: true);

    Get.put<CustomerBookingController>(CustomerBookingController(),
        permanent: true);
  }
}
