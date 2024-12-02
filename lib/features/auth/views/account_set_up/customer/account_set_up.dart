import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate/features/customer/views/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerAccountSetUpPage extends StatelessWidget {
  const CustomerAccountSetUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController = Get.find();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: [
              Text('Set Up Your Profile',
                  style: Theme.of(context).textTheme.headlineMedium),
              const SizedBox(height: 30),
              Container(
                height: 200,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                ),
                child: Obx(
                  () => ClipRRect(
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: customerController
                              .customer.value.profileImage.isEmpty
                          ? const Center(child: Text('Upload Profile'))
                          : Obx(
                              () => Image.network(
                                customerController.customer.value.profileImage,
                                fit: BoxFit.cover,
                              ),
                            )),
                ),
              ),
              TextButton(
                  onPressed: () => customerController.uploadImage('Profile'),
                  child: const Text('Upload Your Profile Picture')),
              const SizedBox(height: 20),
              Text(
                  'You can skip this step and complete it later in your profile settings.',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 20),
              Obx(
                () => SizedBox(
                    width: double.infinity,
                    child:
                        customerController.customer.value.profileImage.isEmpty
                            ? ElevatedButton(
                                style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        Colors.grey.shade300)),
                                onPressed: () {},
                                child: const Text('Continue'))
                            : ElevatedButton(
                                onPressed: () async {
                                  customerController.makeCustomerExist();
                                  Get.offAllNamed('/customer/dashboard');
                                },
                                child: const Text('Continue'))),
              ),
              SizedBox(
                  width: double.infinity,
                  child: OutlinedButton(
                      onPressed: () async {
                        customerController.makeCustomerExist();
                        Get.offAllNamed('/customer/dashboard');
                      },
                      child: const Text('Skip for Now')))
            ],
          ),
        ),
      ),
    );
  }
}
