import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/timeslot_controller/timeslot_controller.dart';

class DateAvailable extends StatelessWidget {
  const DateAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimeSlotController());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            const Text('Disable Specific Days (e.g., Weekends)'),
            Obx(() {
              return Column(
                children: List.generate(7, (index) {
                  return CheckboxListTile(
                    title: Text(controller.getDayName(index)),
                    value: !controller.disabledDays[
                        index], // Show unchecked for disabled days
                    onChanged: (value) {
                      controller.toggleDay(index); // Toggle day disable/enable
                    },
                  );
                }),
              );
            }),
          ],
        ),
      ),
    );
  }
}
