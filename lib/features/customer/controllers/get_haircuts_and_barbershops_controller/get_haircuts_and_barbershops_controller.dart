import 'dart:async';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/available_days/available_days.dart';
import '../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../../data/repository/barbershop_repo/timeslot_repository.dart';

class GetHaircutsAndBarbershopsController extends GetxController {
  static GetHaircutsAndBarbershopsController get instace => Get.find();

  final BarbershopRepository _barbershopRepository = Get.find();
  final TimeslotRepository _timeslotsRepository = Get.find();
  final ReviewRepo _reviewRepository = Get.find();
  final Logger logger = Logger();

  RxList<BarbershopCombinedModel> barbershopCombinedModel =
      <BarbershopCombinedModel>[].obs;

  var isLoading = true.obs;
  var error = ''.obs;
  RxBool isOpenNow = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllBarbershopData(); // Start listening when the controller is initialized
  }

  Future<void> refreshData() async {
    fetchAllBarbershopData();
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

//======================================================================== fetch barbershop & haircuts

  void fetchAllBarbershopData() {
    isLoading(true); // Show loading spinner

    _barbershopRepository.fetchAllBarbershops().listen((barbershopList) {
      List<Stream<BarbershopCombinedModel>> barbershopDataStreams =
          barbershopList.map((barbershop) {
        // Fetch haircut, timeslot, and review streams for each barbershop
        Stream<List<HaircutModel>> haircutsStream =
            _barbershopRepository.fetchBarbershopHaircuts(barbershop.id);
        Stream<List<TimeSlotModel>> timeSlotsStream =
            _timeslotsRepository.fetchBarbershopTimeSlotsStream(barbershop.id);
        Stream<List<ReviewsModel>> reviewsStream =
            _reviewRepository.fetchReviews(barbershop.id);
        Stream<AvailableDaysModel?> availableDaysStream = _timeslotsRepository
            .getAvailableDaysWhenCustomerIsCurrentUserStream(barbershop.id);

        // Combine all streams for a single barbershop
        return rx.CombineLatestStream.combine4<
            List<HaircutModel>,
            List<TimeSlotModel>,
            List<ReviewsModel>,
            AvailableDaysModel?,
            BarbershopCombinedModel>(
          haircutsStream,
          timeSlotsStream,
          reviewsStream,
          availableDaysStream,
          (haircuts, timeSlots, reviews, availableDays) {
            logger.i('Barbershop ID: ${barbershop.id}');
            logger.i('Haircuts (${haircuts.length}): $haircuts');
            logger.i('Time Slots (${timeSlots.length}): $timeSlots');
            logger.i('Reviews (${reviews.length}): $reviews');

            logger.i(
                'Available Days: ${availableDays?.disabledDates ?? 'No data'}');

            return BarbershopCombinedModel(
              barbershop: barbershop,
              haircuts: haircuts,
              timeslot: timeSlots,
              review: reviews,
              availableDays: availableDays,
            );
          },
        );
      }).toList();

      // Combine all barbershops data streams
      rx.CombineLatestStream(
        barbershopDataStreams,
        (List<BarbershopCombinedModel> combinedList) => combinedList,
      ).listen((result) {
        barbershopCombinedModel.assignAll(result);
        isLoading(false); // Hide loading spinner
      }, onError: (error) {
        logger.e("Error fetching combined data: $error");
        isLoading(false);
      });
    }, onError: (error) {
      logger.e("Error fetching barbershops: $error");
      isLoading(false);
    });
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
