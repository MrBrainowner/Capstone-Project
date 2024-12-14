import 'dart:io';
import 'package:barbermate/utils/popups/full_screen_loader.dart';
import 'package:file_picker/file_picker.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/documents_verification_repo.dart';

class VerificationController extends GetxController {
  static VerificationController get instance => Get.find();
  final VerificationRepo verificationRepo = Get.find();
  final Logger logger = Logger();

  // List of required document types
  final List<String> requiredDocumentTypes = [
    'business_registration',
    'barangay_clearance',
    'mayors_permit',
  ].obs;

  // A map to hold selected files for each document type
  final RxMap<String, File?> selectedFiles = <String, File?>{}.obs;

  @override
  void onInit() {
    super.onInit();
    loadDocumentStatus();
  }

  // Load the current status of the documents (whether uploaded or not)
  Future<void> loadDocumentStatus() async {
    try {
      final documents = await verificationRepo.fetchDocuments();

      // Update the selected files based on the existing documents
      for (var document in documents) {
        selectedFiles[document.documentType] = File(document.documentURL);
      }
    } catch (e) {
      logger.e('Error loading document status: $e');
    }
  }

  // Pick file for a document
  // Method to pick a file and update the map
  Future<void> pickFile(String documentType) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles();

      if (result != null && result.files.single.path != null) {
        // Update the map and trigger reactivity
        selectedFiles[documentType] = File(result.files.single.path!);
        selectedFiles.refresh(); // Important to trigger UI updates
        logger
            .i('File selected for $documentType: ${result.files.single.path}');
      } else {
        logger.w('No file selected for $documentType');
      }
    } catch (e) {
      logger.e('Error picking file for $documentType: $e');
    }
  }

  // Method to submit the uploaded files
  Future<void> submitFiles() async {
    // Ensure all required documents are selected before submitting
    for (var documentType in requiredDocumentTypes) {
      if (selectedFiles[documentType] == null) {
        ToastNotif(
                message: 'Please select the $documentType document',
                title: 'Missing Document')
            .showErrorNotif(Get.context!);
        return;
      }
    }

    try {
      FullScreenLoader.openLoadingDialog(
          'Uploading Files...', 'assets/images/animation.json');

      for (var documentType in requiredDocumentTypes) {
        final file = selectedFiles[documentType];
        if (file != null) {
          await verificationRepo.uploadFile(file, documentType);
        }
      }

      logger.i('All files uploaded successfully');
      ToastNotif(message: 'File Upload Successful', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      FullScreenLoader.stopLoading();
      logger.e('Error uploading files: $e');
      ToastNotif(message: e.toString(), title: 'Upload Failed')
          .showErrorNotif(Get.context!);
    } finally {
      Get.back();
      FullScreenLoader.stopLoading();
    }
  }
}
