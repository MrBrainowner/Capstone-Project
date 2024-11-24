import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

/// Booking Notification Widget
class BookingNotification extends StatelessWidget {
  final DateTime date;
  final String title;
  final String message;

  const BookingNotification({
    super.key,
    required this.title,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      title: title,
      message: message,
      icon: const iconoir.Calendar(),
      color: Theme.of(context).primaryColor,
      elevation: 1,
      backgroundColor: Colors.white,
      date: date,
    );
  }
}

//=================================================================================
/// Appointment Review Prompt Notification
class AppointmentReviewNotification extends StatelessWidget {
  final DateTime date;
  final String title;
  final String message;

  const AppointmentReviewNotification({
    super.key,
    required this.title,
    required this.message,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      title: title,
      message: message,
      icon: const iconoir.StarHalfDashed(),
      color: Colors.green,
      action: Row(
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: () {},
              child: const Text('Write Review'),
            ),
          ),
        ],
      ),
      elevation: 1,
      backgroundColor: Colors.white,
      date: date,
    );
  }
}

//=================================================================================
/// Appointment Status Notification
class AppointmentStatusNotification extends StatelessWidget {
  final DateTime date;
  final String title;
  final String status;

  const AppointmentStatusNotification({
    super.key,
    required this.title,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor = _getStatusColor(status);

    return NotificationCard(
      title: title,
      message: 'Your appointment status is: $status',
      icon: const iconoir.InfoCircle(),
      color: statusColor,
      elevation: 1,
      backgroundColor: Colors.white,
      date: date,
    );
  }

  Color _getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.blue;
      case 'rejected':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}

//=================================================================================
/// Barbershop Status Notification
class BarbershopNotification extends StatelessWidget {
  final DateTime date;
  final String title;
  final String status;

  const BarbershopNotification({
    super.key,
    required this.title,
    required this.status,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final statusColor =
        status.toLowerCase() == 'verified' ? Colors.green : Colors.red;

    return NotificationCard(
      title: title,
      message: 'Your shop has been $status.',
      icon: const iconoir.ShopFourTiles(),
      color: statusColor,
      elevation: 1,
      backgroundColor: Colors.white,
      date: date,
    );
  }
}

//=================================================================================
/// Customer Appointment Notification
class CustomerAppointmentNotification extends StatelessWidget {
  final DateTime date;
  final String title;
  final String message;
  final String bookingId;
  final String customerId;
  final String notificationId;
  final String notificationStatus;

  const CustomerAppointmentNotification({
    super.key,
    required this.title,
    required this.message,
    required this.date,
    required this.bookingId,
    required this.customerId,
    required this.notificationId,
    required this.notificationStatus,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopBookingController());
    final notifController = Get.put(BarbershopNotificationController());

    return NotificationCard(
      title: title,
      message: message,
      icon: const iconoir.Calendar(),
      color: notificationStatus != 'read'
          ? Theme.of(context).primaryColor
          : Colors.grey.shade600,
      action: notificationStatus != 'read'
          ? Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Accept Appointment?',
                        description:
                            'Are you sure you want to accept the appoinment?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          await controller.acceptBooking(
                              bookingId, customerId, notificationId);
                          await notifController.fetchNotifications();
                          Get.back();
                        },
                      );
                    },
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () async {
                      ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Accept Appointment?',
                        description:
                            'Are you sure you want to reject the appoinment?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          await controller.rejectBooking(
                              bookingId, customerId, notificationId);
                          await notifController.fetchNotifications();
                          Get.back();
                        },
                      );
                    },
                    child: const Text('Reject'),
                  ),
                ),
              ],
            )
          : Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: WidgetStatePropertyAll(Colors.grey)),
                    onPressed: () {},
                    child: const Text('Accept'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: OutlinedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            WidgetStatePropertyAll(Colors.grey.shade200)),
                    onPressed: () {},
                    child: const Text('Reject'),
                  ),
                ),
              ],
            ),
      elevation: notificationStatus != 'read' ? 1 : 0,
      backgroundColor:
          notificationStatus != 'read' ? Colors.white : Colors.grey.shade300,
      date: date,
    );
  }
}

//=================================================================================
/// Base Notification Card
class NotificationCard extends StatelessWidget {
  final DateTime date;
  final String title;
  final String message;
  final Widget icon;
  final Color color;
  final Widget? action;
  final double elevation;
  final Color backgroundColor;

  const NotificationCard({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.action,
    required this.elevation,
    required this.backgroundColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    final dateFormatter = Get.put(BFormatter());

    return Card(
      elevation: elevation,
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(dateFormatter.formatDateTime(date),
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 10),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            if (action != null) ...[
              const SizedBox(height: 10),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}

class NotificationCard2 extends StatelessWidget {
  final String date;
  final String title;
  final String message;
  final Widget icon;
  final Color color;
  final Widget? action;
  final double elevation;
  final Color backgroundColor;

  const NotificationCard2({
    super.key,
    required this.title,
    required this.message,
    required this.icon,
    required this.color,
    this.action,
    required this.elevation,
    required this.backgroundColor,
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: elevation,
      color: backgroundColor,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                icon,
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: color),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(date, style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 10),
            Text(message, style: Theme.of(context).textTheme.bodyMedium),
            if (action != null) ...[
              const SizedBox(height: 10),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
