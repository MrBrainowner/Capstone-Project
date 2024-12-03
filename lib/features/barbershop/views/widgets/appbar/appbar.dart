import 'package:barbermate/features/barbershop/controllers/notification_controller/notification_controller.dart';
import 'package:barbermate/features/barbershop/views/notifications/notifications.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

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
    final BarbershopNotificationController controller = Get.find();

    return AppBar(
      centerTitle: centertitle,
      title: title,
      leading: BarbershopAppBarIcon(scaffoldKey: scaffoldKey), // Drawer Icon
      actions: [
        Obx(
          () => GestureDetector(
              onTap: () => Get.to(() =>
                  const BarbershopNotifications()), // Navigate to notifications
              child: controller.hasUnreadNotifications
                  ? const Badge(
                      child: iconoir.Bell(
                        height: 25, // Bell Icon height
                      ),
                    )
                  : const iconoir.Bell(
                      height: 25, // Bell Icon height
                    )),
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
