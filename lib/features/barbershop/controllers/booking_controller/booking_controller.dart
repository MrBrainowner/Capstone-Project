import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/repository/booking_repo/booking_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:path/path.dart';

class BarbershopBookingController extends GetxController {
  static BarbershopBookingController get instace => Get.find();

  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');
  final _repo = Get.put(BookingRepo());
  RxList<BookingModel> bookings = <BookingModel>[].obs;

  // accept booking
  Future<void> acceptBooking(
      String bookingId, String customerId, String notificationId) async {
    try {
      await _repo.acceptBooking(bookingId, customerId, notificationId);
      await fetchBookings();
    } catch (e) {
      ToastNotif(message: 'Error accepting booking $e', title: 'Error')
          .showErrorNotif(context);
    }
  }

  // reject booking
  Future<void> rejectBooking(
      String bookingId, String customerId, String notificationId) async {
    try {
      await _repo.rejectBooking(bookingId, customerId, notificationId);
      await fetchBookings();
    } catch (e) {
      ToastNotif(message: 'Error rejecting booking $e', title: 'Error')
          .showErrorNotif(context);
    }
  }

  Future<void> fetchBookings() async {
    try {
      final data = await _repo.fetchBookings();
      bookings.value = data;
    } catch (e) {
      ToastNotif(message: 'Error fetching bookings $e', title: 'Error')
          .showErrorNotif(context);
    }
  }
}
