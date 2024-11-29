import 'package:barbermate/features/customer/controllers/detect_face_shape/detect_face_shape_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestHaircutAiPage extends StatelessWidget {
  const SuggestHaircutAiPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DetectFaceShape());

    return Scaffold(
        appBar: AppBar(
          title: const Text('Recommend Hairstyle'),
          centerTitle: true,
        ),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: Center(
              child: Column(
            children: [
              Obx(() => controller.selectedImage.value != null
                  ? Image.file(controller.selectedImage.value!)
                  : const Text("No image selected.")),
              Obx(() => Text(
                  "Detected Face Shape: ${controller.faceShapeResult.value}")),
              ElevatedButton(
                onPressed: () async {
                  await controller.selectImage();
                },
                child: const Text('Select Image'),
              ),
              ElevatedButton(
                onPressed: () async {
                  await controller.openCamera();
                },
                child: const Text('Open Camera'),
              ),
            ],
          )),
        ));
  }
}
