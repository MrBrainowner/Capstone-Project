import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../../models/available_days/available_days.dart';
import '../../models/timeslot_model/timeslot_model.dart';

class TimeslotRepository extends GetxController {
  static TimeslotRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final barbershopId = AuthenticationRepository.instance.authUser?.uid;

  //============================================================================ Open Hours

  Future<void> updateOpenHours(String openHours) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .update({'open_hours': openHours});
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw Exception('Failed to update open hours: $e');
    }
  }

  //============================================================================ Time slots

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
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw Exception("Failed to create time slot: $e");
    }
  }

  Future<void> updateTimeSlot(
      String timeSlotId, TimeOfDay startTime, TimeOfDay endTime) async {
    try {
      final start = TimeSlotModel.timeOfDayToString(startTime);
      final end = TimeSlotModel.timeOfDayToString(endTime);

      await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Timeslots')
          .doc(timeSlotId)
          .update({'start_time': start, 'end_time': end});
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
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
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
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

  Stream<List<TimeSlotModel>> fetchBarbershopTimeSlotsStream(
      String barbershopId) {
    try {
      return _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Timeslots')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return TimeSlotModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  //============================================================================ Available days

  // Fetch available days and disabled dates for the barbershop (method for barbershop)
  Future<AvailableDaysModel?> getAvailableDays() async {
    try {
      DocumentSnapshot snapshot = await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('AvailableDays')
          .doc('settings') // Assuming settings document
          .get();
      if (snapshot.exists) {
        return AvailableDaysModel.fromSnapshot(snapshot);
      }
      return null;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw ("Error fetching available days: $e");
    }
  }

  // (method for customers)
  Stream<AvailableDaysModel?> getAvailableDaysWhenCustomerIsCurrentUserStream(
      String shopId) {
    try {
      return _db
          .collection('Barbershops')
          .doc(shopId)
          .collection('AvailableDays')
          .doc('settings') // Assuming settings document
          .snapshots()
          .map((snapshot) {
        if (snapshot.exists) {
          return AvailableDaysModel.fromSnapshot(snapshot);
        }
        return null;
      });
    } catch (e) {
      throw ("Error fetching available days: $e");
    }
  }

  // Save available days and disabled dates to Firestore (method for barbershop)
  Future<void> saveAvailableDays(AvailableDaysModel model) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('AvailableDays')
          .doc('settings')
          .set(model.toJson(), SetOptions(merge: true));
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw ("Error saving available days: $e");
    }
  }

  // Update specific date status in Firestore (method for barbershop)
  Future<void> updateDisabledDate(List<DateTime> disabledDates) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('AvailableDays')
          .doc('settings')
          .update({
        'disabled_dates':
            disabledDates.map((date) => date.toIso8601String()).toList(),
      });
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw ("Error updating disabled dates: $e");
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
