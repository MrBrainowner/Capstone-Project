import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../../../controllers/timeslot_controller/timeslot_controller.dart';

class DateAvailable extends StatelessWidget {
  const DateAvailable({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(TimeSlotController());

    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Disable Recurring Days',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              Obx(() {
                return Wrap(
                  spacing: 10,
                  runSpacing: 10,
                  children:
                      List.generate(controller.daysOfWeek.length, (index) {
                    final day = controller.daysOfWeek[index];
                    final isDisabled = controller.disabledDaysOfWeek[index];

                    return GestureDetector(
                      onTap: () => controller.toggleDayOfWeek(index),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 8),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: isDisabled
                              ? Colors.red.shade300
                              : Colors.transparent,
                          border: Border.all(
                            color: isDisabled
                                ? Theme.of(context).primaryColor
                                : Theme.of(context).dividerColor,
                          ),
                        ),
                        alignment: Alignment.center,
                        child: Text(
                          day,
                          style:
                              Theme.of(context).textTheme.bodyMedium?.copyWith(
                                    color: isDisabled
                                        ? Colors.white
                                        : Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.color,
                                  ),
                        ),
                      ),
                    );
                  }),
                );
              }),
              const SizedBox(height: 40),
              Text(
                'Disable Specific Dates',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime.now(),
                      lastDate: DateTime.now().add(const Duration(days: 365)),
                    );

                    if (pickedDate != null) {
                      controller.addDisabledDate(pickedDate);
                    }
                  },
                  child: const Text("Pick a Date to Disable"),
                ),
              ),
              const SizedBox(height: 20),
              Obx(() {
                if (controller.disabledDates.isEmpty) {
                  return const Text("No disabled dates selected yet.");
                }

                return ListView.builder(
                  shrinkWrap: true,
                  itemCount: controller.disabledDates.length,
                  itemBuilder: (context, index) {
                    final date = controller.disabledDates[index];
                    return ListTile(
                      title: Text(
                        DateFormat.yMMMMd().format(date),
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      trailing: IconButton(
                        icon: const iconoir.TrashSolid(color: Colors.red),
                        onPressed: () {
                          controller.removeDisabledDate(date);
                        },
                      ),
                    );
                  },
                );
              }),
              const SizedBox(height: 20),
              SizedBox(
                width: double.infinity,
                child:
                    ElevatedButton(onPressed: () {}, child: const Text('Save')),
              )
            ],
          ),
        ),
      ),
    );
  }
}
