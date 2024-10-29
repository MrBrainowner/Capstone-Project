import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';

import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/customer_repos/customer_repo.dart';
import '../../../auth/models/customer_model.dart';

class CustomerController extends GetxController {
  static CustomerController get instance => Get.find();

  // Variables
  final profileLoading = false.obs;
  Rx<CustomerModel> customer = CustomerModel.empty().obs;
  final customerRepository = Get.put(CustomerRepository());

  @override
  void onInit() {
    super.onInit();
    fetchCustomerData();
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
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNo,
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
          firstName: firstName ?? existingData.firstName,
          lastName: lastName ?? existingData.lastName,
          email: email ?? existingData.email,
          phoneNo: phoneNo ?? existingData.phoneNo,
          profileImage: profileImage ?? existingData.profileImage,
        );

        // Update the customer data in Firestore
        await customerRepository.updateCustomerData(updatedCustomer);
      }
    } catch (e) {
      ToastNotif(
              message:
                  'Someting went wrong while saving your information. You can re-save your data in your profile.',
              title: 'Data not saved')
          .showWarningNotif(Get.context!);
    }
  }

  // Get barbershops
  // Get haircuts
  // Get reviews
}
