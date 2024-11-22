import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
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
      body: Column(
        children: [
          const SizedBox(height: 20),
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
