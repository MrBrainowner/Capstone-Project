import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/customer_repo/customer_repo.dart';
import 'package:flutter/widgets.dart';
import 'package:get/get.dart';

class ChangeEmailController extends GetxController {
  static ChangeEmailController get intace => Get.find();
  final AuthenticationRepository authrepo = Get.find();
  final CustomerRepository customerRepository = Get.find();

  final email = TextEditingController();
  final password = TextEditingController();

  // Change Email user
  void changeEmailProcess(String currentPassword, String newEmail) async {
    bool reauthenticated = await authrepo.reAuthenticateUser(currentPassword);

    if (reauthenticated) {
      try {
        // Step 1: Change email in Firebase Authentication
        await authrepo.changeUserEmail(newEmail);

        // Step 2: Send verification email
        await authrepo.sendEmailVerification();

        // Step 3: Wait for user to verify their new email
        bool isVerified = await _waitForNewEmailVerificationStream(newEmail);

        if (isVerified) {
          // Step 4: Update email in Firestore
          await customerRepository
              .updateCustomerSingleField({'email': newEmail});
          ToastNotif(
            message: 'Email verified and updated successfully.',
            title: 'Success',
          ).showSuccessNotif(Get.context!);
          Get.back();
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
  Stream<bool> _emailVerificationStream(String newEmail) async* {
    while (true) {
      await Future.delayed(const Duration(seconds: 3));
      await authrepo.authUser?.reload();

      if (authrepo.authUser?.email == newEmail &&
          authrepo.authUser?.emailVerified == true) {
        yield true;
        break;
      }
    }
    yield false;
  }

  Future<bool> _waitForNewEmailVerificationStream(String newEmail) async {
    await for (bool isVerified in _emailVerificationStream(newEmail)) {
      if (isVerified) return true;
    }
    return false;
  }
}
