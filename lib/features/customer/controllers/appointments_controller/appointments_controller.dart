import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../../data/models/booking_model/booking_model.dart';
// Import your BookingModel

class CustomerSessionController {
  final CollectionReference sessionsCollection =
      FirebaseFirestore.instance.collection('sessions');

  // Confirm a session for a customer (after booking is successful)
  Future<void> confirmSession(BookingModel booking) async {
    try {
      await sessionsCollection.add(booking.toJson());
    } catch (e) {
      throw ('Error confirming session: $e');
    }
  }

  // Reschedule a session
  Future<void> rescheduleSession(String sessionId, BookingModel booking) async {
    try {
      await sessionsCollection.doc(sessionId).update(booking.toJson());
    } catch (e) {
      throw ('Error rescheduling session: $e');
    }
  }

  // Cancel a session (same as deleting it from the database)
  Future<void> cancelSession(String sessionId) async {
    try {
      await sessionsCollection.doc(sessionId).delete();
    } catch (e) {
      throw ('Error canceling session: $e');
    }
  }

  // Get all sessions for a customer by their ID
  Future<List<BookingModel>> getSessionsForCustomer(String customerId) async {
    try {
      QuerySnapshot querySnapshot = await sessionsCollection
          .where('customer_id', isEqualTo: customerId)
          .get();
      return querySnapshot.docs
          .map((doc) => BookingModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      throw ('Error fetching sessions: $e');
    }
  }

  // Get all sessions on a specific date for a customer
  Future<List<BookingModel>> getSessionsForDate(String date) async {
    try {
      QuerySnapshot querySnapshot =
          await sessionsCollection.where('date', isEqualTo: date).get();
      return querySnapshot.docs
          .map((doc) => BookingModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      throw ('Error fetching sessions: $e');
    }
  }
}
