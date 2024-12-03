import 'dart:async';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:barbermate/data/models/fetch_with_subcollection/all_barbershops_information.dart';
import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../../../data/models/available_days/available_days.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../../data/repository/barbershop_repo/timeslot_repository.dart';
import '../../../auth/models/barbershop_model.dart';
// Import your HaircutModel

class GetHaircutsAndBarbershopsController extends GetxController {
  static GetHaircutsAndBarbershopsController get instace => Get.find();

  final BarbershopRepository _barbershopRepository = Get.find();
  final TimeslotRepository _timeslotsRepository = Get.find();

  RxList<TimeSlotModel> timeSlots = <TimeSlotModel>[].obs;
  Rx<AvailableDaysModel?> availableDays = Rx<AvailableDaysModel?>(null);
  RxList<BarbershopWithHaircuts> barbershopWithHaircutsList =
      <BarbershopWithHaircuts>[].obs;

  StreamSubscription? _reviewsStreamSubscription;
  StreamSubscription? _reviewsStreamSubscription2;
  StreamSubscription? _reviewsStreamSubscription3;
  StreamSubscription? _reviewsStreamSubscription4;

  var isLoading = true.obs;
  var error = ''.obs;
  RxBool isOpenNow = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllBarbershopsWithHaircuts(); // Start listening when the controller is initialized
  }

  Future<void> refreshData() async {
    fetchAllBarbershopsWithHaircuts();
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

  void fetchAllBarbershopsWithHaircuts() {
    isLoading(true); // Show loading spinner

    _barbershopRepository.fetchAllBarbershops().listen((barbershopList) {
      // Create a list of streams for each barbershop’s haircuts
      List<Stream<BarbershopWithHaircuts>> barbershopWithHaircutStreams =
          barbershopList.map((barbershop) {
        return _barbershopRepository
            .fetchBarbershopHaircuts(barbershop.id)
            .map((haircuts) {
          return BarbershopWithHaircuts(
            barbershop: barbershop,
            haircuts: haircuts,
          );
        });
      }).toList();

      // Combine all haircut streams with barbershop streams using Rx.combineLatestStream
      rx.CombineLatestStream(barbershopWithHaircutStreams,
              (List<BarbershopWithHaircuts> combinedList) => combinedList)
          .listen((result) {
        barbershopWithHaircutsList.assignAll(result);
        isLoading(false); // Hide loading spinner
      }, onError: (error) {
        print("Error fetching barbershops with haircuts: $error");
        isLoading(false);
      });
    }, onError: (error) {
      print("Error fetching barbershops: $error");
      isLoading(false);
    });
  }

//======================================================================== fetch barbershop

  // Listen to the stream for new barbershops
  // void listenToBarbershopsStream() {
  //   isLoading(true); // Set loading to true while the first fetch occurs
  //   _barbershopRepository.fetchAllBarbershops().listen(
  //     (newBarbershops) {
  //       // Update the list of barbershops
  //       barbershops.assignAll(newBarbershops);

  //       // Once the first data comes in, stop loading
  //       if (isLoading.value) {
  //         isLoading(false);
  //       }
  //     },
  //     onError: (error) {
  //       // Handle error if any occurs in the stream
  //       ToastNotif(
  //               message: 'Error fetching barbershops: $error', title: 'Error')
  //           .showErrorNotif(Get.context!);

  //       // Stop loading in case of error
  //       isLoading(false);
  //     },
  //   );
  // }

  /// Listen to the stream for haircuts in a specific barbershop
  // void listenToHaircutsStream(String barbershopId) {
  //   isLoading(true); // Set loading to true while fetching
  //   _barbershopRepository.fetchBarbershopHaircuts(barbershopId).listen(
  //     (newHaircuts) {
  //       // Update the list of haircuts
  //       barbershopHaircuts.assignAll(newHaircuts);
  //       // Once the first data comes in, stop loading
  //       if (isLoading.value) {
  //         isLoading(false);
  //       }

  //       listenToTimeslotAvailabledayStreams(barbershopId);
  //     },
  //     onError: (error) {
  //       // Handle error if any occurs in the stream
  //       ToastNotif(message: 'Error fetching haircuts: $error', title: 'Error')
  //           .showErrorNotif(Get.context!);
  //     },
  //     onDone: () {
  //       isLoading(false); // Stop loading when the stream is done
  //     },
  //   );
  // }

  // void listenToTimeslotAvailabledayStreams(String shopId) {
  //   listenToBarbershopTimeSlotsStream(shopId);
  //   listenToBarbershopAvailableDaysStream(shopId);
  // }

  //======================================================================== timeslots

  void listenToBarbershopTimeSlotsStream(String barbershopId) {
    isLoading.value = true;
    _timeslotsRepository.fetchBarbershopTimeSlotsStream(barbershopId).listen(
      (newTimeSlots) {
        // Update the timeSlots list with new data
        timeSlots.assignAll(newTimeSlots);
        // Once the first data comes in, stop loading
        if (isLoading.value) {
          isLoading(false);
        }
      },
      onError: (error) {
        // Handle error in the stream
        ToastNotif(message: 'Error fetching TimeSlots: $error', title: 'Error')
            .showErrorNotif(Get.context!);
      },
      onDone: () {
        isLoading.value = false; // Stop loading when the stream is done
      },
    );
  }

  //======================================================================== available days
  // Fetch available days for the barbershop
  void listenToBarbershopAvailableDaysStream(String barbershopId) {
    _timeslotsRepository
        .getAvailableDaysWhenCustomerIsCurrentUserStream(barbershopId)
        .listen(
      (data) {
        availableDays.value = data;
        getNextAvailableDate(); // Store the fetched data
        // Once the first data comes in, stop loading
        if (isLoading.value) {
          isLoading(false);
        }
      },
      onError: (error) {
        // Handle error in the stream
        ToastNotif(
                message: 'Error fetching available days: $error',
                title: 'Error')
            .showErrorNotif(Get.context!);
      },
    );
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

  @override
  void onClose() {
    // Cancel the stream subscription to prevent memory leaks
    _reviewsStreamSubscription?.cancel();
    _reviewsStreamSubscription2?.cancel();
    _reviewsStreamSubscription3?.cancel();
    _reviewsStreamSubscription4?.cancel();
    super.onClose();
  }
}
