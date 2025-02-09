import 'package:barbermate/common/widgets/appointment_case.dart';
import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
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
              onRefresh: () async {
                controller.listenToBookingsStream();
              },
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(10),
                  itemCount: controller.pendingAndConfirmedBookings.length,
                  itemBuilder: (context, index) {
                    final booking =
                        controller.pendingAndConfirmedBookings[index];

                    return buildAppointmentWidgetCustomers(booking);
                  },
                );
              }),
            ),

            // Tab for "Confirmed" bookings
            RefreshIndicator(
              triggerMode: RefreshIndicatorTriggerMode.anywhere,
              onRefresh: () async {
                controller.listenToBookingsStream();
              },
              child: Obx(() {
                return ListView.builder(
                  padding: const EdgeInsets.all(0.0),
                  itemCount: controller.doneBookings.length,
                  itemBuilder: (context, index) {
                    final booking = controller.doneBookings[index];

                    return buildAppointmentWidgetCustomers(booking);
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
