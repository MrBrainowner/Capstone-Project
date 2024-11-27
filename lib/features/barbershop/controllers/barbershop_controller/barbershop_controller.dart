import 'dart:async';
import 'dart:io';

import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/barbershop_repo.dart';

class BarbershopController extends GetxController {
  static BarbershopController get instance => Get.find();

  // Variables
  final profileLoading = false.obs;
  Rx<BarbershopModel> barbershop = BarbershopModel.empty().obs;
  final barbershopRepository = Get.put(BarbershopRepository());

  final firstName = TextEditingController();
  final lastName = TextEditingController();

  RxString profileImageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();

  StreamSubscription? _reviewsStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    listenToBarbershopStream();
  }

  Future<void> uploadProfileImage() async {
    try {
      // Pick an image from the gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final file = File(pickedFile.path);

      // Upload the image to Firebase Storage
      final downloadUrl = await barbershopRepository.uploadImageToStorage(
          barbershop.value.id, file);

      if (downloadUrl != null) {
        // Update Firestore with the image URL
        await barbershopRepository.updateProfileImageInFirestore(
            barbershop.value.id, downloadUrl);

        // Update the local state
        profileImageUrl.value = downloadUrl;
        ToastNotif(
                message: 'Profile image updated successfully', title: 'Success')
            .showSuccessNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(message: 'Failed to upload profile image', title: 'Error')
          .showSuccessNotif(Get.context!);
    }
  }

  // Fetch Barbershop Data
  void listenToBarbershopStream() {
    profileLoading.value = true;
    barbershopRepository.barbershopDetailsStream().listen((barbershopDetails) {
      barbershop(barbershopDetails);
      if (profileLoading.value) {
        profileLoading(false);
      }
    }, onError: (error) {
      profileLoading.value = false;
    });
  }

  // Save Barbershop data from any registration provider
  Future<void> saveBarbershopData({
    String? firstNamee,
    String? lastNamee,
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
          firstName: firstNamee ?? barbershop.value.firstName,
          lastName: lastNamee ?? barbershop.value.lastName,
        );

        // Update the barbershop data in Firestore
        await barbershopRepository.updateBarbershopData(updatedBarbershop);
        ToastNotif(message: 'Update Successful', title: 'Success')
            .showSuccessNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(
              message: 'Someting went wrong while saving your information. $e.',
              title: 'Data not saved')
          .showWarningNotif(Get.context!);
    }
  }

  @override
  void onClose() {
    // Cancel the stream subscription to prevent memory leaks
    _reviewsStreamSubscription?.cancel();
    super.onClose();
  }
}
