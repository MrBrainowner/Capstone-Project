import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/barbershop_repo.dart';

class BarbershopController extends GetxController {
  static BarbershopController get instance => Get.find();

  // Variables
  final profileLoading = false.obs;
  Rx<BarbershopModel> barbershop = BarbershopModel.empty().obs;
  final barbershopRepository = Get.put(BarbershopRepository());
  final notifs = Get.put(BarbershopNotificationController());

  @override
  void onInit() async {
    super.onInit();
    fetchBarbershopData();
    await notifs.fetchNotifications();
  }

  // Fetch Barbershop Data
  Future<void> fetchBarbershopData() async {
    try {
      profileLoading.value = true;
      final barbershop = await barbershopRepository.fetchBarbershopDetails();
      this.barbershop(barbershop);
    } catch (e) {
      barbershop(BarbershopModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  // Save Barbershop data from any registration provider
  Future<void> saveBarbershopData({
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNo,
    String? profileImage,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Retrieve the current Barbershop data from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('Barbershops')
            .doc(user.uid)
            .get();
        final existingData = BarbershopModel.fromSnapshot(doc);

        // Create an updated model only with the fields you want to change
        final updatedBarbershop = existingData.copyWith(
          firstName: firstName ?? existingData.firstName,
          lastName: lastName ?? existingData.lastName,
          email: email ?? existingData.email,
          phoneNo: phoneNo ?? existingData.phoneNo,
        );

        // Update the barbershop data in Firestore
        await barbershopRepository.updateBarbershopData(updatedBarbershop);
      }
    } catch (e) {
      ToastNotif(
              message:
                  'Someting went wrong while saving your information. You can re-save your data in your profile.',
              title: 'Data not saved')
          .showWarningNotif(Get.context!);
    }
  }
}
