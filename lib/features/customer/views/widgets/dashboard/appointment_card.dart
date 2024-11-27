import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:barbermate/utils/popups/confirm_cancel_pop_up.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class AppointmentCardCustomers extends StatelessWidget {
  final String title;
  final String message;
  final BookingModel booking;

  const AppointmentCardCustomers({
    super.key,
    required this.title,
    required this.message,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final CustomerBookingController controller = Get.find();
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
                  child: OutlinedButton(
                    onPressed: () {
                      ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Cancel Appointment',
                        description: 'Do you want to cancel this appointment?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          controller.cancelBooking(booking);
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

class AppointmentConfirmedCardCustomers extends StatelessWidget {
  final String title;
  final String message;
  final BookingModel booking;

  const AppointmentConfirmedCardCustomers({
    super.key,
    required this.title,
    required this.message,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
    final CustomerBookingController controller = Get.find();
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
                  child: OutlinedButton(
                    onPressed: () {
                      ConfirmCancelPopUp.showDialog(
                        context: context,
                        title: 'Cancel Appointment',
                        description: 'Do you want to cancel this appointment?',
                        textConfirm: 'Confirm',
                        textCancel: 'Cancel',
                        onConfirm: () async {
                          controller.cancelBooking(booking);
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

class AppointmentDoneCardCustomers extends StatelessWidget {
  final String title;
  final String message;
  final BookingModel booking;

  const AppointmentDoneCardCustomers({
    super.key,
    required this.title,
    required this.message,
    required this.booking,
  });

  @override
  Widget build(BuildContext context) {
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

Color _getStatusColor(String status) {
  switch (status.toLowerCase()) {
    case 'done':
      return Colors.green;
    case 'declined':
      return Colors.red;
    case 'pending':
      return Colors.orange;
    case 'canceled':
      return Colors.red;
    default:
      return Colors.grey.shade400;
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
