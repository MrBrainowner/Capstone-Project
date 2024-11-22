import 'package:barbermate/features/barbershop/views/management/timeslots/add_create_timeslot.dart';
import 'package:barbermate/features/barbershop/views/management/timeslots/available_date.dart';
import 'package:barbermate/features/barbershop/views/management/timeslots/open_and_closetime.dart';
import 'package:flutter/material.dart';

class TimeslotsPage extends StatelessWidget {
  const TimeslotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text('Manage Time Slots'),
          bottom: const TabBar(
            tabs: [
              Tab(text: "Open/Close Hours"),
              Tab(text: "Disable Days"),
              Tab(text: "Time Slots"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            OpenAndCloseHours(),
            DateAvailable(),
            AddCreateTimeSlot(),
          ],
        ),
      ),
    );
  }
}
