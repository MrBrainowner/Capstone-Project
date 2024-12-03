import 'package:barbermate/features/auth/views/sign_in/sign_in_widgets/textformfield.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/change_email_controller_barbershop/barbershop_change_email_controller.dart';
import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbershopEditEmail extends StatelessWidget {
  const BarbershopEditEmail({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final ChangeEmailControllerBarbershop controller = Get.find();

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
              const Text('Update Email'),
              const SizedBox(height: 20),
              MyTextField(
                controller: controller.email,
                keyboardtype: TextInputType.name,
                validator: (value) => validator.validateEmpty(value),
                labelText: 'Email',
                obscureText: false,
                icon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 10),
              MyTextField(
                controller: controller.password,
                keyboardtype: TextInputType.name,
                validator: (value) => validator.validateEmpty(value),
                labelText: 'Enter current password',
                obscureText: false,
                icon: const Icon(Icons.email_outlined),
              ),
              const SizedBox(height: 15),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                    onPressed: () async {
                      controller.changeEmailProcess(
                          controller.password.text.trim(),
                          controller.email.text.trim());
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
