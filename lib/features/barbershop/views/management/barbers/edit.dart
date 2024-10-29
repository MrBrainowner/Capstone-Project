import 'dart:io';
import 'package:barbermate/data/models/barber_model/barber_model.dart';
import 'package:barbermate/features/barbershop/controllers/barbers_controller/barbers_controller.dart';
import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../auth/views/sign_in/sign_in_widgets/textformfield.dart';

class EditBarberPage extends StatelessWidget {
  EditBarberPage({super.key, required this.barberModel});

  final BarberModel barberModel;
  final validator = Get.put(ValidatorController());
  final controller = Get.put(BarberController());
  final ImagePicker picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    // Prepopulate the text controller with the barber's current name
    controller.nameController.text = barberModel.fullName;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => controller.resetForm(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Edit Barber'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: controller.addBarberFormKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () async {
                    final XFile? pickedFile = await picker.pickImage(
                      source: ImageSource.gallery,
                    );
                    if (pickedFile != null) {
                      // Update the image file in the controller
                      controller.imageFile.value = File(pickedFile.path);
                    }
                  },
                  child: Obx(() => Container(
                        height: 200,
                        width: 200,
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(10)),
                          color: Colors.grey[300], // Background color
                        ),
                        child: controller.imageFile.value != null
                            ? ClipRRect(
                                borderRadius:
                                    const BorderRadius.all(Radius.circular(10)),
                                child: Image.file(
                                  controller.imageFile.value!,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : barberModel.profileImage.isNotEmpty
                                ? ClipRRect(
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(10)),
                                    child: Image.network(
                                      barberModel.profileImage,
                                      fit: BoxFit.cover,
                                    ),
                                  )
                                : const Center(
                                    child: Text(
                                      'No Image Selected',
                                      style: TextStyle(
                                        fontSize: 16,
                                        color: Colors.black54,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                      )),
                ),
                const SizedBox(height: 20),
                MyTextField(
                  validator: validator.validateEmpty,
                  controller: controller.nameController,
                  labelText: 'Barber Name',
                  obscureText: false,
                  icon: null,
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () {
                          controller.resetForm();
                          Get.back();
                        },
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          await controller.updateBarber(
                              updatedBarber: barberModel,
                              docId: barberModel.id.toString());
                        },
                        child: const Text('Update Barber'),
                      ),
                    ),
                  ],
                ),
                Expanded(
                    child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                              onPressed: () {
                                controller
                                    .deleteBarber(barberModel.id.toString());
                                Get.back();
                              },
                              child: const Text('Delete this Barber')),
                        ),
                      ],
                    )
                  ],
                ))
              ],
            ),
          ),
        ),
      ),
    );
  }
}
