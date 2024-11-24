import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class BookingRepo extends GetxController {
  static BookingRepo get instance => Get.find();

  //variables
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // create booking
  Future<void> addBooking(BookingModel booking) async {
    try {
      // First, create the booking document without the 'id' field
      final docRef = await _db
          .collection('Barbershops')
          .doc(booking.barberShopId)
          .collection('Bookings')
          .add(booking
              .toJson()); // Firestore will generate the ID for this document

      // After the document is created, update the BookingModel with the generated document ID
      booking.id = docRef.id;

      // Optionally, you can update the document with the generated ID (this step is optional since we used add() above)
      await docRef.update({'id': booking.id});
    } catch (e) {
      throw Exception("Failed to create booking: $e");
    }
  }

  // cancel booking
  Future<void> cancelBooking() async {
    try {} catch (e) {}
  }
}
