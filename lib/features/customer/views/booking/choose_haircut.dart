import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:barbermate/features/customer/views/booking/choose_schedule.dart';
import 'package:barbermate/features/customer/views/widgets/booking_page/haircuts_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';

class ChooseHaircut extends StatelessWidget {
  const ChooseHaircut({
    super.key,
    required this.barbershopCombinedData,
  });

  final BarbershopCombinedModel barbershopCombinedData;

  @override
  Widget build(BuildContext context) {
    final GetHaircutsAndBarbershopsController controller = Get.find();
    final CustomerBookingController bookingController = Get.find();

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) {
        bookingController.clearBookingData();
      },
      child: Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          centerTitle: true,
          title: Text(
            'Choose a Haircut',
            style: Theme.of(context).textTheme.bodyLarge,
          ),
          actions: [
            TextButton(
                onPressed: () async {
                  bookingController.selectedHaircut.value.id = null;

                  Get.to(() => ChooseSchedule(
                        timeslots: barbershopCombinedData,
                      ));
                },
                child:
                    Text('Skip', style: Theme.of(context).textTheme.bodyLarge))
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Obx(() {
            if (controller.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (barbershopCombinedData.haircuts.isEmpty) {
              return const Center(child: Text('No Haircut available.'));
            } else {
              final haircuts = barbershopCombinedData.haircuts;
              return GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  mainAxisSpacing: 15, // Spacing between rows
                  crossAxisSpacing: 15, // Spacing between columns
                  childAspectRatio: 0.7,
                  mainAxisExtent: 215, // Aspect ratio for vertical cards
                ),
                itemCount: haircuts.length,
                itemBuilder: (BuildContext context, int index) {
                  final barbershopHaircut = haircuts[index];
                  return HaircutsCard(haircut: barbershopHaircut);
                },
              );
            }
          }),
        ),
        bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Expanded(
                  child: Row(
                children: [
                  Expanded(
                      child: OutlinedButton(
                          onPressed: () async {
                            bookingController.clearBookingData();
                            Get.back();
                          },
                          child: const Text('Cancel'))),
                  const SizedBox(width: 10),
                  Obx(
                    () => Expanded(
                        child: bookingController.selectedHaircut.value.id ==
                                null
                            ? ElevatedButton(
                                style: const ButtonStyle(
                                    backgroundColor:
                                        WidgetStatePropertyAll(Colors.grey)),
                                onPressed: () {},
                                child: const Text('Next'))
                            : ElevatedButton(
                                onPressed: () {
                                  Get.to(() => ChooseSchedule(
                                      timeslots: barbershopCombinedData));
                                },
                                child: const Text('Next'))),
                  )
                ],
              ))
            ],
          ),
        ),
      ),
    );
  }
}
