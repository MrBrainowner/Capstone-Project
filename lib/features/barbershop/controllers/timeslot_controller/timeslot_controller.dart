import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../../data/repository/barbershop_repo/timeslot_repository.dart';

class TimeSlotController extends GetxController {
  static TimeSlotController get instance => Get.find();

  final TimeslotRepository _repository = Get.put(TimeslotRepository());

  //variables
  // Open and Close times
  var selectedOpenStartTime = TimeOfDay.now().obs;
  var selectedCloseEndTime = TimeOfDay.now().obs;

  // Days Disabler (true for enabled, false for disabled)
  var disabledDays =
      List.generate(7, (index) => false).obs; // Default: all days enabled

  var isLoading = false.obs;
  RxList<TimeSlotModel> timeSlots = <TimeSlotModel>[].obs;
  var selectedStartTime = TimeOfDay.now().obs;
  var selectedEndTime = TimeOfDay.now().obs;

  // Helper method to get the day name
  String getDayName(int index) {
    switch (index) {
      case 0:
        return 'Monday';
      case 1:
        return 'Tuesday';
      case 2:
        return 'Wednesday';
      case 3:
        return 'Thursday';
      case 4:
        return 'Friday';
      case 5:
        return 'Saturday';
      case 6:
        return 'Sunday';
      default:
        return '';
    }
  }

  @override
  void onInit() async {
    super.onInit();
    await fetchTimeSlots();
  }

  // Method to toggle a specific day (disable or enable)
  void toggleDay(int dayIndex) {
    disabledDays[dayIndex] = !disabledDays[dayIndex];
  }

  // Methods to set Open and Close times
  void setOpenTime(TimeOfDay time) {
    selectedStartTime.value = time;
  }

  void setCloseTime(TimeOfDay time) {
    selectedEndTime.value = time;
  }

  // Create a time slot
  Future<void> createTimeSlot(TimeSlotModel timeSlot) async {
    isLoading.value = true;
    try {
      await _repository.createTimeSlot(timeSlot);
      await fetchTimeSlots();
      Get.snackbar("Success", "Time slot created successfully.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Update a time slot
  Future<void> updateTimeSlot(
      String timeSlotId, Map<String, dynamic> updates) async {
    isLoading.value = true;
    try {
      final hasBookings = await _repository.hasActiveBookings(timeSlotId);
      if (hasBookings) {
        Get.snackbar("Error", "Cannot update time slot with active bookings.");
      } else {
        await _repository.updateTimeSlot(timeSlotId, updates);
        Get.snackbar("Success", "Time slot updated successfully.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a time slot
  Future<void> deleteTimeSlot(String timeSlotId) async {
    isLoading.value = true;
    try {
      final hasBookings = await _repository.hasActiveBookings(timeSlotId);
      if (hasBookings) {
        Get.snackbar("Error", "Cannot delete time slot with active bookings.");
      } else {
        await _repository.deleteTimeSlot(timeSlotId);
        Get.snackbar("Success", "Time slot deleted successfully.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTimeSlots() async {
    isLoading.value = true;
    try {
      timeSlots.value = await _repository.fetchTimeSlots();
    } catch (e) {
      ToastNotif(message: 'Error Fetching TimeSlots', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }
}
