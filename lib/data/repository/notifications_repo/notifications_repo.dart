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
        type: 'customer_appointment',
        title: 'New Appointment Request',
        message:
            'You have a new appointment request from ${customer.firstName} ${customer.lastName}. Please accept or reject.',
        status: 'notRead',
        createdAt: DateTime.now(),
        customerId: customer.id,
        id: '',
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
        status: 'pending',
        createdAt: DateTime.now(),
        customerId: customer.id,
        id: '',
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

  Future<List<NotificationModel>> fetchNotificationsCustomers() async {
    try {
      final querySnapshot = await _db
          .collection('Customers')
          .doc(userId)
          .collection('Notifications')
          .get();
      return querySnapshot.docs.map((doc) {
        return NotificationModel.fromSnapshot(
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

  Future<List<NotificationModel>> fetchNotificationsBarbershop() async {
    try {
      final querySnapshot = await _db
          .collection('Barbershops')
          .doc(userId)
          .collection('Notifications')
          .get();
      return querySnapshot.docs.map((doc) {
        return NotificationModel.fromSnapshot(
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
}
