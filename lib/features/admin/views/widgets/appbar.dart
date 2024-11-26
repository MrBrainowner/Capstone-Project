import 'package:barbermate/features/admin/views/widgets/notification.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class AdminAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget? title;
  final bool? centertitle;
  const AdminAppBar({
    super.key,
    required this.scaffoldKey,
    required this.title,
    this.centertitle,
  });

  @override
  Widget build(BuildContext context) {
    return AppBar(
      centerTitle: centertitle,
      title: title,
      leading: AdminAppBarIcon(scaffoldKey: scaffoldKey), // Drawer Icon
      actions: [
        GestureDetector(
          onTap: () => Get.to(
              () => const AdminNotifications()), // Navigate to notifications
          child: const iconoir.Bell(
            height: 25, // Bell Icon height
          ),
        ),
        const SizedBox(width: 15), // Padding for right spacing
      ],
    );
  }

  // This is necessary to implement the PreferredSizeWidget
  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class AdminAppBarIcon extends StatelessWidget {
  const AdminAppBarIcon({
    super.key,
    required this.scaffoldKey,
  });
  final GlobalKey<ScaffoldState> scaffoldKey;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: const iconoir.Menu(
        height: 25,
      ),
      onPressed: () {
        scaffoldKey.currentState?.openDrawer(); // Open the drawer when tapped
      },
    );
  }
}
