import 'dart:io';

import 'package:barbermate/utils/validators/validators.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../../auth/views/sign_in/sign_in_widgets/textformfield.dart';
import '../../../controllers/haircuts_controller/haircuts_controller.dart';
import 'category_selection_modal.dart';

class HaircutAddPage extends StatelessWidget {
  const HaircutAddPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HaircutController());
    final validator = Get.put(ValidatorController());

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => controller.resetForm(),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  MyTextField(
                    validator: validator.validateEmpty,
                    controller: controller.nameController,
                    labelText: 'Name',
                    obscureText: false,
                    icon: null,
                  ),
                  const SizedBox(height: 10),
                  MyTextField(
                    validator: validator.validateEmpty,
                    controller: controller.descriptionController,
                    labelText: 'Description',
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
                  Obx(() {
                    return Wrap(
                      spacing: 5.0,
                      children: controller.selectedCategories
                          .map((category) => Chip(
                                label: Text(category),
                                deleteIcon: const Icon(Icons.cancel),
                                onDeleted: () {
                                  controller.removeCategory(category);
                                },
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0, vertical: 1),
                                deleteIconColor:
                                    Theme.of(context).iconTheme.color,
                                backgroundColor:
                                    Theme.of(context).chipTheme.backgroundColor,
                              ))
                          .toList(),
                    );
                  }),
                  const SizedBox(height: 20),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final List<String>? selectedCategories =
                                await Get.bottomSheet<List<String>>(
                                    const CategorySelectionBottomSheet());
                            if (selectedCategories != null) {
                              controller.selectedCategories.value =
                                  selectedCategories;
                            }
                          },
                          child: const Text('Select Category'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Upload Images:',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const SizedBox(height: 10),
                  Obx(() {
                    return Wrap(
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: controller.tempImageFiles
                          .map((file) => Stack(
                                clipBehavior: Clip.none,
                                children: [
                                  Image.file(
                                    file,
                                    width: 100,
                                    height: 100,
                                    fit: BoxFit.cover,
                                  ),
                                  Positioned(
                                    top: 0,
                                    right: 0,
                                    child: IconButton(
                                      icon: const Icon(Icons.cancel,
                                          color: Colors.red),
                                      onPressed: () {
                                        controller.removeTempImage(file);
                                      },
                                    ),
                                  ),
                                ],
                              ))
                          .toList(),
                    );
                  }),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            final picker = ImagePicker();
                            final pickedFiles = await picker.pickMultiImage();
                            if (pickedFiles.isNotEmpty) {
                              controller.tempImageFiles.addAll(
                                  pickedFiles.map((file) => File(file.path)));
                            }
                          },
                          child: const Text('Select Images'),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
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
