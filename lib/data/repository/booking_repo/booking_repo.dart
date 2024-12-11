import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/notifications_repo/notifications_repo.dart';
import 'package:barbermate/data/services/push_notification/push_notification.dart';
import 'package:barbermate/features/auth/models/customer_model.dart';
import 'package:barbermate/utils/exceptions/firebase_exceptions.dart';
import 'package:barbermate/utils/exceptions/format_exceptions.dart';
import 'package:barbermate/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../features/auth/models/barbershop_model.dart';

class BookingRepo extends GetxController {
  static BookingRepo get instance => Get.find();

  //variables
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final authId = Get.put(AuthenticationRepository.instance.authUser?.uid);
  final bookingNotif = Get.put(NotificationsRepo());
  final _notificationServiceRepository = NotificationServiceRepository.instance;

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
          .doc(authId)
          .collection('Bookings')
          .doc(booking.id)
          .set(booking.toJson());

      // Step 10: Update the original booking document with the ID field
      await docRefBarbershop.update({'id': booking.id});
      // Step 11: Send notifications
      await bookingNotif.sendBookingNotifications(
          barbershop, customer, booking.id);

      await _notificationServiceRepository.sendNotificationToUser(
          userType: customer.role,
          token: barbershop.fcmToken.toString(),
          title: 'Booked',
          body:
              'You just booked an appoinment with ${barbershop.barbershopName}');
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

  // cancel booking(customer)
  Future<void> cancelBooking(BookingModel booking) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(booking.barberShopId)
          .collection('Bookings')
          .doc(booking.id)
          .update({'status': 'canceled'});

      await _db
          .collection('Customers')
          .doc(authId)
          .collection('Bookings')
          .doc(booking.id)
          .update({'status': 'canceled'});
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

  // accept booking
  Future<void> acceptBooking(String bookingId, String customerId) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(authId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'confirmed'});
      await _db
          .collection('Customers')
          .doc(customerId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'confirmed'});
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

  // reject booking
  Future<void> rejectBooking(String bookingId, String customerId) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(authId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'declined'});
      await _db
          .collection('Customers')
          .doc(customerId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'declined'});
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

  // Stream of bookings for barbershop
  Stream<List<BookingModel>> fetchBookingsBarbershop() {
    return _db
        .collection('Barbershops')
        .doc(authId)
        .collection('Bookings')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return BookingModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  // Stream of bookings for customer
  Stream<List<BookingModel>> fetchBookingsCustomer() {
    return _db
        .collection('Customers')
        .doc(authId)
        .collection('Bookings')
        .snapshots()
        .map((querySnapshot) {
      return querySnapshot.docs.map((doc) {
        return BookingModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
    });
  }

  // mark appointment as done
  Future<void> markAsDone(BookingModel booking) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(authId)
          .collection('Bookings')
          .doc(booking.id)
          .update({'status': 'done'});

      await _db
          .collection('Customers')
          .doc(booking.customerId)
          .collection('Bookings')
          .doc(booking.id)
          .update({'status': 'done'});
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

  // cancel booking(barbershops)
  Future<void> cancelBookingForBarbershop(
      String bookingId, String customerId) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(authId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'canceled'});

      await _db
          .collection('Customers')
          .doc()
          .collection('Bookings')
          .doc(bookingId)
          .update({'status': 'canceled'});
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

  Future<void> rescheduleAppointment(
      String reschedule, String barbershopId, String bookingId) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(barbershopId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'date': reschedule, 'status': 'reschedule'});
      await _db
          .collection('Customers')
          .doc(authId)
          .collection('Bookings')
          .doc(bookingId)
          .update({'date': reschedule, 'status': 'reschedule'});
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
}
