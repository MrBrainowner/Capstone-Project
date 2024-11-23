import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../../data/repository/barbershop_repo/timeslot_repository.dart';

class TimeSlotController extends GetxController {
  static TimeSlotController get instance => Get.find();

  final TimeslotRepository _repository = Get.put(TimeslotRepository());

  //variables
  RxList<DateTime> disabledDates =
      <DateTime>[].obs; // Store disabled specific dates
  RxList<bool> disabledDaysOfWeek =
      List.filled(7, false).obs; // Store disabled recurring days
  var selectedOpenStartTime = TimeOfDay.now().obs;
  var selectedCloseEndTime = TimeOfDay.now().obs;
  var isLoading = false.obs;
  RxList<TimeSlotModel> timeSlots = <TimeSlotModel>[].obs;
  var selectedStartTime = TimeOfDay.now().obs;
  var selectedEndTime = TimeOfDay.now().obs;

  // List of days
  final daysOfWeek = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  @override
  void onInit() async {
    super.onInit();
    await fetchTimeSlots();
  }

  void setOpenTime(TimeOfDay time) {
    selectedStartTime.value = time;
  }

  void setCloseTime(TimeOfDay time) {
    selectedEndTime.value = time;
  }

  // Add a disabled specific date
  void addDisabledDate(DateTime date) {
    if (!disabledDates.contains(date)) {
      disabledDates.add(date);
    } else {
      Get.snackbar("Error", "Date already disabled.");
    }
  }

  // Remove a disabled specific date
  void removeDisabledDate(DateTime date) {
    disabledDates.remove(date);
  }

  // Toggle recurring days of the week
  void toggleDayOfWeek(int index) {
    disabledDaysOfWeek[index] = !disabledDaysOfWeek[index];
  }

  // Check if a date is disabled (specific date or recurring day)
  bool isDateDisabled(DateTime date) {
    // Check specific dates
    if (disabledDates.contains(date)) return true;

    // Check recurring days of the week
    int weekdayIndex = date.weekday - 1; // Convert to 0-based index
    if (disabledDaysOfWeek[weekdayIndex]) return true;

    return false;
  }

  // Save disabled data to Firebase (implement Firebase logic here)
  Future<void> saveDisabledData() async {
    try {
      isLoading.value = true;
      // Save both `disabledDates` and `disabledDaysOfWeek` to Firebase
    } catch (e) {
      Get.snackbar("Error", "Failed to save disabled data.");
    } finally {
      isLoading.value = false;
    }
  }

  // Save disabled days to Firebase

  // Fetch disabled days from Firebase

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
