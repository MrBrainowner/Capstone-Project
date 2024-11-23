import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/models/available_days/available_days.dart';
import '../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../../data/repository/barbershop_repo/timeslot_repository.dart';

class TimeSlotController extends GetxController {
  static TimeSlotController get instance => Get.find();

  final TimeslotRepository _repository = Get.put(TimeslotRepository());
  final BarbershopController _barbershop = Get.put(BarbershopController());

  //variables
  var isLoading = false.obs;

  //================================================== time slots

  RxList<TimeSlotModel> timeSlots = <TimeSlotModel>[].obs;
  var selectedStartTime = TimeOfDay.now().obs;
  var selectedEndTime = TimeOfDay.now().obs;

  //================================================== open hours

  var selectedOpenStartTime = TimeOfDay.now().obs;
  var selectedCloseEndTime = TimeOfDay.now().obs;
  var openHours = ''.obs;

  //================================================== available days

  RxList<DateTime> disabledDates =
      <DateTime>[].obs; // Store disabled specific dates
  RxList<bool> disabledDaysOfWeek =
      List.filled(7, false).obs; // Store disabled recurring days

  // List of days
  var daysOfWeekStatus = <String, bool>{
    'Mon': true,
    'Tue': true,
    'Wed': true,
    'Thu': true,
    'Fri': true,
    'Sat': true,
    'Sun': true,
  }.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchTimeSlots();
    await fetchOpenHours();
    await fetchAvailableDays();
  }

  //============================================================================ Open Hours

  void setOpenTime(TimeOfDay time) {
    selectedOpenStartTime.value = time;
  }

  void setCloseTime(TimeOfDay time) {
    selectedCloseEndTime.value = time;
  }

  Future<void> fetchOpenHours() async {
    try {
      await _barbershop.fetchBarbershopData();
      openHours.value = _barbershop.barbershop.value.openHours.toString();
      _setInitialTimes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update open hours: $e');
    }
  }

  // Parse the open hours string into TimeOfDay objects
  void _setInitialTimes() {
    String startTime = '';
    String endTime = '';

    if (openHours.isNotEmpty) {
      // Split the openHours string into start and end times
      List<String> times = openHours.value.split(' to ');
      if (times.length == 2) {
        startTime = times[0]; // The first part is the start time
        endTime = times[1]; // The second part is the end time
      }
    }

    // Set initial start and end times
    selectedOpenStartTime.value = _parseTime(startTime);
    selectedCloseEndTime.value = _parseTime(endTime);
  }

  // Function to parse time strings like '8:00 AM' or '5:00 PM' into TimeOfDay
  TimeOfDay _parseTime(String time) {
    final parts = time.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final period = parts[1].toLowerCase(); // AM or PM

    int hour24 = hour;
    if (period == 'pm' && hour != 12) {
      hour24 += 12; // Convert PM times to 24-hour format
    } else if (period == 'am' && hour == 12) {
      hour24 = 0; // Convert 12 AM to 0 hours
    }

    return TimeOfDay(hour: hour24, minute: minute);
  }

  Future<void> updateOpenHours(String openHours) async {
    try {
      await _repository.updateOpenHours(openHours);
      Get.snackbar('Success', 'Open hours updated successfully');
      fetchOpenHours();
      _setInitialTimes();
    } catch (e) {
      Get.snackbar('Error', 'Failed to update open hours: $e');
    }
  }

  //============================================================================ Available Days

  // Fetch available days and disabled dates from Firestore
  Future<void> fetchAvailableDays() async {
    AvailableDaysModel? model = await _repository.getAvailableDays();
    if (model != null) {
      daysOfWeekStatus.assignAll(model.daysOfWeekStatus);
      disabledDates.assignAll(model.disabledDates);
    }
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

  // Toggle the disabled/enabled status of a day
  void toggleDayOfWeek(String day) {
    if (daysOfWeekStatus.containsKey(day)) {
      daysOfWeekStatus[day] = !daysOfWeekStatus[day]!;
    }
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

  // Save available days to Firebase
  Future<void> saveAvailableDays() async {
    try {
      isLoading.value = true;
      await _repository.saveAvailableDays(AvailableDaysModel(
        daysOfWeekStatus: daysOfWeekStatus,
        disabledDates: disabledDates,
      ));
      Get.snackbar("Success", "Available days saved successfully.");
      fetchAvailableDays();
    } catch (e) {
      Get.snackbar("Error", "Failed to save disabled data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  // Update Available days

  // Fetch Availalbe days

  //============================================================================ Time Slots

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
      String timeSlotId, TimeOfDay startTime, TimeOfDay endTime) async {
    isLoading.value = true;
    try {
      final hasBookings = await _repository.hasActiveBookings(timeSlotId);
      if (hasBookings) {
        Get.snackbar("Error", "Cannot update time slot with active bookings.");
      } else {
        await _repository.updateTimeSlot(timeSlotId, startTime, endTime);
        Get.snackbar("Success", "Time slot updated successfully.");
      }
      fetchTimeSlots();
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
      fetchTimeSlots();
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch TimeSlot
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
