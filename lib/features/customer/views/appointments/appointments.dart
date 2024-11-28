import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/customer/views/widgets/dashboard/appointment_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerAppointments extends StatelessWidget {
  const CustomerAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerBookingController controller = Get.find();

    return DefaultTabController(
      initialIndex: 0,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          bottom: TabBar(tabs: [
            Tab(
                child: Text('My Appointments',
                    style: Theme.of(context).textTheme.bodyLarge)),
            Tab(
                child: Text('History',
                    style: Theme.of(context).textTheme.bodyLarge)),
          ]),
        ),
        body: TabBarView(
          children: [
            // Tab for "Pending" bookings
            RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {},
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.confirmedBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.confirmedBookings[index];

                    return AppointmentConfirmedCardCustomers(
                        title: 'Appointment Confirmerd',
                        message:
                            'Your appointment with ${booking.barbershopName} is confirmed.',
                        booking: booking);
                  },
                );
              }),
            ),

            // Tab for "Confirmed" bookings
            RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {},
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.doneBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.doneBookings[index];

                    return AppointmentDoneCardCustomers(
                      title: 'Appointment Complete',
                      message: 'Name: ${booking.customerName}',
                      booking: booking,
                    );
                  },
                );
              }),
            ),
          ],
        ),
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
