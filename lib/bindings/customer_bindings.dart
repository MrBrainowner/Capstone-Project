import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/timeslot_repository.dart';
import 'package:barbermate/data/repository/booking_repo/booking_repo.dart';
import 'package:barbermate/data/repository/customer_repo/customer_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:barbermate/data/services/map/direction_services.dart';
import 'package:barbermate/data/services/map/location_services.dart';
import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/customer/controllers/change_email_controller/change_email_controller.dart';
import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate/features/customer/controllers/detect_face_shape/detect_face_shape_controller.dart';
import 'package:barbermate/features/customer/controllers/get_directions_controller/get_directions_controller.dart';
import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:barbermate/features/customer/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/customer/controllers/review_controller/review_controller.dart';
import 'package:get/get.dart';

class CustomerBinding extends Bindings {
  @override
  void dependencies() {
    //=============================================================== repos
    //barbershops
    Get.lazyPut<BarbershopRepository>(() => BarbershopRepository(),
        fenix: true);
    //customer
    Get.lazyPut<CustomerRepository>(() => CustomerRepository(), fenix: true);
    //timeslot
    Get.lazyPut<TimeslotRepository>(() => TimeslotRepository(), fenix: true);
    //review
    Get.lazyPut<ReviewRepo>(() => ReviewRepo(), fenix: true);
    //notification
    Get.lazyPut<NotificationsRepo>(() => NotificationsRepo(), fenix: true);
    //booking
    Get.lazyPut<BookingRepo>(() => BookingRepo(), fenix: true);
    //directions service
    Get.lazyPut<LocationService>(() => LocationService(), fenix: true);
    Get.lazyPut<DirectionsService>(() => DirectionsService(), fenix: true);

    //=============================================================== controllers
    //customer

    Get.lazyPut<CustomerController>(() => CustomerController(), fenix: true);
    //review
    Get.lazyPut<ReviewControllerCustomer>(() => ReviewControllerCustomer(),
        fenix: true);
    //customer
    Get.put<CustomerNotificationController>(CustomerNotificationController(),
        permanent: true);
    //haircuts and barbershop
    Get.lazyPut<GetHaircutsAndBarbershopsController>(
        () => GetHaircutsAndBarbershopsController(),
        fenix: true);
    //booking
    Get.lazyPut<CustomerBookingController>(() => CustomerBookingController(),
        fenix: true);
    //directions
    Get.put<GetDirectionsController>(GetDirectionsController(),
        permanent: true);
    //ai
    Get.lazyPut<DetectFaceShape>(() => DetectFaceShape(), fenix: true);
    Get.lazyPut<ChangeEmailController>(() => ChangeEmailController(),
        fenix: true);
  }
}
