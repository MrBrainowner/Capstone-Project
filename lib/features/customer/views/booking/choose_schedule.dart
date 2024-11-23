import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import '../widgets/booking_page/timeslot_card.dart';

class ChooseSchedule extends StatelessWidget {
  const ChooseSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetHaircutsAndBarbershopsController());
    final bookingController = Get.put(CustomerBookingController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Choose Schedule',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  Container(
                      height: 50,
                      decoration: BoxDecoration(
                          border: Border.all(width: 1),
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                      child: Center(
                          child: Obx(() => Text(
                              'Selected Date: ${controller.selectedDate}')))),
                  const SizedBox(height: 10),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () async {
                          final availableDays = controller.availableDays.value;

                          if (availableDays == null) {
                            // Handle the case when available days are not yet loaded
                            return;
                          }

                          // Open the date picker
                          DateTime? selectedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime
                                .now(), // You can adjust this to allow earlier dates
                            lastDate: DateTime.now().add(const Duration(
                                days: 365)), // Restrict the range as needed
                            selectableDayPredicate: (DateTime date) {
                              // Block weekends (Saturday and Sunday)

                              // Check if the day is in the disabled dates or unavailable days
                              bool isDisabled =
                                  availableDays.disabledDates.contains(date);

                              // Only allow selecting available days (not disabled or unavailable)
                              return !isDisabled;
                            },
                          );

                          if (selectedDate != null) {
                            // Update the selected date in the controller
                            controller.selectedDate.value = selectedDate;

                            // Optionally, handle the selected date (e.g., show it in a UI element)
                            print(
                                'Selected Date: ${DateFormat('yMMMd').format(selectedDate)}');
                          }
                        },
                        child: const Text('Select a Date')),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text('Selected Time'),
            SizedBox(
              height: 400,
              child: Obx(() {
                if (controller.isLoading.value) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.timeSlots.isEmpty) {
                  return const Center(child: Text('No Timeslots available.'));
                } else {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 8.0,
                        crossAxisSpacing: 8.0,
                        childAspectRatio: 3,
                      ),
                      itemCount: controller.timeSlots.length,
                      itemBuilder: (context, index) {
                        final timeSlot = controller.timeSlots[index];
                        return TimeSlotCard(timeSlot: timeSlot);
                      },
                    ),
                  );
                }
              }),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Expanded(
                child: Row(
              children: [
                Obx(
                  () => Expanded(
                      child:
                          bookingController.selectedTimeSlot.value?.id == null
                              ? ElevatedButton(
                                  style: const ButtonStyle(
                                      backgroundColor:
                                          WidgetStatePropertyAll(Colors.grey)),
                                  onPressed: () {},
                                  child: const Text('Next'))
                              : ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => const ChooseSchedule());
                                  },
                                  child: const Text('Next'))),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
