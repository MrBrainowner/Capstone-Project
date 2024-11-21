import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';

class ChooseSchedule extends StatelessWidget {
  const ChooseSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetHaircutsAndBarbershopsController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Choose Schedule',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else if (controller.timeSlots.isEmpty) {
          return const Center(child: Text('No Timeslots available.'));
        } else {
          return Padding(
            padding: const EdgeInsets.all(20.0),
            child: GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                mainAxisSpacing: 8.0,
                crossAxisSpacing: 8.0,
                childAspectRatio: 3,
              ),
              itemCount: controller.timeSlots.length,
              itemBuilder: (context, index) {
                final timeSlot = controller.timeSlots[index];
                return GestureDetector(
                  onTap: () {},
                  child: Container(
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(width: 1),
                    ),
                    child: Center(
                      child: Text(
                        timeSlot.schedule,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ),
                );
              },
            ),
          );
        }
      }),
    );
  }
}
