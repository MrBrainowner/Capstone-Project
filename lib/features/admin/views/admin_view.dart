import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/admin_controller.dart';
import 'widgets/barbershop_info.dart';
import 'widgets/drawer.dart';

class AdminPanel extends StatelessWidget {
  const AdminPanel({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());

    return Scaffold(
      appBar: AdminAppDrawer(
        title: Text(
          'Admin Panel',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      drawer: const AdminDrawer(),
      body: DefaultTabController(
        length: 3, // Number of tabs
        child: Column(
          children: [
            const TabBar(
              tabs: [
                Tab(text: 'Pending'),
                Tab(text: 'Approved'),
                Tab(text: 'Rejected'),
              ],
            ),
            Expanded(
              child: TabBarView(
                children: [
                  _buildBarbershopList(controller, 'pending'),
                  _buildBarbershopList(controller, 'approved'),
                  _buildBarbershopList(controller, 'rejected'),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBarbershopList(AdminController controller, String status) {
    return Obx(() {
      final barbershops = controller.barbershops
          .where((shop) => shop.status == status)
          .toList();

      if (barbershops.isEmpty) {
        return const Center(child: Text('No barbershops found.'));
      }

      return ListView.builder(
        itemCount: barbershops.length,
        itemBuilder: (context, index) {
          final barbershop = barbershops[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: barbershop.barbershopProfileImage.isNotEmpty
                  ? NetworkImage(barbershop.barbershopProfileImage)
                  : const AssetImage(
                      'assets/images/prof.jpg'), // Assuming `profileImageUrl` is a field in `BarbershopModel`
              radius: 30.0,
            ),
            title: Text(barbershop.barbershopName),
            subtitle: Text('Status: ${barbershop.status}'),
            onTap: () {
              Get.to(() => BarbershopDetailPage(
                    barbershopId: barbershop.id,
                    status: status,
                    barbershopName: barbershop.barbershopName,
                    recipientEmail: barbershop.email,
                  ));
            },
          );
        },
      );
    });
  }
}
