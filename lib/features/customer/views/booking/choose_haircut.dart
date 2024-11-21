import 'package:barbermate/features/customer/views/booking/choose_schedule.dart';
import 'package:barbermate/features/customer/views/widgets/booking_page/haircuts_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';

class ChooseHaircut extends StatelessWidget {
  const ChooseHaircut({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetHaircutsAndBarbershopsController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Choose a Haircut',
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.barbershopHaircuts.isEmpty) {
            return const Center(child: Text('No Haircut available.'));
          } else {
            final haircuts = controller.barbershopHaircuts;
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
                        onPressed: () => Get.to(() => const ChooseSchedule()),
                        child: const Text('Skip'))),
                const SizedBox(width: 10),
                Expanded(
                    child: ElevatedButton(
                        onPressed: () async {
                          Get.to(() => const ChooseSchedule());
                        },
                        child: const Text('Next')))
              ],
            ))
          ],
        ),
      ),
    );
  }
}
