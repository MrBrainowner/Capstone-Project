import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:logger/logger.dart';
import '../../../../common/widgets/toast.dart';
import '../signup_controller/barbershop_sign_up_controller.dart';

class StepperController extends GetxController {
  static StepperController get instance => Get.find();

  final controller = Get.put(BarbershopSignUpController());
  final Logger logger = Logger();

  var currentStep = 0.obs;
  List<bool> stepValidated =
      [false, true, false].obs; // Assume Step 2 is always validated for now

  // Function to go to the next step
  void nextStep() {
    bool isValid = false;

    if (currentStep.value == 0) {
      // Validate Step 1
      isValid = !controller.signUpFormKey.currentState!.validate();
      if (isValid) {
        // Show error message if Step 1 validation fails
        ToastNotif(message: 'Please complete the form', title: 'Invalid Form')
            .showWarningNotif(Get.context!);
        return; // Do not proceed to the next step if validation fails
      }
    } else if (currentStep.value == 1) {
      // Validate Step 2 - Check if location is selected
      if (controller.selectedLatLng.value ==
              const LatLng(7.449564938212336, 125.8078227665786) ||
          controller.selectedAddress.value.isEmpty) {
        // Show error message if location is not selected
        ToastNotif(
                message: 'Please select a location on the map',
                title: 'Location Required')
            .showWarningNotif(Get.context!);
        return; // Do not proceed to the next step if location is not selected
      }
      // Mark Step 2 as validated
      stepValidated[1] = true;
    } else if (currentStep.value == 2) {
      // Validate Step 3
      isValid = !controller.signUpFormKey3.currentState!.validate();
      if (isValid) {
        // Show error message if Step 3 validation fails
        ToastNotif(message: 'Please complete the form', title: 'Invalid Form')
            .showWarningNotif(Get.context!);
        return; // Do not proceed to the next step if validation fails
      }
      // If Step 3 validation is successful, show confirmation dialog
      showConfirmationDialog();
      return; // Do not proceed to the next step if showing confirmation dialog
    }

    // Move to the next step if no validation issues or if Step 2
    if (currentStep.value < stepValidated.length - 1) {
      currentStep.value++;
    }
  }

  // Function to go to the previous step
  void previousStep() {
    if (currentStep.value > 0) {
      currentStep.value--;
    } else {
      Get.back();
    }
  }

  // Function to set a specific step
  void goToStep(int index) {
    if (index >= 0 && index <= 2) {
      currentStep.value = index;
    }
  }

  // Check if a step can be tapped
  bool canTapStep(int step) {
    return step <= currentStep.value && stepValidated[step];
  }

  // Show confirmation dialog on last step
  void showConfirmationDialog() {
    Get.defaultDialog(
      title: "Confirm Your Details",
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Barbershop Name: ${controller.barbershopName.text}"),
          Text("First Name: ${controller.firstName.text}"),
          Text("Last Name: ${controller.lastName.text}"),
          Text("Email: ${controller.email.text}"),
          Text("Phone Number: ${controller.phone.text}"),
          Text("Street Address: ${controller.streetAddress.text}"),
          Text("Address: ${controller.address.text}"),
          Text("Landmark: ${controller.landMark.text}"),
          Text("Postal Code: ${controller.postalCode.text}"),
        ],
      ),
      actions: [
        Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      // Call your sign-up function here
                      controller.signUp();
                      // Add sign-up logic here
                      logger.i("Sign up confirmed");
                    },
                    child: const Text("Confirm and Sign Up"),
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      Get.back(); // Close the dialog without action
                    },
                    child: const Text("Cancel"),
                  ),
                ),
              ],
            ),
          ],
        )
      ],
    );
  }
}
