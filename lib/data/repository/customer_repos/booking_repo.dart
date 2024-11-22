import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/models/timeslot_model/timeslot_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookingRepo extends GetxController {
  static BookingRepo get instance => Get.find();

  //variables
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create booking
  Future<void> addBooking(BookingModel booking, TimeSlotModel timeSlot,
      String? haircutId, DateTime date, String barbershopId) async {
    try {
      final docRef = _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Bookings')
          .doc();

      final bookingId = booking.copyWith(id: docRef.id);
      await docRef.set(bookingId.toJson());
    } catch (e) {
      throw Exception("Failed to create time slot: $e");
    }
  }

  // cancel booking
  Future<void> cancelBooking() async {
    try {} catch (e) {}
  }
}
