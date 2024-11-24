import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/haircut_repository.dart';
import '../../../../utils/popups/full_screen_loader.dart';
import '../barbershop_controller/barbershop_controller.dart';

class HaircutController extends GetxController {
  static HaircutController get instance => Get.find();

  final barbershopController = Get.put(BarbershopController());

  final HaircutRepository _haircutRepository = HaircutRepository();

  final nameController = TextEditingController();
  final descriptionController = TextEditingController();
  final priceController = TextEditingController();
  final durationController = TextEditingController();

  RxList<HaircutModel> haircuts = <HaircutModel>[].obs;

  var isLoading = true.obs;
  var imageUrls = <String>[].obs;
  RxList<File> tempImageFiles = <File>[].obs;
  var toBeDeletedImageUrls = <String>[].obs;

  var selectedCategories = <String>[].obs;

  GlobalKey<FormState> addHaircutFormKey = GlobalKey<FormState>();

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void onInit() async {
    super.onInit();
    fetchHaircuts();
  }

  void resetForm() {
    nameController.clear();
    descriptionController.clear();
    priceController.clear();
    durationController.clear();
    selectedCategories.clear();
    toBeDeletedImageUrls.clear();
  }

  Future<void> addHaircut() async {
    if (addHaircutFormKey.currentState?.validate() ?? false) {
      // Check if an image is selected
      if (tempImageFiles.isEmpty && selectedCategories.isEmpty) {
        // Show a warning if no image is selected
        ToastNotif(message: 'Image and Categoris is required', title: 'Error')
            .showErrorNotif(Get.context!);
        return;
      }
      try {
        FullScreenLoader.openLoadingDialog(
            'Adding Haircut...', 'assets/images/animation.json');

        // Create a HaircutModel with initial data
        final tempHaircut = HaircutModel(
          name: nameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          duration: int.parse(durationController.text),
          category: selectedCategories,
          imageUrls: [], // Empty list for now, will be updated after uploading images
          createdAt: DateTime.now(), id: '',
        );

        // Add the haircut model to Firestore and get the document ID
        final haircutId = await _haircutRepository.addHaircut(tempHaircut);

        // Upload images using the document ID to create the folder
        final imageUrls = await uploadImages(
            tempImageFiles.map((file) => XFile(file.path)).toList(), haircutId);

        // Update the Firestore document with image URLs
        await _haircutRepository.updateHaircutImages(haircutId, imageUrls);

        ToastNotif(
                message: 'Haircut added successfully',
                title: 'New Haircut Added')
            .showSuccessNotif(Get.context!);
        fetchHaircuts();
        tempImageFiles.clear();
        Get.back();
      } catch (e) {
        ToastNotif(message: e.toString(), title: 'Error adding haircut')
            .showErrorNotif(Get.context!);
      } finally {
        FullScreenLoader.stopLoading();
      }
    }
  }

  Future<List<String>> uploadImages(
      List<XFile> imageFiles, String haircutId) async {
    return await _haircutRepository.uploadImageToStorage(imageFiles, haircutId);
  }

  Future<void> updateHaircut(HaircutModel haircut) async {
    if (addHaircutFormKey.currentState?.validate() ?? false) {
      // Check if an image is selected
      if (tempImageFiles.isEmpty && selectedCategories.isEmpty) {
        // Show a warning if no image is selected
        ToastNotif(message: 'Image and Categoris is required', title: 'Error')
            .showErrorNotif(Get.context!);
        return;
      }

      try {
        FullScreenLoader.openLoadingDialog(
            'Updating Haircut...', 'assets/images/animation.json');

        // Upload images first and get their URLs

        final haircutUpdate = haircut.copyWith(
          name: nameController.text,
          description: descriptionController.text,
          price: double.parse(priceController.text),
          duration: int.parse(durationController.text),
          category: selectedCategories,
        );

        await _haircutRepository.updateHaircut(
            haircut.id.toString(), haircutUpdate);

        final imageUrls = await uploadImages(
            tempImageFiles.map((file) => XFile(file.path)).toList(),
            haircut.id.toString());
        // logger.i('Temp Image Files: ${tempImageFiles.toString()}');

        await _haircutRepository.addHaircutImages(
            haircut.id.toString(), imageUrls);
        if (toBeDeletedImageUrls.isNotEmpty) {
          await deleteImages(haircut.id.toString(), toBeDeletedImageUrls);
        }
        ToastNotif(
                message: 'Haicut updated successfuly', title: 'Haircut Updated')
            .showSuccessNotif(Get.context!);
        tempImageFiles.clear();
        // Reset deletion list
        toBeDeletedImageUrls.clear();
        Get.back();
      } catch (e) {
        ToastNotif(message: 'Error updaing haircuts', title: 'Error')
            .showErrorNotif(Get.context!);
      } finally {
        fetchHaircuts();
        FullScreenLoader.stopLoading();
      }
    }
  }

  Future<void> deleteHaircut(String haircutId) async {
    FullScreenLoader.openLoadingDialog(
        'Deleting Haircut...', 'assets/images/animation.json');

    try {
      await _haircutRepository.deleteHaircut(haircutId);
      ToastNotif(
              message: 'Haicut deleted successfuly', title: 'Haircut Deleted')
          .showSuccessNotif(Get.context!);
      resetForm();
    } catch (e) {
      ToastNotif(message: 'Error deleting haircuts', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      ToastNotif(
              message: 'Haicut deleted successfuly', title: 'Haircut Deleted')
          .showSuccessNotif(Get.context!);
      fetchHaircuts();
      FullScreenLoader.stopLoading();
    }
  }

  Future<void> fetchHaircuts() async {
    try {
      isLoading(true);
      haircuts.value = await _haircutRepository.fetchHaircuts();
    } catch (e) {
      ToastNotif(message: 'Error Fetching Haircuts', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading(false);
    }
  }

  void removeCategory(String category) {
    selectedCategories.remove(category);
  }

  void removeImage(String url) {
    imageUrls.remove(url);
  }

  void removeTempImage(File file) {
    tempImageFiles.remove(file);
  }

  Future<void> deleteImages(String id, List<String> imageUrl) async {
    try {
      await _haircutRepository.deleteImageAndRemoveUrl(id, imageUrl);
      await fetchHaircuts();
    } catch (e) {
      ToastNotif(message: 'Error deleting image', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> handleImageSelection(List<XFile> files) async {
    try {
      if (files.isNotEmpty) {
        final fileList = files.map((xFile) => File(xFile.path)).toList();
        tempImageFiles.addAll(fileList);
      }
    } catch (e) {
      ToastNotif(message: 'Error selecting images', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }
}
