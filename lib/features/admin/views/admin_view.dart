import 'package:barbermate/features/admin/views/widgets/appbar.dart';
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
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      appBar: AdminAppBar(
        title: Text(
          '',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
        scaffoldKey: scaffoldKey,
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
      final filteredBarbershops = controller.barbershopCombinedModel
          .where((barbershop) => barbershop.barbershop.status == status)
          .toList();

      if (filteredBarbershops.isEmpty) {
        return const Center(child: Text('No barbershops found.'));
      }

      return ListView.builder(
        itemCount: filteredBarbershops.length,
        itemBuilder: (context, index) {
          final barbershop = filteredBarbershops[index];

          return ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(barbershop.barbershop
                  .barbershopProfileImage), // Assuming `profileImageUrl` is a field in `BarbershopModel`
              radius: 30.0,
            ),
            title: Text(barbershop.barbershop.barbershopName),
            subtitle: Text('Status: ${barbershop.barbershop.status}'),
            onTap: () {
              Get.to(() => BarbershopDetailPage(
                    barbershop: barbershop,
                  ));
            },
          );
        },
      );
    });
  }
}
