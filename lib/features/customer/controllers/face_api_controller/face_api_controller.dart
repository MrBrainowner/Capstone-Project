import 'dart:io';
import 'dart:typed_data';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tflite_flutter/tflite_flutter.dart';
import 'package:logger/logger.dart';
import 'package:image/image.dart'
    as img; // Make sure to include this package in your pubspec.yaml

class FaceApiController extends GetxController {
  static FaceApiController get instance => Get.find();

  var faceData = <String>[].obs;
  var isLoading = false.obs;
  var errorMessage = ''.obs;

  final ImagePicker _picker = ImagePicker();
  var pickedImage = Rx<File?>(null);
  final Logger logger = Logger();
  late Interpreter interpreter; // Declare Interpreter

  // Load the model directly from assets
  Future<void> loadModel() async {
    try {
      interpreter = await Interpreter.fromAsset(
          'assets/models/face_shape_classifier.tflite');
      logger.i('Model loaded successfully');
    } catch (e) {
      logger.e('Error loading model: $e');
    }
  }

  Future<void> pickImage(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      pickedImage.value = File(pickedFile.path);

      // Validate image before analysis
      final fileLength = await pickedImage.value!.length();
      if (fileLength > 4 * 1024 * 1024) {
        errorMessage.value = 'Image size exceeds the 4MB limit.';
        return;
      }

      await analyzeAndSuggestHairstyle(pickedImage.value!);
    } else {
      errorMessage.value = 'No image selected';
    }
  }

  Future<void> analyzeFaceShape(File imageFile) async {
    isLoading.value = true;
    errorMessage.value = '';

    try {
      final imageBytes = await imageFile.readAsBytes();
      final inputBytes = preprocessImage(imageBytes); // Preprocess the image

      // Perform inference using the loaded model
      final faceShape = await runModelInference(inputBytes);

      if (faceShape != null) {
        faceData.value = [faceShape];
      } else {
        errorMessage.value = 'Failed to classify face shape.';
        logger.e('Face shape classification failed.');
      }
    } catch (e) {
      logger.e('Error analyzing face: $e');
      errorMessage.value = 'Failed to analyze image: $e';
    } finally {
      isLoading.value = false;
    }
  }

  Uint8List preprocessImage(Uint8List imageBytes) {
    // Decode the image
    img.Image? image = img.decodeImage(imageBytes);
    if (image == null) {
      throw Exception("Failed to decode image");
    }

    // Resize the image to match the model input requirements (224x224)
    img.Image resizedImage = img.copyResize(image, width: 224, height: 224);

    // Create a new list to hold the tensor input data
    List<double> input = [];

    // Process each pixel in the resized image
    for (int y = 0; y < resizedImage.height; y++) {
      for (int x = 0; x < resizedImage.width; x++) {
        // Get the pixel value as a Pixel object
        img.Pixel pixel = resizedImage.getPixel(x, y);

        // Extract RGB components from the Pixel object
        double r = pixel.r / 255.0; // Red channel
        double g = pixel.g / 255.0; // Green channel
        double b = pixel.b / 255.0; // Blue channel

        // Add the normalized values to the input list
        input.add(r);
        input.add(g);
        input.add(b);
      }
    }

    // Flatten the list into a Float32List
    Float32List floatInput = Float32List.fromList(input);

    // Ensure the input has the right shape
    if (floatInput.length != 150528) {
      throw Exception(
          "Unexpected input size: ${floatInput.length}. Expected 150528.");
    }

    // Return as Uint8List for model input
    return floatInput.buffer.asUint8List();
  }

  Future<String?> runModelInference(Uint8List inputBytes) async {
    // Create input tensor and output tensor
    var input = inputBytes
        .reshape([1, 224, 224, 3]); // Adjust based on the model input shape
    var output =
        List.filled(1, 0.0).reshape([1, 1]); // Adjust output shape if needed

    // Run the model inference
    interpreter.run(input, output);

    return output[0].toString(); // Return the result
  }

  String suggestHairstyle(String faceShape) {
    switch (faceShape) {
      case 'Oval':
        return 'You have an oval face shape. Long, layered cuts will enhance your features.';
      case 'Square':
        return 'You have a square face shape. Try softening your angles with layered cuts.';
      case 'Round':
        return 'You have a round face shape. Long hairstyles can help elongate your appearance.';
      case 'Heart':
        return 'You have a heart face shape. A side part with volume can balance out your features.';
      case 'Diamond':
        return 'You have a diamond face shape. Long hairstyles with layers can enhance your features.';
      default:
        return 'Unknown face shape. Please try a different image.';
    }
  }

  Future<void> analyzeAndSuggestHairstyle(File imageFile) async {
    await analyzeFaceShape(imageFile);
    if (faceData.isNotEmpty) {
      final hairstyleSuggestion = suggestHairstyle(faceData[0]);
      faceData.add(hairstyleSuggestion); // Add hairstyle suggestion to faceData
    }
  }

  @override
  void onClose() {
    interpreter.close(); // Make sure to close the interpreter
    super.onClose();
  }
}
