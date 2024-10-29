import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../controllers/haircuts_controller/haircuts_controller.dart';
import '../../widgets/haircut_card.dart';
import 'add.dart';

class HaircutManagementPage extends StatelessWidget {
  const HaircutManagementPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(HaircutController());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Manage Haicuts'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            onPressed: () {
              Get.to(() => const HaircutAddPage());
            },
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          } else if (controller.haircuts.isEmpty) {
            return const Center(child: Text('No barber available.'));
          } else {
            final haircut = controller.haircuts;
            return GridView.builder(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2, // 2 columns
                  mainAxisSpacing: 2, // Spacing between rows
                  crossAxisSpacing: 15, // Spacing between columns
                  childAspectRatio: 0.7,
                  mainAxisExtent: 195 // Aspect ratio for vertical cards
                  ),
              itemCount: controller
                  .haircuts.length, // Replace with dynamic count of barbers
              itemBuilder: (context, index) {
                final haircuts = haircut[index];
                return HaircutCard(
                  haircut: haircuts,
                );
              },
            );
          }
        }),
      ),
    );
  }
}
