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
  final _authRepository = Get.put(AuthenticationRepository());

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  final address = TextEditingController();
  final floors = TextEditingController();
  final landmark = TextEditingController();
  final barbershopName = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
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

  // Update a single fied
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

  // change password
  Future<void> changePassword() async {
    try {
      profileLoading.value = true;

      if (!signUpFormKey.currentState!.validate()) {
        return;
      }

      // Call the repository method to change the password
      await _authRepository.changePassword(
          email.text.trim(),
          currentPasswordController.text.trim(),
          newPasswordController.text.trim());
    } catch (e) {
      // Show an error message if something went wrong
      Get.snackbar('Error', 'Failed to change password: ${e.toString()}');
    } finally {
      profileLoading.value = false;
    }
  }

  @override
  void onClose() {
    // Cancel the stream subscription to prevent memory leaks
    _reviewsStreamSubscription?.cancel();
    super.onClose();
  }
}
