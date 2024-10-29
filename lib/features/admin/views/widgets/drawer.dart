import 'package:barbermate/features/admin/controllers/admin_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../../../../data/repository/auth_repo/auth_repo.dart';
import '../../../../utils/popups/confirm_cancel_pop_up.dart';
import 'notification.dart';

class AdminAppDrawer extends StatelessWidget implements PreferredSizeWidget {
  final Widget? title;
  final bool? centertitle;
  const AdminAppDrawer({
    super.key,
    required this.title,
    this.centertitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centertitle,
      title: title,
      automaticallyImplyLeading: true, // Drawer Icon
      actions: [
        GestureDetector(
          onTap: () => Get.to(
              () => const AdminNotifications()), // Navigate to notifications
          child: const iconoir.Bell(
            height: 25, // Bell Icon height
          ),
        ),
        const SizedBox(width: 10), // Padding for right spacing
      ],
    );
  }

  // This is necessary to implement the PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

// Drawer Widget
class AdminDrawer extends StatelessWidget {
  const AdminDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AdminController());
    return Drawer(
      child: Column(
        children: [
          // Custom Drawer Header with CircleAvatar
          Obx(
            () => DrawerHeader(
              decoration: const BoxDecoration(
                color: Colors.blue,
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const Text(
                        'Admin Panel',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 20.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4.0),
                      Text(
                        controller.barbershops.first
                            .email, // Replace with dynamic user email
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // Drawer Items
          ListTile(
            leading: const Icon(Icons.logout_outlined),
            title: const Text('Log Out'),
            onTap: () => ConfirmCancelPopUp.showDialog(
                title: 'Log Out',
                description: 'Are you sure you want to log out?',
                textConfirm: 'Confirm',
                textCancel: 'Cancel',
                onConfirm: () => AuthenticationRepository.instance.logOut(),
                context: Get.context!),
          ),
        ],
      ),
    );
  }
}
