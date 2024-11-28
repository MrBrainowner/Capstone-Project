import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../data/models/barber_model/barber_model.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/barbers_repository.dart';
import '../../../../utils/popups/full_screen_loader.dart';

class BarberController extends GetxController {
  static BarberController get instance => Get.find();

  final BarbersRepository _barberRepository = Get.find();

  final nameController = TextEditingController();
  final RxString imageUrl = ''.obs;

  GlobalKey<FormState> addBarberFormKey = GlobalKey<FormState>();

  RxList<BarberModel> barbers = <BarberModel>[].obs;
  var workingHours = <String>[].obs;
  var isLoading = true.obs;
  var imageUrls = <String>[].obs;
  var selectedItem = ''.obs;
  var startTime = ''.obs;
  var endTime = ''.obs;
  var scheduleName = ''.obs;
  final _storage = GetStorage();
  final String schedulesKey = 'schedules';
  Rx<File?> imageFile = Rx<File?>(null);

  // Helper function to parse time strings to TimeOfDay
  TimeOfDay parseTime(String time) {
    final parts = time.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1].substring(0, 2));
    final ampm = parts[1].substring(2).toLowerCase();
    return TimeOfDay(
      hour: hour + (ampm == 'pm' ? 12 : 0),
      minute: minute,
    );
  }

  int timeToMinutes(TimeOfDay time) {
    return time.hour * 60 + time.minute;
  }

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  @override
  void onInit() {
    super.onInit();
    listenToBarbersStream(); // Start listening when the controller is initialized
  }

  //================================= selecting time
  bool isValidWorkingHour(String newStartTime, String newEndTime) {
    final newStart = parseTime(newStartTime);
    final newEnd = parseTime(newEndTime);

    final newStartMinutes = timeToMinutes(newStart);
    final newEndMinutes = timeToMinutes(newEnd);

    for (final workingHour in workingHours) {
      final parts = workingHour.split(' - ');
      final start = parseTime(parts[0]);
      final end = parseTime(parts[1]);

      final startMinutes = timeToMinutes(start);
      final endMinutes = timeToMinutes(end);

      // Check for overlap
      if ((newStartMinutes < endMinutes && newEndMinutes > startMinutes)) {
        return false;
      }
    }

    return true;
  }

  void addWorkingHour() {
    if (startTime.value.isNotEmpty && endTime.value.isNotEmpty) {
      final newStartTime = startTime.value;
      final newEndTime = endTime.value;

      if (isValidWorkingHour(newStartTime, newEndTime)) {
        workingHours.add('$newStartTime - $newEndTime');
        startTime.value = ''; // Reset after adding
        endTime.value = ''; // Reset after adding
      }
    }
  }

  void removeWorkingHour(String workingHour) {
    workingHours.remove(workingHour);
  }

  void saveWorkingHoursToFirebase() {
    // Implement Firebase save functionality here
  }

  void resetForm() {
    nameController.clear();
    imageFile.value = null;
  }

  void changeItem(String newValue) {
    selectedItem.value = newValue;
  }

  void setStartTime(String time) {
    startTime.value = time;
  }

  void setEndTime(String time) {
    endTime.value = time;
  }

  //================================= adding barber
  Future<void> addBarber() async {
    FullScreenLoader.openLoadingDialog(
        'Adding Barber...', 'assets/images/animation.json');

    if (addBarberFormKey.currentState?.validate() ?? false) {
      // Check if an image is selected
      if (imageFile.value == null) {
        // Show a warning if no image is selected
        ToastNotif(message: 'Please upload an image', title: 'Error')
            .showErrorNotif(Get.context!);
        return;
      }

      // Create a BarberModel with an empty profileImage initially
      final newBarber = BarberModel(
        fullName: nameController.text.trim(),
        profileImage: '', // Placeholder, will be updated later
        workingHours: [], // Initialize with empty list
        createdAt: DateTime.now(),
      );

      try {
        // Step 1: Add barber to Firestore to get the document ID
        final barberId = await _barberRepository.addBarber(newBarber);

        // Step 2: Upload the image using the document ID as the folder name
        final imageUrl = await _barberRepository.uploadImageToFirebase(
          XFile(imageFile.value!.path),
          barberId,
        );

        // Step 3: Update the barber document with the image URL
        await _barberRepository.updateBarberImage(barberId, imageUrl);

        // Optionally, provide feedback or navigate here
        ToastNotif(message: 'Barber added successfuly', title: 'Barber Added')
            .showSuccessNotif(Get.context!);
        resetForm();
        Get.back();
      } catch (e) {
        // Handle any errors
        ToastNotif(message: 'Error adding barbers', title: 'Error')
            .showErrorNotif(Get.context!);
      } finally {
        FullScreenLoader.stopLoading();
      }
    }
  }

  //==================================================================== fetching barbers
  // Listen to the stream for new barbers
  void listenToBarbersStream() {
    isLoading(true); // Set loading to true while fetching
    _barberRepository.fetchBarbers().listen(
      (newBarbers) {
        // Update the list of barbers
        barbers.assignAll(newBarbers);
        isLoading(false);
      },
      onError: (error) {
        // Handle error if any occurs in the stream
        ToastNotif(message: 'Error fetching barbers: $error', title: 'Error')
            .showErrorNotif(Get.context!);
      },
      onDone: () {
        isLoading(false); // Stop loading when the stream is done
      },
    );
  }

  //===================================================================== saving schedules
  void saveSchedule() {
    final existingSchedules =
        _storage.read<Map<String, List<String>>>(schedulesKey) ?? {};
    if (scheduleName.value.isNotEmpty) {
      existingSchedules[scheduleName.value] = workingHours.toList();
      _storage.write(schedulesKey, existingSchedules);
      scheduleName.value = ''; // Reset after saving
      workingHours.clear(); // Clear the current working hours
    }
  }

  List<String> getSavedSchedules() {
    final existingSchedules =
        _storage.read<Map<String, List<String>>>(schedulesKey) ?? {};
    return existingSchedules.keys.toList()..insert(0, 'None');
  }

  List<String> getSchedule(String name) {
    final existingSchedules =
        _storage.read<Map<String, List<String>>>(schedulesKey) ?? {};
    return existingSchedules[name] ?? [];
  }

  //===================================================================== Controller function to update barber details including image
  Future<void> updateBarber({
    required String docId,
    required BarberModel updatedBarber,
  }) async {
    FullScreenLoader.openLoadingDialog(
        'Updating Barber...', 'assets/images/animation.json');

    if (addBarberFormKey.currentState?.validate() ?? false) {
      // Check if an image is selected
      if (imageFile.value == null) {
        // Show a warning if no image is selected
        ToastNotif(message: 'Please upload an image', title: 'Error')
            .showErrorNotif(Get.context!);
        return;
      }
      try {
        XFile? newImageFile;

        // Convert Rx<File?> to XFile if a new image is selected
        if (imageFile.value != null) {
          newImageFile = XFile(imageFile.value!.path);
        }

        // Call the repository update function
        await _barberRepository.updateBarber(
          name: nameController.text,
          docId: docId,
          updatedBarber: updatedBarber,
          newImageFile: newImageFile, // Now it is of type XFile?
        );
        ToastNotif(
                message: 'Barber updated successfuly', title: 'Barber Updated')
            .showSuccessNotif(Get.context!);
        resetForm();
        Get.back();
      } catch (e) {
        ToastNotif(message: 'Error updating barber', title: 'Error')
            .showErrorNotif(Get.context!);
      } finally {
        FullScreenLoader.stopLoading();
      }
    }
  }

//=====================================================================deleting barber
  Future<void> deleteBarber(String docId) async {
    FullScreenLoader.openLoadingDialog(
        'Updating Barber...', 'assets/images/animation.json');
    try {
      // Call the repository method to delete the barber
      await _barberRepository.deleteBarber(docId: docId);
      ToastNotif(message: 'Barber deleted successfuly', title: 'Barber Updated')
          .showSuccessNotif(Get.context!);
      resetForm();
    } catch (e) {
      ToastNotif(message: 'Error deleting barber', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }
}
