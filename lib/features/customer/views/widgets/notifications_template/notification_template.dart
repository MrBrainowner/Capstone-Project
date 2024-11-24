import 'package:flutter/material.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

/// Booking Notification Widget
class BookingNotification extends StatelessWidget {
  final String title;
  final String message;

  const BookingNotification({
    super.key,
    required this.title,
    required this.message,
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
    );
  }
}

//=================================================================================
/// Appointment Review Prompt Notification
class AppointmentReviewNotification extends StatelessWidget {
  final String title;
  final String message;

  const AppointmentReviewNotification({
    super.key,
    required this.title,
    required this.message,
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
    );
  }
}

//=================================================================================
/// Appointment Status Notification
class AppointmentStatusNotification extends StatelessWidget {
  final String title;
  final String status;

  const AppointmentStatusNotification({
    super.key,
    required this.title,
    required this.status,
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
  final String title;
  final String status;

  const BarbershopNotification({
    super.key,
    required this.title,
    required this.status,
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
    );
  }
}

//=================================================================================
/// Customer Appointment Notification
class CustomerAppointmentNotification extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  const CustomerAppointmentNotification({
    super.key,
    required this.title,
    required this.message,
    required this.onAccept,
    required this.onReject,
  });

  @override
  Widget build(BuildContext context) {
    return NotificationCard(
      title: title,
      message: message,
      icon: const iconoir.Calendar(),
      color: Colors.blue,
      action: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Expanded(
            child: ElevatedButton(
              onPressed: onAccept,
              child: const Text('Accept'),
            ),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: OutlinedButton(
              onPressed: onReject,
              child: const Text('Reject'),
            ),
          ),
        ],
      ),
      elevation: 1,
      backgroundColor: Colors.white,
    );
  }
}

//=================================================================================
/// Base Notification Card
class NotificationCard extends StatelessWidget {
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
