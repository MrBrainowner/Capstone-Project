import 'package:barbermate/features/barbershop/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/barbershop/views/widgets/appoiments/appoiments_widget.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class BarbershopAppointments extends StatelessWidget {
  const BarbershopAppointments({super.key});

  @override
  Widget build(BuildContext context) {
    final BarbershopBookingController controller = Get.find();
    // Fetch appointments when the UI is built

    return DefaultTabController(
      initialIndex: 1,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Appointments'),
          centerTitle: true,
          automaticallyImplyLeading: true,
          bottom: TabBar(tabs: [
            Tab(
                child:
                    Text('New', style: Theme.of(context).textTheme.bodyLarge)),
            Tab(
                child: Text('Cofirmed',
                    style: Theme.of(context).textTheme.bodyLarge)),
            Tab(
                child:
                    Text('Done', style: Theme.of(context).textTheme.bodyLarge)),
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
                  itemCount: controller.pendingBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.pendingBookings[index];

                    return AppointmentCard(
                      title: 'New Appoiments',
                      message: 'Name: ${booking.customerName}',
                      booking: booking,
                    );
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
                  itemCount: controller.confirmedBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.confirmedBookings[index];

                    return AppointmentConfirmedCard(
                      title: 'Scheduled Appointment',
                      message: 'Name: ${booking.customerName}',
                      booking: booking,
                    );
                  },
                );
              }),
            ),

            // Tab for "Done" bookings
            RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {},
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(20),
                  itemCount: controller.doneBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.doneBookings[index];

                    return AppointmentDoneCard(
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
}
