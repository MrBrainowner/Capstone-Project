import 'package:barbermate/features/barbershop/controllers/barbers_controller/barbers_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/barber_card.dart';
import 'add.dart';

class ManageBarbersPage extends StatelessWidget {
  const ManageBarbersPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarberController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manage Barbers'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const AddBarberPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.barbers.isEmpty) {
            return const Center(child: Text('No barber available.'));
          } else {
            final barber = controller.barbers;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  mainAxisSpacing: 2, // Spacing between rows
                  crossAxisSpacing: 15, // Spacing between columns
                  childAspectRatio: 0.7,
                  mainAxisExtent: 185 // Aspect ratio for vertical cards
                  ),
              itemCount: controller
                  .barbers.length, // Replace with dynamic count of barbers
              itemBuilder: (context, index) {
                final barbers = barber[index];
                return BarberCard(
                  barber: barbers,
                );
              },
            );
          }
        }),
      ),
    );
  }
}
