import 'dart:async';
import 'dart:io';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/features/customer/controllers/change_email_controller/change_email_controller.dart';
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
  final CustomerRepository customerRepository = Get.find();
  final AuthenticationRepository authrepo = Get.find();

  final firstName = TextEditingController();
  final lastName = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  RxString profileImageUrl = ''.obs;
  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() async {
    super.onInit();
    fetchCustomerData();
    ChangeEmailController.intace.handleEmailMismatch();
  }

  void makeCustomerExist() async {
    await customerRepository.makeCustomerExist();
  }

  // Upload Image
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
  void fetchCustomerData() {
    profileLoading.value = true;
    // Listen to the customer stream and update the customer value
    customerRepository.fetchCustomerDetails().listen(
      (customerData) {
        customer(customerData); // Update the customer data when it changes
        // Once the first data comes in, stop loading
        if (profileLoading.value) {
          profileLoading(false);
        }
      },
      onError: (error) {
        // Handle errors
        customer(CustomerModel.empty()); // Set to empty if there's an error
      },
      onDone: () {
        profileLoading.value = false; // Stop loading when the stream is done
      },
    );
  }

  // Save customer data from any registration provider
  Future<void> saveCustomerData(
      {String? firstNamee, String? lastNamee, String? emaill}) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final existingData = customer.value;
        // Create an updated model only with the fields you want to change
        final updatedCustomer = existingData.copyWith(
          firstName: firstNamee ?? customer.value.firstName,
          lastName: lastNamee ?? customer.value.lastName,
          email: emaill ?? customer.value.email,
        );

        // Update the customer data in Firestore
        await customerRepository.updateCustomerData(updatedCustomer);

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

  Future<void> updateSingleField(String number) async {
    try {
      await customerRepository.updateCustomerSingleField({'phone_no': number});
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

  // Change Password
  Future<void> changePassword() async {
    try {
      profileLoading.value = true;

      if (!signUpFormKey.currentState!.validate()) {
        return;
      }

      // Call the repository method to change the password
      await authrepo.changePassword(
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
}
