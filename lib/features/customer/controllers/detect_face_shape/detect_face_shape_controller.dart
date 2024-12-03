import 'dart:io';
import 'package:flutter_tflite/flutter_tflite.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';

class DetectFaceShape extends GetxController {
  static DetectFaceShape get instance => Get.find();
  Rx<File?> selectedImage = Rx<File?>(null);
  RxString faceShapeResult = ''.obs;
  final ImagePicker picker = ImagePicker();
  var confidence = 0.0;
  var label = '';
  Logger logger = Logger();

  @override
  void onInit() {
    super.onInit();
    _tfliteInit();
  }

  Future<void> selectImage() async {
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      selectedImage.value = File(image.path);
      runModel(image.path); // Run model after selecting the image
    }
  }

  Future<void> openCamera() async {
    final XFile? image = await picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      selectedImage.value = File(image.path);
      runModel(image.path); // Run model after capturing the image
    }
  }

  Future<void> _tfliteInit() async {
    String? result = await Tflite.loadModel(
      model: "assets/models/model_unquant.tflite",
      labels: "assets/models/labels.txt",
      numThreads: 1,
      isAsset: true,
      useGpuDelegate: false,
    );
    logger.e("TFLite Model Loaded: $result");
  }

  Future<void> runModel(String imagePath) async {
    var recognitions = await Tflite.runModelOnImage(
      path: imagePath, // Path of the selected image
      imageMean: 0.0,
      imageStd: 255.0,
      numResults: 4, // Adjust based on your model
      threshold: 0.2,
      asynch: true,
    );

    if (recognitions != null && recognitions.isNotEmpty) {
      confidence = (recognitions[0]['confidence'] * 100);
      label = recognitions[0]['lable'].toString();
      faceShapeResult.value = recognitions[0]['label'];
      logger.e("Detected Face Shape: ${faceShapeResult.value}");
      logger.e("Confidence: $confidence");
      logger.e("Label: $label");
    } else {
      faceShapeResult.value =
          "No face detected"; // Don't set a default face shape
      logger.e("No face detected in the image.");
    }
  }

  @override
  void onClose() {
    super.onClose();
    Tflite.close(); // Unload model when controller is closed
  }
}
