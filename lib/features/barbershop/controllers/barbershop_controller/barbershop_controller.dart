import 'dart:async';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/features/auth/models/barbershop_model.dart';
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
  final BarbershopRepository barbershopRepository = Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  final address = TextEditingController();
  final floors = TextEditingController();
  final landmark = TextEditingController();
  final barbershopName = TextEditingController();

  final ImagePicker _picker = ImagePicker();

  StreamSubscription? _reviewsStreamSubscription;

  @override
  void onInit() {
    super.onInit();
    listenToBarbershopStream();
  }

  // update the exist field to make the profile setup only once
  void makeBarbershopExist() async {
    await barbershopRepository.makeBarbershopExist();
  }

  Future<void> uploadImage(String type) async {
    try {
      // Pick an image from the gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        return;
      } else {
        ToastNotif(message: 'Your image is uploading', title: 'Uploading')
            .showSuccessNotif(Get.context!);
      }

      // Upload the image to Firebase Storage
      final downloadUrl = await barbershopRepository.uploadImageToStorage(
          XFile(pickedFile.path), type);

      if (downloadUrl != null) {
        // Update Firestore with the image URL
        await barbershopRepository.updateProfileImageInFirestore(
            barbershop.value.id, downloadUrl, type);

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
        final existingData = barbershop.value;

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

  // Change Email user
  void changeEmailProcessBarbershop(
      String currentPassword, String newEmail) async {
    bool reauthenticated = await AuthenticationRepository.instance
        .reAuthenticateUser(currentPassword);

    if (reauthenticated) {
      try {
        // Step 1: Change email in Firebase Authentication
        await AuthenticationRepository.instance.changeUserEmail(newEmail);

        // Step 2: Send verification email
        await AuthenticationRepository.instance.sendEmailVerification();

        ToastNotif(
          message:
              'Email updated successfully. Please verify your new email to complete the process.',
          title: 'Verification Required',
        ).showNormalNotif(Get.context!);

        // Step 3: Wait for user to verify their new email
        bool isVerified =
            await _waitForNewEmailVerificationBarbershop(newEmail);

        if (isVerified) {
          // Step 4: Update email in Firestore
          await barbershopRepository
              .updateBarbershopSingleField({'email': newEmail});
          ToastNotif(
            message: 'Email verified and updated successfully.',
            title: 'Success',
          ).showSuccessNotif(Get.context!);
        } else {
          ToastNotif(
            message: 'Email verification not completed. Please try again.',
            title: 'Error',
          ).showErrorNotif(Get.context!);
        }
      } catch (e) {
        ToastNotif(
          message: e.toString(),
          title: 'Error',
        ).showErrorNotif(Get.context!);
      }
    } else {
      ToastNotif(
        message: 'Re-authentication failed. Please try again.',
        title: 'Error',
      ).showErrorNotif(Get.context!);
    }
  }

  // Helper function to wait for the new email verification
  Future<bool> _waitForNewEmailVerificationBarbershop(String newEmail) async {
    for (int i = 0; i < 10; i++) {
      // 10 attempts for 30 seconds total
      await Future.delayed(const Duration(seconds: 3));
      await AuthenticationRepository.instance.authUser?.reload();

      // Check if the current email matches the new email and is verified
      if (AuthenticationRepository.instance.authUser?.email == newEmail) {
        return true;
      }
    }
    return false;
  }

  Future<void> updateSingleFieldBarbershop(Map<String, dynamic> json) async {
    try {
      await barbershopRepository.updateBarbershopSingleField(json);
      ToastNotif(
        message: 'Field updated successfully.',
        title: 'Success',
      ).showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(
        message: e.toString(),
        title: 'Error',
      ).showErrorNotif(Get.context!);
    }
  }

  @override
  void onClose() {
    // Cancel the stream subscription to prevent memory leaks
    _reviewsStreamSubscription?.cancel();
    super.onClose();
  }
}
