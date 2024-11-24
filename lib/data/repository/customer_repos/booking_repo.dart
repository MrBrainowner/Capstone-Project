import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/features/auth/models/customer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../../features/auth/models/barbershop_model.dart';

class BookingRepo extends GetxController {
  static BookingRepo get instance => Get.find();

  //variables
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final customerAuthId =
      Get.put(AuthenticationRepository.instance.authUser?.uid);
  final bookingNotif = Get.put(NotificationsRepo());

  // create booking
  Future<void> addBooking(BookingModel booking, BarbershopModel barbershop,
      CustomerModel customer) async {
    try {
      // Step 1: Fetch the current timeslot document
      final docSnapshot = await _db
          .collection('Barbershops')
          .doc(booking.barberShopId)
          .collection('Timeslots')
          .doc(booking.timeSlotId)
          .get();

      if (!docSnapshot.exists) {
        throw Exception("Timeslot not found.");
      }

      // Step 2: Extract timeslot data
      final data = docSnapshot.data();
      if (data == null) {
        throw Exception("Invalid timeslot data.");
      }

      final isAvailable = data['is_available'] as bool? ?? false;
      final maxBooking = data['max_booking'] as int? ?? 0;

      // Step 3: Check if the timeslot is available
      if (!isAvailable) {
        throw Exception("This timeslot is no longer available for booking.");
      }

      // Step 4: Check if max_booking is greater than 0
      if (maxBooking <= 0) {
        // Optionally update the `is_available` to false since max_booking is 0
        await _db
            .collection('Barbershops')
            .doc(booking.barberShopId)
            .collection('Timeslots')
            .doc(booking.timeSlotId)
            .update({'is_available': false});

        throw Exception("This timeslot is fully booked.");
      }

      // Step 5: Decrement max_booking and update Firestore
      await _db
          .collection('Barbershops')
          .doc(booking.barberShopId)
          .collection('Timeslots')
          .doc(booking.timeSlotId)
          .update({
        'max_booking': FieldValue.increment(-1),
      });

      // Step 6: Re-check max_booking, update availability if needed
      if (maxBooking - 1 <= 0) {
        await _db
            .collection('Barbershops')
            .doc(booking.barberShopId)
            .collection('Timeslots')
            .doc(booking.timeSlotId)
            .update({'is_available': false});
      }

      // Step 7: Add booking to the Barbershop's collection and get the document reference
      final docRefBarbershop = await _db
          .collection('Barbershops')
          .doc(booking.barberShopId)
          .collection('Bookings')
          .add(booking.toJson());

      // Step 8: Update the booking's ID with the generated document ID
      booking.id = docRefBarbershop.id;

      // Step 9: Add the same booking to the Customer's collection using the generated document ID
      await _db
          .collection('Customers')
          .doc(customerAuthId)
          .collection('Bookings')
          .doc(booking.id)
          .set(booking.toJson());

      // Step 10: Update the original booking document with the ID field
      await docRefBarbershop.update({'id': booking.id});
      // Step 11: Send notifications
      await bookingNotif.sendBookingNotifications(barbershop, customer);
    } catch (e) {
      throw Exception("Failed to create booking: $e");
    }
  }

  // cancel booking
  Future<void> cancelBooking() async {
    try {} catch (e) {}
  }
}
