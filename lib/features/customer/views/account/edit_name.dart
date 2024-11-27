import 'package:barbermate/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditName extends StatelessWidget {
  const EditName({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final CustomerController controller = Get.find();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit'),
        centerTitle: true,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: [
              const Text('Edit your first name and last name'),
              const SizedBox(height: 20),
              MyTextField(
                controller: controller.firstName,
                keyboardtype: TextInputType.name,
                validator: (value) => validator.validateEmpty(value),
                labelText: controller.customer.value.firstName,
                obscureText: false,
                icon: const Icon(Icons.person),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: controller.lastName,
                keyboardtype: TextInputType.name,
                validator: (value) => validator.validateEmpty(value),
                labelText: controller.customer.value.lastName,
                obscureText: false,
                icon: const Icon(Icons.person),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      await controller.saveCustomerData(
                          firstNamee: controller.firstName.text.trim(),
                          lastNamee: controller.lastName.text.trim());
                      Get.back();
                    },
                    child: const Text('Update')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
