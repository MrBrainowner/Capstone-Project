import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../models/timeslot_model/timeslot_model.dart';

class TimeslotRepository extends GetxController {
  static TimeslotRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final barbershopId = AuthenticationRepository.instance.authUser?.uid;

  Future<void> createTimeSlot(TimeSlotModel timeSlot) async {
    try {
      // Generate a new document ID
      final docRef = _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Timeslots')
          .doc();

      // Set the `id` field in the time slot model
      final timeSlotWithId = timeSlot.copyWith(id: docRef.id);

      // Save the time slot with the ID as the document ID and field
      await docRef.set(timeSlotWithId.toJson());
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
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<List<TimeSlotModel>> fetchBarbershopTimeSlots(
      String barbershopID) async {
    try {
      final querySnapshot = await _db
          .collection('Barbershops')
          .doc(barbershopID)
          .collection('Timeslots')
          .get();
      return querySnapshot.docs.map((doc) {
        return TimeSlotModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<bool> hasActiveBookings(String timeSlotId) async {
    final bookings = await _db
        .collection('Bookings')
        .where('timeslot_id', isEqualTo: timeSlotId)
        .where('status', whereIn: ['pending', 'confirmed']).get();

    return bookings.docs.isNotEmpty;
  }

  // Fetch disabled days from Firebase
  Future<List<bool>?> getDisabledDays() async {
    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('Barbershops')
          .doc('disabledDays')
          .get();

      if (snapshot.exists && snapshot.data() != null) {
        return List<bool>.from(snapshot.data()!['days']);
      }
    } catch (e) {
      throw ('Error fetching disabled days: $e');
    }
    return null; // Default to all enabled if data not found
  }

  // Update disabled days in Firebase
  Future<void> updateDisabledDays(List<bool> disabledDays) async {
    try {
      await _db
          .collection('Barbershops')
          .doc('disabledDays')
          .set({'days': disabledDays});
    } catch (e) {
      throw ('Error updating disabled days: $e');
    }
  }
}
