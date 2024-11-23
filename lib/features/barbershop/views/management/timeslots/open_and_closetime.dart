import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/timeslot_controller/timeslot_controller.dart';

class OpenAndCloseHours extends StatelessWidget {
  const OpenAndCloseHours({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimeSlotController());

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          children: [
            const Text("Add Open Hours"),
            const SizedBox(height: 10),
            Obx(() {
              return Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: controller.selectedOpenStartTime.value,
                        );
                        if (selectedTime != null) {
                          controller.setOpenTime(selectedTime);
                        }
                      },
                      child: Text(
                          'Open: ${controller.selectedOpenStartTime.value.format(context)}'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        TimeOfDay? selectedTime = await showTimePicker(
                          context: context,
                          initialTime: controller.selectedCloseEndTime.value,
                        );
                        if (selectedTime != null) {
                          controller.setCloseTime(selectedTime);
                        }
                      },
                      child: Text(
                          'Close: ${controller.selectedCloseEndTime.value.format(context)}'),
                    ),
                  ),
                ],
              );
            }),
            const SizedBox(height: 10),
            Obx(
              () => Text(controller.openHours.isEmpty
                  ? 'Please set a Open Hours'
                  : 'Open Hours ${controller.openHours}'),
            ),
            const SizedBox(height: 10),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Format the open and close hours into a single string
                  String openToClose =
                      '${controller.selectedOpenStartTime.value.format(context)} to ${controller.selectedCloseEndTime.value.format(context)}';

                  // Send the formatted string to the controller
                  controller.updateOpenHours(openToClose);
                },
                child: const Text('Save'),
              ),
            )
          ],
        ),
      ),
    );
  }
}
