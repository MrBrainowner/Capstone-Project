import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:barbermate/features/auth/models/customer_model.dart';
import 'package:barbermate/utils/exceptions/firebase_exceptions.dart';
import 'package:barbermate/utils/exceptions/format_exceptions.dart';
import 'package:barbermate/utils/exceptions/platform_exceptions.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../models/notifications_model/notification_model.dart';

class NotificationsRepo extends GetxController {
  static NotificationsRepo get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final userId = Get.put(AuthenticationRepository.instance.authUser?.uid);

  // Method to send notifications to both customer and barbershop
  Future<void> sendBookingNotifications(BarbershopModel barbershop,
      CustomerModel customer, String bookingId) async {
    try {
      // Notification for Barbershop: New appointment (Accept/Reject)
      final barbershopNotification = NotificationModel(
        bookingId: bookingId,
        type: 'booking',
        title: 'New Appointment',
        message:
            'You have a new appointment request from ${customer.firstName} ${customer.lastName}. Please accept or reject.',
        status: 'notRead',
        createdAt: DateTime.now(),
        customerId: customer.id,
        id: '',
        barbershopId: barbershop.id,
      );
      final notifDoc = await _db
          .collection('Barbershops')
          .doc(barbershop.id)
          .collection('Notifications')
          .add(barbershopNotification.toJson());
      final bdocId = notifDoc.id;

      await notifDoc.update({'id': bdocId});

      // Notification for Customer: Appointment confirmed
      final customerNotification = NotificationModel(
        bookingId: bookingId,
        type: 'booking',
        title: 'You just made an appoiment',
        message:
            'Your appointment with ${barbershop.barbershopName} is pending.',
        status: 'notRead',
        createdAt: DateTime.now(),
        customerId: customer.id,
        id: '',
        barbershopId: barbershop.id,
      );
      final docRef = await _db
          .collection('Customers')
          .doc(userId.toString())
          .collection('Notifications')
          .add(customerNotification.toJson());
      final docId = docRef.id;

      await docRef.update({'id': docId});
    } catch (e) {
      throw Exception("Failed to send notifications: $e");
    }
  }

  Future<void> updateNotifAsRead(NotificationModel notif) async {
    try {
      await _db
          .collection('Barbershops')
          .doc(userId)
          .collection('Notifications')
          .doc(notif.id)
          .update({'status': 'read'});
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

  Future<void> updateNotifAsReadCustomer(NotificationModel notif) async {
    try {
      await _db
          .collection('Customers')
          .doc(userId)
          .collection('Notifications')
          .doc(notif.id)
          .update({'status': 'read'});
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

  Future<void> updateNotifAsReadCustomers(NotificationModel notif) async {
    try {
      await _db
          .collection('Customers')
          .doc(userId)
          .collection('Notifications')
          .doc(notif.id)
          .update({'status': 'read'});
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

  Future<void> sendNotifWhenBookingUpdated(
    BookingModel booking,
    String type,
    String title,
    String message,
    String status,
  ) async {
    try {
      final customerNotification = NotificationModel(
        bookingId: booking.id,
        type: type,
        title: title,
        message: message,
        status: status,
        createdAt: DateTime.now(),
        customerId: booking.customerId,
        id: '',
        barbershopId: booking.barberShopId,
      );

      final docRef = await _db
          .collection('Customers')
          .doc(booking.customerId)
          .collection('Notifications')
          .add(customerNotification.toJson());
      final docId = docRef.id;

      await docRef.update({'id': docId});
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

  Future<void> sendNotifWhenBookingUpdatedCustomers(
    BookingModel booking,
    String type,
    String title,
    String message,
    String status,
  ) async {
    try {
      final barbershopNotification = NotificationModel(
        bookingId: booking.id,
        type: type,
        title: title,
        message: message,
        status: status,
        createdAt: DateTime.now(),
        customerId: booking.customerId,
        id: '',
        barbershopId: booking.barberShopId,
      );

      final docRef = await _db
          .collection('Barbershops')
          .doc(booking.barberShopId)
          .collection('Notifications')
          .add(barbershopNotification.toJson());
      final docId = docRef.id;

      await docRef.update({'id': docId});
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

  // Future<List<NotificationModel>> fetchNotificationsCustomers() async {
  //   try {
  //     final querySnapshot = await _db
  //         .collection('Customers')
  //         .doc(userId)
  //         .collection('Notifications')
  //         .get();
  //     return querySnapshot.docs.map((doc) {
  //       return NotificationModel.fromSnapshot(
  //           doc as DocumentSnapshot<Map<String, dynamic>>);
  //     }).toList();
  //   } on FirebaseException catch (e) {
  //     throw BFirebaseException(e.code).message;
  //   } on FormatException catch (_) {
  //     throw BFormatException('').message;
  //   } on PlatformException catch (e) {
  //     throw BPlatformException(e.code).message;
  //   } catch (e) {
  //     throw 'Something went wrong. Please try again';
  //   }
  // }
  Stream<List<NotificationModel>> fetchNotificationsCustomers() {
    try {
      return _db
          .collection('Customers')
          .doc(userId)
          .collection('Notifications')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return NotificationModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
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

  Stream<List<NotificationModel>> fetchNotificationsBarbershop() {
    try {
      return _db
          .collection('Barbershops')
          .doc(userId)
          .collection('Notifications')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return NotificationModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
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
