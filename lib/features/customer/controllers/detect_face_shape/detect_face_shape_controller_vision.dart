import 'dart:math'; // Add this import for sqrt() method
import 'dart:io';
import 'dart:ui';
import 'package:get/get.dart';
import 'package:google_mlkit_face_mesh_detection/google_mlkit_face_mesh_detection.dart';
import 'package:image_picker/image_picker.dart';

class FaceMeshController extends GetxController {
  var pickedImagePath = ''.obs;
  RxList<FaceMesh> faceMeshList = <FaceMesh>[].obs;
  var faceShape = ''.obs; // To store the detected face shape
  final ImagePicker _picker = ImagePicker();

  // Pick an image from the gallery
  Future<void> pickImageFromGallery() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        pickedImagePath.value = pickedFile.path;
        await processImage(File(pickedFile.path));
      }
    } catch (e) {
      print("Error picking image: $e");
    }
  }

  // Pick an image from the camera
  Future<void> pickImageFromCamera() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.camera);
      if (pickedFile != null) {
        pickedImagePath.value = pickedFile.path;
        await processImage(File(pickedFile.path));
      }
    } catch (e) {
      print("Error picking image from camera: $e");
    }
  }

  // Process the selected image to detect face mesh
  Future<void> processImage(File image) async {
    final inputImage = InputImage.fromFile(image);
    final faceMeshDetector =
        FaceMeshDetector(option: FaceMeshDetectorOptions.faceMesh);
    final faceMeshes = await faceMeshDetector.processImage(inputImage);

    if (faceMeshes.isNotEmpty) {
      faceMeshList.clear();
      faceMeshList.addAll(faceMeshes);
      classifyFaceShape(faceMeshes
          .first); // Classify face shape based on the first detected face
    } else {
      print("No face detected.");
    }

    // Update the state
    update();
    await faceMeshDetector.close();
  }

  // Classify the face shape based on face mesh points
  void classifyFaceShape(FaceMesh faceMesh) {
    // Extract key landmarks for classification (e.g., jawline, cheeks, chin)
    final jawWidth = calculateJawWidth(faceMesh);
    final faceLength = calculateFaceLength(faceMesh);
    final faceWidth = calculateFaceWidth(faceMesh);

    if (faceWidth / faceLength > 1.2 && jawWidth / faceWidth > 0.7) {
      faceShape.value = 'Square';
    } else if (faceWidth / faceLength < 0.9) {
      faceShape.value = 'Oval';
    } else if (faceWidth / faceLength >= 0.9 && faceWidth / faceLength <= 1.1) {
      if (jawWidth / faceWidth < 0.5) {
        faceShape.value = 'Round';
      } else {
        faceShape.value = 'Rectangular';
      }
    } else {
      faceShape.value = 'Unknown';
    }
  }

  // Calculate the jaw width (example based on landmarks)
  double calculateJawWidth(FaceMesh faceMesh) {
    // Calculate the distance between the jawline points (e.g., between point 156-163)
    final point1 = faceMesh.points[156];
    final point2 = faceMesh.points[163];
    return distanceBetweenPoints(point1, point2);
  }

  // Calculate the face width (e.g., between points 4-10)
  double calculateFaceWidth(FaceMesh faceMesh) {
    final point1 = faceMesh.points[4];
    final point2 = faceMesh.points[10];
    return distanceBetweenPoints(point1, point2);
  }

  // Calculate the face length (e.g., from point 10 to point 152)
  double calculateFaceLength(FaceMesh faceMesh) {
    final point1 = faceMesh.points[10];
    final point2 = faceMesh.points[152];
    return distanceBetweenPoints(point1, point2);
  }

  // Calculate the distance between two points (now using FaceMeshPoint directly)
  double distanceBetweenPoints(FaceMeshPoint point1, FaceMeshPoint point2) {
    final dx = point1.x - point2.x;
    final dy = point1.y - point2.y;
    return sqrt(dx * dx + dy * dy); // Use sqrt from dart:math
  }

  @override
  void onClose() {
    super.onClose();
  }
}
