import 'dart:io';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/utils/popups/full_screen_loader.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:path/path.dart';
import '../../../../common/widgets/toast.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();
  final barbershop = Get.put(BarbershopController.instance.barbershop);
  final Logger logger = Logger();

  // List of required document types
  final List<String> requiredDocumentTypes = [
    'business_registration',
    'barangay_clearance',
    'mayors_permit',
    'fire_safety_certificate',
    'sanitation_permit',
    'proof_of_address',
  ];

  // Store the selected files in a map where the key is the document type
  final RxMap<String, File?> selectedFiles = <String, File?>{}.obs;

  Future<void> pickFile(String documentType) async {
    // print('Button pressed for: $documentType');
    final result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'jpg', 'jpeg', 'png'],
    );

    if (result != null) {
      final file = File(result.files.single.path!);
      selectedFiles[documentType] = file;
      logger.d('File selected: ${file.path}');
    } else {
      logger.d('No file selected');
    }
  }

  Future<void> submitFiles() async {
    // Check if all required files are present
    for (final documentType in requiredDocumentTypes) {
      if (!selectedFiles.containsKey(documentType) ||
          selectedFiles[documentType] == null) {
        // Show an error notification if any file is missing
        ToastNotif(
                message:
                    'Please upload all required documents before submitting.',
                title: 'Incomplete Files')
            .showErrorNotif(Get.context!);
        return;
      }
    }

    try {
      FullScreenLoader.openLoadingDialog(
          'Uploading Files. This may take some time...',
          'assets/images/animation.json');

      for (final entry in selectedFiles.entries) {
        final documentType = entry.key;
        final file = entry.value;
        if (file != null) {
          await uploadFile(file, documentType);
        }
      }

      logger.i('All files uploaded successfully');
    } catch (e) {
      FullScreenLoader.stopLoading();
      logger.e('Error uploading files: $e'); // Log stack trace
      ToastNotif(message: e.toString(), title: 'Oh Snap!')
          .showErrorNotif(Get.context!);
    } finally {
      Get.back();
      FullScreenLoader.stopLoading();
      ToastNotif(message: 'File Upload Successful', title: 'Success')
          .showSuccessNotif(Get.context!);
    }
  }

  Future<void> uploadFile(File file, String documentType) async {
    const int maxRetries = 3; // Set the maximum number of retry attempts
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final fileName = '${documentType}_${basename(file.path)}';
        final storageRef = FirebaseStorage.instance.ref().child(
            'Barbershops/${AuthenticationRepository.instance.authUser?.uid}/documents/$fileName');

        final uploadTask = storageRef.putFile(file);

        await uploadTask.whenComplete(() => null);
        final downloadUrl = await storageRef.getDownloadURL();

        // Save the download URL to Firestore
        await FirebaseFirestore.instance
            .collection('Barbershops')
            .doc(AuthenticationRepository.instance.authUser?.uid)
            .collection('Business_Documents')
            .doc(documentType)
            .set({documentType: downloadUrl});

        logger.i('File uploaded successfully: $downloadUrl');
        return; // Exit the function on successful upload
      } catch (e) {
        attempt++;
        logger.e('Error uploading file on attempt $attempt: $e');

        // Check if we've reached the maximum number of attempts
        if (attempt >= maxRetries) {
          // Show a toast notification for failure
          ToastNotif(
                  message:
                      'Failed to upload $documentType after $maxRetries attempts. Please check your internet connection.',
                  title: 'Upload Failed')
              .showErrorNotif(Get.context!);

          // Optionally, you can navigate back or handle it as needed
          Get.back();
          return; // Exit the function after showing the toast
        }

        // Optional: Delay before the next attempt
        await Future.delayed(
            const Duration(seconds: 2)); // 2 seconds delay before retrying
      }
    }
  }
}
