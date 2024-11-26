import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class AppointmentCard extends StatelessWidget {
  final String title;
  final String message;
  final BookingModel booking;

  const AppointmentCard({
    super.key,
    required this.title,
    required this.message,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopBookingController());
    final formatterController = Get.put(BFormatter());

    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const iconoir.Calendar(),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.orange),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(formatterController.formatDate(booking.createdAt),
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 5),
            Divider(color: Theme.of(context).primaryColor),
            const SizedBox(height: 3),
            Text('Name: ${booking.customerName}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Phone: ${booking.customerPhoneNo}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Divider(color: Theme.of(context).primaryColor),
            const SizedBox(height: 3),
            Text('Hairstyle: ${booking.haircutName}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Price: ${booking.haircutPrice}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Time Slot: ${booking.timeSlot}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Date: ${booking.date}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Confirm Booking',
                        description: 'Do you want to confirm this request?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          controller.acceptBooking(booking);
                          Get.back();
                        },
                      );
                    },
                    child: const Text('Confirm'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Decline Booking',
                        description: 'Do you want to decline this request?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          controller.rejectBooking(booking);
                          Get.back();
                        },
                      );
                    },
                    child: const Text('Decline'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentConfirmedCard extends StatelessWidget {
  final String title;
  final String message;
  final BookingModel booking;

  const AppointmentConfirmedCard({
    super.key,
    required this.title,
    required this.message,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopBookingController());
    final formatterController = Get.put(BFormatter());

    return Card(
      elevation: 1,
      color: Colors.white,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const iconoir.Calendar(),
                const SizedBox(width: 10),
                Text(
                  title,
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: Colors.blue),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(formatterController.formatDate(booking.createdAt),
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 5),
            Divider(color: Theme.of(context).primaryColor),
            const SizedBox(height: 3),
            Text('Name: ${booking.customerName}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Phone: ${booking.customerPhoneNo}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Divider(color: Theme.of(context).primaryColor),
            const SizedBox(height: 3),
            Text('Hairstyle: ${booking.haircutName}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Price: ${booking.haircutPrice}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Time Slot: ${booking.timeSlot}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Date: ${booking.date}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Appointment Complete',
                        description:
                            'Do you want manually complete this appoiment?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          controller.markAsDone(booking);
                          Get.back();
                        },
                      );
                    },
                    child: const Text('Complete'),
                  ),
                ),
                const SizedBox(width: 5),
                Expanded(
                  child: OutlinedButton(
                    onPressed: () {
                      ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Cancel Appointment',
                        description: 'Do you want to cancel this appointment?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          controller.cancelBookingForBarbershop(
                              booking, booking.customerId);
                          Get.back();
                        },
                      );
                    },
                    child: const Text('Cancel'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class AppointmentDoneCard extends StatelessWidget {
  final String title;
  final String message;
  final BookingModel booking;

  const AppointmentDoneCard({
    super.key,
    required this.title,
    required this.message,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final formatterController = Get.put(BFormatter());

    return Card(
      elevation: 0,
      color: Colors.grey.shade300,
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const iconoir.Calendar(),
                const SizedBox(width: 10),
                Text(
                  _getTitleColor(booking.status),
                  style: Theme.of(context)
                      .textTheme
                      .titleLarge
                      ?.copyWith(color: _getStatusColor(booking.status)),
                ),
              ],
            ),
            const SizedBox(height: 5),
            Text(formatterController.formatDate(booking.createdAt),
                style: Theme.of(context).textTheme.labelSmall),
            const SizedBox(height: 5),
            Divider(color: Theme.of(context).primaryColor),
            const SizedBox(height: 3),
            Text('Name: ${booking.customerName}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Phone: ${booking.customerPhoneNo}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Divider(color: Theme.of(context).primaryColor),
            const SizedBox(height: 3),
            Text('Hairstyle: ${booking.haircutName}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Price: ${booking.haircutPrice}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Time Slot: ${booking.timeSlot}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 3),
            Text('Date: ${booking.date}',
                style: Theme.of(context).textTheme.bodyMedium),
            const SizedBox(height: 10),
            Text('Status: ${booking.status}',
                style: Theme.of(context).textTheme.bodyMedium),
          ],
        ),
      ),
    );
  }
}

// Helper to map status to colors
Color _getStatusColor(String status) {
  switch (status) {
    case 'pending':
      return Colors.orange;
    case 'confirmed':
      return Colors.blue;
    case 'done':
      return Colors.green;
    case 'canceled':
      return Colors.red;
    case 'declined':
      return Colors.red;
    default:
      return Colors.grey;
  }
}

String _getTitleColor(String title) {
  switch (title.toLowerCase()) {
    case 'done':
      return 'Appointment Complete';
    case 'declined':
      return 'Appointment Declined';
    case 'pending':
      return 'Appointment Pending';
    case 'canceled':
      return 'Appointment Canceled';
    default:
      return 'Appointment Unknown';
  }
}
