import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import '../../../../data/models/booking_model/booking_model.dart';

class BarbershopAppointmentController extends GetxController {
  final CollectionReference appointmentsCollection =
      FirebaseFirestore.instance.collection('appointments');

  final Logger logger = Logger();

  // Add a new appointment
  Future<void> addAppointment(BookingModel booking) async {
    try {
      await appointmentsCollection.add(booking.toJson());
      logger.i('Appointment added successfully');
    } catch (e) {
      throw ('Error adding appointment: $e');
    }
  }

  // Update an existing appointment
  Future<void> updateAppointment(
      String appointmentId, BookingModel booking) async {
    try {
      await appointmentsCollection.doc(appointmentId).update(booking.toJson());
      logger.i('Appointment updated successfully');
    } catch (e) {
      throw ('Error updating appointment: $e');
    }
  }

  // Delete an appointment
  Future<void> deleteAppointment(String appointmentId) async {
    try {
      await appointmentsCollection.doc(appointmentId).delete();
      logger.i('Appointment deleted successfully');
    } catch (e) {
      throw ('Error deleting appointment: $e');
    }
  }

  // Get an appointment by ID
  Future<BookingModel?> getAppointmentById(String appointmentId) async {
    try {
      DocumentSnapshot documentSnapshot =
          await appointmentsCollection.doc(appointmentId).get();
      if (documentSnapshot.exists) {
        return BookingModel.fromSnapshot(
            documentSnapshot as DocumentSnapshot<Map<String, dynamic>>);
      }
      return null;
    } catch (e) {
      throw ('Error fetching appointment: $e');
    }
  }

  // Get all appointments for a specific barber
  Future<List<BookingModel>> getAppointmentsForBarber(String barberId) async {
    try {
      QuerySnapshot querySnapshot = await appointmentsCollection
          .where('barber_id', isEqualTo: barberId)
          .get();
      return querySnapshot.docs
          .map((doc) => BookingModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      throw ('Error fetching appointments: $e');
    }
  }

  // Get all appointments for a specific date
  Future<List<BookingModel>> getAppointmentsForDate(String date) async {
    try {
      QuerySnapshot querySnapshot =
          await appointmentsCollection.where('date', isEqualTo: date).get();
      return querySnapshot.docs
          .map((doc) => BookingModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>))
          .toList();
    } catch (e) {
      throw ('Error fetching appointments: $e');
    }
  }
}
