import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/documents_verification_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/haircut_repository.dart';
import 'package:barbermate/data/repository/barbershop_repo/timeslot_repository.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:barbermate/features/admin/controllers/admin_controller.dart';
import 'package:get/get.dart';

class AdminBinding extends Bindings {
  @override
  void dependencies() {
    //============================================== repositories
    //barbershop
    Get.lazyPut<BarbershopRepository>(() => BarbershopRepository(),
        fenix: true);
    //notification
    Get.lazyPut<NotificationsRepo>(() => NotificationsRepo(), fenix: true);
    //reviews
    Get.lazyPut<ReviewRepo>(() => ReviewRepo(), fenix: true);
    //haircuts
    Get.lazyPut<HaircutRepository>(() => HaircutRepository(), fenix: true);
    //timeslots
    Get.lazyPut<TimeslotRepository>(() => TimeslotRepository(), fenix: true);
    //verification
    Get.lazyPut<VerificationRepo>(() => VerificationRepo(), fenix: true);

    //============================================== controllers

    //admin notification

    //barbershop reviews

    //admin controller
    Get.lazyPut<AdminController>(() => AdminController(), fenix: true);
  }
}
