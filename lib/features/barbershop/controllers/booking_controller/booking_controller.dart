import 'dart:async';

import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/repository/booking_repo/booking_repo.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BarbershopBookingController extends GetxController {
  static BarbershopBookingController get instace => Get.find();

  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');
  final BookingRepo _repo = Get.find();
  final BarbershopNotificationController notificationController = Get.find();

  RxList<BookingModel> bookings = <BookingModel>[].obs;

  // Create a reactive RxList for pending bookings
  RxList<BookingModel> pendingBookings = <BookingModel>[].obs;
  RxList<BookingModel> confirmedBookings = <BookingModel>[].obs;
  RxList<BookingModel> doneBookings = <BookingModel>[].obs;

  var isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    listenToBookingsStream(); // Start listening when the controller is initialized
  }

  // accept booking
  Future<void> acceptBooking(BookingModel booking) async {
    try {
      await _repo.acceptBooking(booking.id, booking.customerId);
      await notificationController.sendNotifWhenBookingUpdated(
          booking,
          'appointment_status',
          'Booking Confirmed',
          'Your appointment with ${booking.barbershopName} is confirmed',
          'notRead');
      ToastNotif(message: 'Booking confirmed successful', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: 'Error accepting booking $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // reject booking
  Future<void> rejectBooking(BookingModel booking) async {
    try {
      await _repo.rejectBooking(booking.id, booking.customerId);
      await notificationController.sendNotifWhenBookingUpdated(
          booking,
          'appointment_status',
          'Booking Declined',
          'Your appointment with ${booking.barbershopName} is declined',
          'notRead');
      ToastNotif(message: 'Booking declined successful', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: 'Error rejecting booking $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> markAsDone(BookingModel booking) async {
    try {
      await _repo.markAsDone(booking);

      await notificationController.sendNotifWhenBookingUpdated(
          booking,
          'appointment_status',
          'Appointment Complete',
          'Your appointment with ${booking.barbershopName} is completed',
          'notRead');
      ToastNotif(message: 'Appointment marked as complete', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: 'Error marking as done $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> cancelBookingForBarbershop(
      BookingModel booking, String customerId) async {
    try {
      await _repo.cancelBookingForBarbershop(booking.id, customerId);

      await notificationController.sendNotifWhenBookingUpdated(
          booking,
          'appointment_status',
          'Appointment Canceled',
          'Your appointment with ${booking.barbershopName} is canceled',
          'notRead');

      ToastNotif(message: 'Booking canceled', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: 'Error canceling appoiment $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // Listen to the stream for new bookings
  void listenToBookingsStream() {
    // Fetch bookings as a stream
    _repo.fetchBookingsBarbershop().listen(
      (newBookings) {
        // If there is new data, update the bookings and show toast
        bookings.assignAll(newBookings);
        filterPendingBookings();
        filterConfirmedBookings();
        filterDoneBookings();
      },
      onError: (error) {
        // Handle error if any occurs in the stream
        ToastNotif(message: 'Error fetching bookings: $error', title: 'Error')
            .showErrorNotif(Get.context!);
      },
      onDone: () {
        isLoading.value = false; // Stop loading when stream is done
      },
    );
  }

  // Listen to changes in bookings and filter them for 'pending' status
  void filterPendingBookings() {
    pendingBookings.value =
        bookings.where((booking) => booking.status == 'pending').toList();
  }

  void filterConfirmedBookings() {
    confirmedBookings.value =
        bookings.where((booking) => booking.status == 'confirmed').toList();
  }

  void filterDoneBookings() {
    doneBookings.value = bookings
        .where((booking) =>
            booking.status == 'done' ||
            booking.status == 'declined' ||
            booking.status == 'canceled')
        .toList();
  }
}
