import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/timeslot_repository.dart';
import 'package:barbermate/data/repository/booking_repo/booking_repo.dart';
import 'package:barbermate/data/repository/customer_repo/customer_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:barbermate/features/customer/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/customer/controllers/review_controller/review_controller.dart';
import 'package:get/get.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    //=============================================================== repos
    Get.lazyPut<BarbershopRepository>(() => BarbershopRepository(),
        fenix: true);
    Get.lazyPut<CustomerRepository>(() => CustomerRepository(), fenix: true);
    Get.lazyPut<TimeslotRepository>(() => TimeslotRepository(), fenix: true);
    Get.lazyPut<ReviewRepo>(() => ReviewRepo(), fenix: true);
    Get.lazyPut<NotificationsRepo>(() => NotificationsRepo(), fenix: true);
    Get.lazyPut<BookingRepo>(() => BookingRepo(), fenix: true);

    //=============================================================== controllers
    Get.lazyPut<CustomerController>(() => CustomerController(), fenix: true);
    Get.lazyPut<ReviewControllerCustomer>(() => ReviewControllerCustomer(),
        fenix: true);
    Get.put<CustomerNotificationController>(CustomerNotificationController(),
        permanent: true);
    Get.lazyPut<GetHaircutsAndBarbershopsController>(
        () => GetHaircutsAndBarbershopsController(),
        fenix: true);
    Get.lazyPut<CustomerBookingController>(() => CustomerBookingController(),
        fenix: true);
  }
}
