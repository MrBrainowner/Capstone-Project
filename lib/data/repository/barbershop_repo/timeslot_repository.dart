import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import '../../models/timeslot_model/timeslot_model.dart';

class TimeslotRepository extends GetxController {
  static TimeslotRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final barbershopId = AuthenticationRepository.instance.authUser?.uid;

  Future<void> createTimeSlot(TimeSlotModel timeSlot) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Timeslots')
          .add(timeSlot.toJson());
    } catch (e) {
      throw Exception("Failed to create time slot: $e");
    }
  }

  Future<void> updateTimeSlot(
      String timeSlotId, Map<String, dynamic> updates) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Timeslots')
          .doc(timeSlotId)
          .update(updates);
    } catch (e) {
      throw Exception("Failed to update time slot: $e");
    }
  }

  Future<void> deleteTimeSlot(String timeSlotId) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Timeslots')
          .doc(timeSlotId)
          .delete();
    } catch (e) {
      throw Exception("Failed to delete time slot: $e");
    }
  }

  Future<List<TimeSlotModel>> fetchTimeSlots() async {
    try {
      final querySnapshot = await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Timeslots')
          .get();
      return querySnapshot.docs.map((doc) {
        return TimeSlotModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } catch (e) {
      throw Exception("Failed fetch Time Slots: $e");
    }
  }

  Future<bool> hasActiveBookings(String timeSlotId) async {
    final bookings = await _db
        .collection('Bookings')
        .where('timeslot_id', isEqualTo: timeSlotId)
        .where('status', whereIn: ['pending', 'confirmed']).get();

    return bookings.docs.isNotEmpty;
  }
}
