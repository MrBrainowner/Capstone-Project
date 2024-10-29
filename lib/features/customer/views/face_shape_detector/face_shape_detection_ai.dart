import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import '../../controllers/face_api_controller/face_api_controller.dart';

class FaceShapeDetectionAi extends StatelessWidget {
  const FaceShapeDetectionAi({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(FaceApiController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommend Hairstyle'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Buttons to capture a selfie or pick an image
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () => controller.pickImage(ImageSource.camera),
                  child: const Text('Capture Selfie'),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: () => controller.pickImage(ImageSource.gallery),
                  child: const Text('Upload from Gallery'),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Show the selected image
            Obx(() {
              if (controller.pickedImage.value != null) {
                return Image.file(
                  controller.pickedImage.value!,
                  height: 200,
                  fit: BoxFit.cover,
                );
              } else {
                return const Text('No image selected');
              }
            }),

            const SizedBox(height: 20),

            // Show loading or error message
            Obx(() {
              if (controller.isLoading.value) {
                return const CircularProgressIndicator();
              }
              if (controller.errorMessage.isNotEmpty) {
                return Text(
                  'Error: ${controller.errorMessage.value}',
                  style: const TextStyle(color: Colors.red),
                );
              }
              return const SizedBox.shrink();
            }),

            const SizedBox(height: 20),

            // Button to analyze and suggest hairstyle
            ElevatedButton(
              onPressed: () {
                if (controller.pickedImage.value != null) {
                  controller.analyzeAndSuggestHairstyle(
                      controller.pickedImage.value!);
                } else {
                  Get.snackbar('Error', 'Please select an image first');
                }
              },
              child: const Text('Analyze Face and Suggest Hairstyle'),
            ),
          ],
        ),
      ),
    );
  }
}
