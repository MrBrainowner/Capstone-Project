import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../../notifications/notifications.dart';

class BarbershopAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget? title;
  final bool? centertitle;
  const BarbershopAppBar({
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
      leading: BarbershopAppBarIcon(scaffoldKey: scaffoldKey), // Drawer Icon
      actions: [
        GestureDetector(
          onTap: () => Get.to(() =>
              const BarbershopNotifications()), // Navigate to notifications
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

class BarbershopAppBarIcon extends StatelessWidget {
  const BarbershopAppBarIcon({
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
