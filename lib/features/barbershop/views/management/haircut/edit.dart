import 'dart:io';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../../../../utils/validators/validators.dart';
import '../../../../auth/views/sign_in/sign_in_widgets/textformfield.dart';
import '../../../controllers/haircuts_controller/haircuts_controller.dart';
import 'category_selection_modal.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class HaircutEditPage extends StatelessWidget {
  const HaircutEditPage({super.key, required this.haircut});

  final HaircutModel haircut;

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HaircutController());
    final validator = Get.put(ValidatorController());

    controller.nameController.text = haircut.name;
    controller.descriptionController.text = haircut.description;
    controller.priceController.text = haircut.price.toString();
    controller.durationController.text = haircut.duration.toString();
    controller.selectedCategories.value = haircut.category;
    controller.imageUrls.value = haircut.imageUrls;

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) => controller.resetForm(),
      child: Scaffold(
        appBar: AppBar(
          actions: [
            GestureDetector(
              onTap: () {
                controller.deleteHaircut(haircut.id.toString());
                Get.back();
              }, // Navigate to notifications
              child: const iconoir.Trash(
                height: 25, // Bell Icon height
              ),
            ),
            const SizedBox(width: 15),
          ],
          title: const Text('Edit Haircut'),
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
                      spacing: 8.0,
                      runSpacing: 4.0,
                      children: controller.selectedCategories
                          .map((category) => Chip(
                                label: Text(category),
                                deleteIcon: const Icon(Icons.cancel),
                                onDeleted: () {
                                  controller.removeCategory(category);
                                },
                                deleteIconColor:
                                    Theme.of(context).iconTheme.color,
                                labelPadding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
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
                    return Column(
                      children: [
                        // Display images from the imageUrls list
                        Wrap(
                          spacing: 8.0,
                          runSpacing: 4.0,
                          children: controller.imageUrls
                              .where((url) => !controller.toBeDeletedImageUrls
                                  .contains(url))
                              .map((url) => Stack(
                                    clipBehavior: Clip.none,
                                    children: [
                                      Image.network(
                                        url,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ),
                                      Positioned(
                                        top: 0,
                                        right: 0,
                                        child: IconButton(
                                          icon: Icon(
                                            controller.toBeDeletedImageUrls
                                                    .contains(url)
                                                ? Icons.check_circle
                                                : Icons.delete,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {
                                            if (controller.toBeDeletedImageUrls
                                                .contains(url)) {
                                              // Remove from deletion list
                                              controller.toBeDeletedImageUrls
                                                  .remove(url);
                                            } else {
                                              // Add to deletion list
                                              controller.toBeDeletedImageUrls
                                                  .add(url);
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ))
                              .toList(),
                        ),

                        // Add a gap between image sections if needed
                        const SizedBox(height: 16.0),

                        // Display temporary images from tempImageFiles
                        Wrap(
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
                        ),
                      ],
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
                            await controller.updateHaircut(haircut);
                          },
                          child: const Text('Update Haircut'),
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
