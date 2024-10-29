import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../../utils/validators/validators.dart';
import '../../../controllers/signup_controller/barbershop_sign_up_controller.dart';
import '../../sign_in/sign_in_widgets/textformfield.dart';

class Step3 extends StatelessWidget {
  const Step3({super.key});

  @override
  Widget build(BuildContext context) {
    final validator = Get.put(ValidatorController());
    final controller = Get.put(BarbershopSignUpController());
    return Column(
      children: [
        Text('Add details', style: Theme.of(context).textTheme.titleMedium),
        const SizedBox(height: 10),
        Form(
            key: controller.signUpFormKey3,
            child: Column(
              children: [
                MyTextField(
                    controller: controller.address,
                    validator: (value) => validator.validateEmpty(value),
                    labelText: 'Complete Address',
                    obscureText: false,
                    icon: const Icon(Icons.place_outlined)),
                const SizedBox(height: 10),
                MyTextField(
                    controller: controller.landMark,
                    labelText: 'Nearby Landmark(optional)',
                    obscureText: false,
                    icon: const Icon(Icons.flag_outlined)),
                const SizedBox(height: 10),
                MyTextField(
                  controller: controller.postalCode,
                  validator: (value) => validator.validatePostalCode(value),
                  labelText: 'Postal Code',
                  obscureText: false,
                  icon: const Icon(Icons.numbers),
                ),
                const SizedBox(height: 10),
                MyTextField(
                  controller: controller.floorUnit,
                  labelText: 'Floor Number(optional)',
                  obscureText: false,
                  icon: const Icon(Icons.apartment_outlined),
                ),
              ],
            )),
        const SizedBox(height: 10),
      ],
    );
  }
}
