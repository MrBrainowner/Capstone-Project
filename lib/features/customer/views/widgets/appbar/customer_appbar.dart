// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../../notifications/notifications.dart';

class CustomerAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final Widget? title;
  final bool? centertitle;
  const CustomerAppBar({
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

      leading: AppBarIcon(scaffoldKey: scaffoldKey), // Drawer Icon
      actions: [
        GestureDetector(
          onTap: () => Get.to(
              () => const CustomerNotifications()), // Navigate to notifications
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

class AppBarIcon extends StatelessWidget {
  const AppBarIcon({
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
