import 'dart:io';

import 'package:barbermate/features/customer/controllers/notification_controller/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/customer_repo/customer_repo.dart';
import '../../../auth/models/customer_model.dart';

class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();

  // Variables
  final profileLoading = false.obs;
  Rx<CustomerModel> customer = CustomerModel.empty().obs;
  final customerRepository = Get.put(CustomerRepository());
  final notifs = Get.put(CustomerNotificationController());

  final firstName = TextEditingController();
  final lastName = TextEditingController();

  RxString profileImageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() async {
    super.onInit();
    await fetchCustomerData();

    await notifs.fetchNotifications();
  }

  Future<void> uploadProfileImage() async {
    try {
      // Pick an image from the gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile == null) return;

      final file = File(pickedFile.path);

      // Upload the image to Firebase Storage
      final downloadUrl = await customerRepository.uploadImageToStorage(
          customer.value.id, file);

      if (downloadUrl != null) {
        // Update Firestore with the image URL
        await customerRepository.updateProfileImageInFirestore(
            customer.value.id, downloadUrl);

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

  // Fetch Customer Data
  Future<void> fetchCustomerData() async {
    try {
      profileLoading.value = true;
      final customer = await customerRepository.fetchCustomerDetails();
      this.customer(customer);
    } catch (e) {
      customer(CustomerModel.empty());
    } finally {
      profileLoading.value = false;
    }
  }

  // Save customer data from any registration provider
  Future<void> saveCustomerData({
    String? firstNamee,
    String? lastNamee,
    String? profileImage,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        // Retrieve the current customer data from Firestore
        final doc = await FirebaseFirestore.instance
            .collection('Customers')
            .doc(user.uid)
            .get();
        final existingData = CustomerModel.fromSnapshot(doc);

        // Create an updated model only with the fields you want to change
        final updatedCustomer = existingData.copyWith(
          firstName: firstNamee ?? existingData.firstName,
          lastName: lastNamee ?? existingData.lastName,
          profileImage: profileImage ?? existingData.profileImage,
        );

        // Update the customer data in Firestore
        await customerRepository.updateCustomerData(updatedCustomer);
        await fetchCustomerData();
        ToastNotif(message: 'Update Successful', title: 'Success')
            .showSuccessNotif(Get.context!);
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
