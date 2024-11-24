import 'package:barbermate/common/widgets/notification_template.dart';
import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopAppointments extends StatelessWidget {
  const BarbershopAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopBookingController());
    // Fetch appointments when the UI is built

    return Scaffold(
      appBar: AppBar(
        title: const Text('Appointments'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () async {
          await controller.fetchBookings();
        },
        child: Obx(() {
          if (controller.bookings.isEmpty) {
            return const Center(child: Text('No appointments found.'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(20),
            itemCount: controller.bookings.length,
            itemBuilder: (context, index) {
              final booking = controller.bookings[index];

              return NotificationCard2(
                  title: booking.date,
                  message: 'Client: ${booking.customerName}',
                  icon: const iconoir.Calendar(),
                  color: Colors.green,
                  elevation: 1,
                  backgroundColor: Colors.white,
                  date: '${booking.date} || ${booking.timeSlot}');
            },
          );
        }),
      ),
    );
  }

  // Helper to map status to colors
  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'confirmed':
        return Colors.green;
      case 'completed':
        return Colors.blue;
      case 'canceled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }
}
