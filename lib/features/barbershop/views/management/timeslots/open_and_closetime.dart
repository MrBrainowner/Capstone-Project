import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../controllers/timeslot_controller/timeslot_controller.dart';

class OpenAndCloseHours extends StatelessWidget {
  const OpenAndCloseHours({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimeSlotController());

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 20),
      child: Center(
        child: Column(
          children: [
            const Text("Open Time"),
            Obx(() {
              return ElevatedButton(
                onPressed: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: controller.selectedStartTime.value,
                  );
                  if (selectedTime != null) {
                    controller.setOpenTime(selectedTime);
                  }
                },
                child: Text(
                    'Open: ${controller.selectedStartTime.value.format(context)}'),
              );
            }),
            const SizedBox(height: 10),
            const Text("Close Time"),
            Obx(() {
              return ElevatedButton(
                onPressed: () async {
                  TimeOfDay? selectedTime = await showTimePicker(
                    context: context,
                    initialTime: controller.selectedEndTime.value,
                  );
                  if (selectedTime != null) {
                    controller.setCloseTime(selectedTime);
                  }
                },
                child: Text(
                    'Close: ${controller.selectedEndTime.value.format(context)}'),
              );
            }),
          ],
        ),
      ),
    );
  }
}
