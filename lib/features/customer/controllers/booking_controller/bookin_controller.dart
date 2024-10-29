import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/booking_model/booking_model.dart';
// Import your BookingModel

class CustomerBookingController {
  final CollectionReference bookingsCollection =
      FirebaseFirestore.instance.collection('bookings');

  // Add a new booking
  Future<void> addBooking(BookingModel booking) async {
    try {
      await bookingsCollection.add(booking.toJson());
    } catch (e) {
      throw ('Error adding booking: $e');
    }
  }

  // Update an existing booking (e.g., reschedule)
  Future<void> updateBooking(String bookingId, BookingModel booking) async {
    try {
      await bookingsCollection.doc(bookingId).update(booking.toJson());
    } catch (e) {
      throw ('Error updating booking: $e');
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    try {
      await bookingsCollection.doc(bookingId).delete();
    } catch (e) {
      throw ('Error canceling booking: $e');
    }
  }

  // Get a specific booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await bookingsCollection.doc(bookingId).get();
      if (documentSnapshot.exists) {
        return BookingModel.fromSnapshot(
            documentSnapshot as DocumentSnapshot<Map<String, dynamic>>);
      }
      return null;
    } catch (e) {
      throw ('Error fetching booking: $e');
    }
  }

  // Get all bookings for a specific customer
  Future<List<BookingModel>> getBookingsForCustomer(String customerId) async {
    try {
      QuerySnapshot querySnapshot = await bookingsCollection
          .where('customer_id', isEqualTo: customerId)
          .get();
      return querySnapshot.docs
          .map((doc) => BookingModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      throw ('Error fetching bookings: $e');
    }
  }

  // Get all bookings for a specific date
  Future<List<BookingModel>> getBookingsForDate(String date) async {
    try {
      QuerySnapshot querySnapshot =
          await bookingsCollection.where('date', isEqualTo: date).get();
      return querySnapshot.docs
          .map((doc) => BookingModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      throw ('Error fetching bookings: $e');
    }
  }
}
