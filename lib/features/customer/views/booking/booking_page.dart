// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../../barbershop/views/widgets/haircut_card.dart';
import '../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';

class BookingPage extends StatelessWidget {
  const BookingPage({
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
            return const Center(child: Text('No barber available.'));
          } else {
            final haircuts = controller.barbershopHaircuts;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  mainAxisSpacing: 2, // Spacing between rows
                  crossAxisSpacing: 15, // Spacing between columns
                  childAspectRatio: 0.7,
                  mainAxisExtent: 195 // Aspect ratio for vertical cards
                  ),
              itemCount: controller.barbershopHaircuts.length,
              itemBuilder: (BuildContext context, int index) {
                final barbershopHaircut = haircuts[index];
                return HaircutCard(
                  haircut: barbershopHaircut,
                );
              },
            );
          }
        }),
      ),
    );
  }
}
