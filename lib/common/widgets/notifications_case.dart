import 'package:flutter/material.dart';

import '../../data/models/notifications_model/notification_model.dart';
import 'notification_template.dart';

Widget buildNotificationWidget(NotificationModel notification) {
  switch (notification.type) {
    case 'booking':
      return BookingNotification(
          title: notification.title,
          message: notification.message,
          date: (notification.createdAt));
    case 'appointment_status':
      return AppointmentStatusNotification(
        title: notification.title,
        status: notification.status,
        date: notification.createdAt,
      );
    case 'review_prompt':
      return AppointmentReviewNotification(
        title: notification.title,
        message: notification.message,
        date: notification.createdAt,
      );
    case 'shop_status':
      return BarbershopNotification(
        title: notification.title,
        status: notification.status,
        date: notification.createdAt,
      );
    case 'customer_appointment':
      return CustomerAppointmentNotification(
        title: notification.title,
        message: notification.message,
        date: notification.createdAt,
        bookingId: notification.bookingId,
        customerId: notification.customerId,
        notificationId: notification.id,
        notificationStatus: notification.status,
      );
    default:
      return NotificationCard(
        title: 'Unknown Notification',
        message: 'This notification type is not supported.',
        icon: const Icon(Icons.info),
        color: Colors.grey,
        elevation: 0,
        backgroundColor: Colors.grey.shade50,
        date: notification.createdAt,
      );
  }
}
