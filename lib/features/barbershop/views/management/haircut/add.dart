import 'dart:io';
import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../auth/views/sign_in/sign_in_widgets/textformfield.dart';
import '../../../controllers/haircuts_controller/haircuts_controller.dart';

class HaircutAddPage extends StatelessWidget {
  const HaircutAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HaircutController());
    final validator = Get.put(ValidatorController());

    return PopScope(
      canPop: true,
      onPopInvokedWithResult: (didPop, dynamic) => controller.resetForm(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Add New Haircut'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: controller.addHaircutFormKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final XFile? pickedFile =
                          await controller.picker.pickImage(
                        source: ImageSource.gallery,
                      );
                      if (pickedFile != null) {
                        // Save the image file
                        controller.selectedImage.value = File(pickedFile.path);
                      }
                    },
                    child: Obx(() => Container(
                          height: 200,
                          width: 200,
                          decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(10)),
                            color: Colors.grey[
                                300], // Background color when no image is selected
                          ),
                          child: controller.selectedImage.value != null
                              ? ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image.file(
                                    controller.selectedImage.value!,
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
                  const SizedBox(height: 10),
                  const Text('Tap above to upload image'),
                  const SizedBox(height: 20),
                  MyTextField(
                    validator: validator.validateEmpty,
                    controller: controller.nameController,
                    labelText: 'Name',
                    obscureText: false,
                    icon: null,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: MyTextField(
                          validator: validator.validateEmpty,
                          controller: controller.priceController,
                          labelText: 'Price',
                          obscureText: false,
                          icon: null,
                          keyboardtype: TextInputType.number,
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: MyTextField(
                          validator: validator.validateEmpty,
                          controller: controller.durationController,
                          labelText: 'Duration (Minutes)',
                          obscureText: false,
                          icon: null,
                          keyboardtype: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Selected Categories:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Get.back();
                            controller.resetForm();
                          },
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await controller.addHaircut(); // Updated method
                          },
                          child: const Text('Add Haircut'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
