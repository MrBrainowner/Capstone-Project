import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/customer/views/dashboard/dashboard.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:syncfusion_flutter_datepicker/datepicker.dart';
import '../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import '../widgets/booking_page/timeslot_card.dart';

class ChooseSchedule extends StatelessWidget {
  const ChooseSchedule({super.key});

  @override
  Widget build(BuildContext context) {
    final GetHaircutsAndBarbershopsController controller = Get.find();
    final CustomerBookingController bookingController = Get.find();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Choose Schedule',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => bookingController.refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                                'Selected Date: ${controller.formatDate(bookingController.selectedDate.value ?? controller.getNextAvailableDate())}')))),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                          onPressed: () {
                            Get.dialog(
                              Dialog(
                                shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.circular(5), // Dialog radius
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(2),
                                  child: SizedBox(
                                    height: 400,
                                    child: Card(
                                      elevation: 0, // Add shadow effect
                                      child: SfDateRangePicker(
                                        enablePastDates: false,
                                        monthViewSettings:
                                            DateRangePickerMonthViewSettings(
                                          // weekendDays: controller
                                          //     .disabledDaysOfWeek, // Saturday and Sunday
                                          blackoutDates: controller
                                              .availableDays
                                              .value
                                              ?.disabledDates,
                                        ),
                                        // selectableDayPredicate: (date) {
                                        //   // Block the days in the disabledDaysOfWeek list
                                        //   return !controller.disabledDaysOfWeek
                                        //       .contains(date.weekday);
                                        // },
                                        showActionButtons: true,
                                        initialSelectedDate:
                                            controller.getNextAvailableDate(),
                                        onSelectionChanged:
                                            (DateRangePickerSelectionChangedArgs
                                                args) {
                                          final DateTime selectedDate =
                                              args.value;
                                          bookingController.selectedDate.value =
                                              selectedDate;
                                        },
                                        onSubmit: (val) {
                                          Get.back();
                                        },
                                        onCancel: () {
                                          Get.back();
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                          child: const Text('Select Date')),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              const Text('Select Time Slot'),
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
                      child: bookingController.selectedTimeSlot.value.id == null
                          ? ElevatedButton(
                              style: const ButtonStyle(
                                  backgroundColor:
                                      WidgetStatePropertyAll(Colors.grey)),
                              onPressed: () {},
                              child: const Text('Book Now'))
                          : ElevatedButton(
                              onPressed: () {
                                // Open bottom sheet modal to confirm selections
                                Get.bottomSheet(
                                  Container(
                                    padding: const EdgeInsets.all(20),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.vertical(
                                          top: Radius.circular(20)),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        // Haircut Information
                                        Obx(() {
                                          return RichText(
                                            text: bookingController
                                                        .selectedHaircut
                                                        .value
                                                        ?.id !=
                                                    null
                                                ? TextSpan(children: [
                                                    TextSpan(
                                                      text:
                                                          'Selected Haircut: ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    TextSpan(
                                                      text:
                                                          '${bookingController.selectedHaircut.value?.name}',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                  ])
                                                : TextSpan(children: [
                                                    TextSpan(
                                                      text:
                                                          'Selected Haircut: ',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyMedium,
                                                    ),
                                                    TextSpan(
                                                      text: 'None',
                                                      style: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge,
                                                    ),
                                                  ]),
                                          );
                                        }),
                                        const SizedBox(height: 10),
                                        // Time Slot Information
                                        Obx(() {
                                          return RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                text: 'Selected Time Slot: ',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium,
                                              ),
                                              TextSpan(
                                                text: bookingController
                                                    .selectedTimeSlot
                                                    .value
                                                    .schedule,
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyLarge,
                                              ),
                                            ]),
                                          );
                                        }),
                                        const SizedBox(height: 10),
                                        // Date Information
                                        Obx(() {
                                          return RichText(
                                            text: TextSpan(children: [
                                              TextSpan(
                                                  text: 'Selected Date: ',
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium),
                                              TextSpan(
                                                  text: controller.formatDate(
                                                      bookingController
                                                              .selectedDate
                                                              .value ??
                                                          controller
                                                              .getNextAvailableDate()),
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyLarge),
                                            ]),
                                          );
                                        }),
                                        const SizedBox(height: 20),
                                        // Cancel and Confirm Buttons
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceEvenly,
                                          children: [
                                            // Cancel Button
                                            Expanded(
                                              child: OutlinedButton(
                                                onPressed: () {
                                                  Get.back();
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                            ),
                                            const SizedBox(width: 5),
                                            // Confirm Button
                                            Expanded(
                                              child: ElevatedButton(
                                                onPressed: () async {
                                                  await bookingController
                                                      .addBooking();
                                                  Get.offAll(() =>
                                                      const CustomerDashboard());
                                                },
                                                child: const Text('Confirm'),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              },
                              child: const Text('Book Now'))),
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
