import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:barbermate/features/customer/controllers/review_controller/review_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/available_days/available_days.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../../data/repository/barbershop_repo/haircut_repository.dart';
import '../../../../data/repository/barbershop_repo/timeslot_repository.dart';
import '../../../auth/models/barbershop_model.dart';
// Import your HaircutModel

class GetHaircutsAndBarbershopsController extends GetxController {
  static GetHaircutsAndBarbershopsController get instace => Get.find();

  final HaircutRepository _haircutRepository = HaircutRepository();
  final BarbershopRepository _barbershopRepository = BarbershopRepository();
  final TimeslotRepository _timeslotsRepository = Get.put(TimeslotRepository());

  RxList<HaircutModel> haircuts = <HaircutModel>[].obs;
  RxList<TimeSlotModel> timeSlots = <TimeSlotModel>[].obs;
  RxList<HaircutModel> barbershopHaircuts = <HaircutModel>[].obs;
  RxList<BarbershopModel> barbershops = <BarbershopModel>[].obs;
  Rx<AvailableDaysModel?> availableDays = Rx<AvailableDaysModel?>(null);
  final controller = Get.put(ReviewControllerCustomer());

  var isLoading = true.obs;
  var error = ''.obs;
  RxBool isOpenNow = false.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchAllBarbershops();
    await controller.fetchReviews();
  }

  Future<void> refreshData() async {
    await fetchAllBarbershops();
  }

//======================================================================== open hours logic

  void checkIsOpenNow(String? openHours) {
    if (openHours == null || openHours.isEmpty) {
      isOpenNow.value = false; // Default to closed if unverified
      return;
    }

    final currentTime = TimeOfDay.now();
    final parts = openHours.split(' to ');
    final openTime = _stringToTimeOfDay(parts[0].trim());
    final closeTime = _stringToTimeOfDay(parts[1].trim());

    // Update the observable value
    isOpenNow.value = _isTimeWithinRange(currentTime, openTime, closeTime);
  }

  static TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(' ');
    final timeParts = parts[0].split(':');
    final hour = int.parse(timeParts[0]);
    final minute = int.parse(timeParts[1]);
    final isPM = parts[1].toUpperCase() == 'PM';

    return TimeOfDay(
      hour: isPM ? (hour % 12) + 12 : hour % 12,
      minute: minute,
    );
  }

  static bool _isTimeWithinRange(
      TimeOfDay currentTime, TimeOfDay startTime, TimeOfDay endTime) {
    final currentMinutes = currentTime.hour * 60 + currentTime.minute;
    final startMinutes = startTime.hour * 60 + startTime.minute;
    final endMinutes = endTime.hour * 60 + endTime.minute;

    return currentMinutes >= startMinutes && currentMinutes <= endMinutes;
  }

//======================================================================== fetch haircuts
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

//======================================================================== fetch barbershop

// Fetch all barbershops and update the state
  Future<void> fetchAllBarbershops() async {
    isLoading.value = true;
    try {
      // Fetch data from the repository

      barbershops.value = await _barbershopRepository.fetchAllBarbershops();
    } catch (e) {
      // Handle and display error
      ToastNotif(message: 'Error fetching barbershops', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  // Fetch all barbershop haircuts
  Future<void> fetchAllBarbershoHaircuts(String barbershopId) async {
    isLoading.value = true;
    try {
      // fetch data from the repo

      barbershopHaircuts.value =
          await _barbershopRepository.fetchBarbershopHaircuts(barbershopId);
    } catch (e) {
      // Handle and display error
      ToastNotif(message: 'Error fetching barbershops', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  //======================================================================== timeslots

  Future<void> fetchBarbershopTimeSlots(String barbershopID) async {
    isLoading.value = true;
    try {
      timeSlots.value =
          await _timeslotsRepository.fetchBarbershopTimeSlots(barbershopID);
    } catch (e) {
      ToastNotif(message: 'Error Fetching TimeSlots', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }

  //======================================================================== available days
  // Fetch available days for the barbershop
  Future<void> fetchBarbershopAvailableDays(String barbershopId) async {
    try {
      final data =
          await _timeslotsRepository.getBarbershopAvailableDays(barbershopId);
      availableDays.value = data;
      getNextAvailableDate(); // Store the fetched data
    } catch (e) {
      throw ("Error fetching available days: $e");
    }
  }

  String formatDate(DateTime date) {
    return DateFormat('MMMM dd, yyyy').format(date);
  }

  DateTime getNextAvailableDate() {
    DateTime currentDate = DateTime.now();
    while (disabledDaysOfWeek.contains(currentDate.weekday)) {
      currentDate = currentDate.add(const Duration(days: 1));
    }
    return currentDate;
  }

  var disabledDaysOfWeek = [6, 1, 7];
}
