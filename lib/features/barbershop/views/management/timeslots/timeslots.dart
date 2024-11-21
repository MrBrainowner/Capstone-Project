import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../controllers/timeslot_controller/timeslot_controller.dart';

class TimeslotsPage extends StatelessWidget {
  const TimeslotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimeSlotController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manage Time Slots'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddTimeSlotModal(context, controller),
        child: const Icon(Icons.add),
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
                  onTap: () =>
                      _showEditDeleteModal(context, controller, timeSlot),
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

  void _showAddTimeSlotModal(
      BuildContext context, TimeSlotController controller) {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double
              .infinity, // Makes the bottom sheet take the available width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Add Time Slot",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        controller.selectedStartTime.value =
                            (await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now()))!;
                      },
                      child: const Text("Select Start Time"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () async {
                        controller.selectedEndTime.value =
                            (await showTimePicker(
                                context: context,
                                initialTime: TimeOfDay.now()))!;
                      },
                      child: const Text("Select End Time"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                          child: Center(
                              child: Obx(
                        () => Text(
                            'Selected TimeSlot: ${TimeSlotModel.formatTime(controller.selectedStartTime.value)} - ${TimeSlotModel.formatTime(controller.selectedEndTime.value)}'),
                      )))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    final timeSlot = TimeSlotModel(
                        startTime: controller.selectedStartTime.value,
                        endTime: controller.selectedEndTime.value,
                        maxBooking: 2,
                        isAvailable: true,
                        createdAt: DateTime.now() // Default for new slots
                        );
                    controller.createTimeSlot(timeSlot);
                    Get.back();
                  },
                  child: const Text("Add Time Slot"),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }

  void _showEditDeleteModal(BuildContext context, TimeSlotController controller,
      TimeSlotModel timeSlot) {
    Get.bottomSheet(
      Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double
              .infinity, // Makes the bottom sheet take the available width
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                "Edit/Delete Time Slot",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
                decoration: BoxDecoration(
                    border: Border.all(width: 1),
                    borderRadius: const BorderRadius.all(Radius.circular(5))),
                child: const Padding(
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(child: Center(child: Text('Selected TimeSlot')))
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {},
                      child: const Text("Edit Start Time"),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () async {},
                      child: const Text("Edit End Time"),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              const Text(
                'Selected Time: ',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {},
                child: const Text("Save Changes"),
              ),
              ElevatedButton(
                onPressed: () {
                  controller.deleteTimeSlot(timeSlot.id.toString());
                  Get.back();
                },
                child: const Text("Delete Time Slot"),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
    );
  }
}
