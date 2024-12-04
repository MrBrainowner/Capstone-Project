import 'package:barbermate/bindings/barbershop_bindings.dart';
import 'package:barbermate/bindings/customer_bindings.dart';
import 'package:barbermate/features/admin/views/admin_view.dart';
import 'package:barbermate/features/auth/views/account_set_up/barbershop/banner_set_up.dart';
import 'package:barbermate/features/auth/views/account_set_up/barbershop/logo_set_up.dart';
import 'package:barbermate/features/auth/views/account_set_up/barbershop/profile_set_up.dart';
import 'package:barbermate/features/auth/views/account_set_up/customer/account_set_up.dart';
import 'package:barbermate/features/barbershop/views/dashboard/dashboard.dart';
import 'package:barbermate/features/customer/views/appointments/appointments.dart';
import 'package:barbermate/features/customer/views/barbershop/barbershop.dart';
import 'package:barbermate/features/customer/views/dashboard/dashboard.dart';
import 'package:barbermate/features/customer/views/notifications/notifications.dart';
import 'package:get/get.dart';

class RoleBasedPage {
  static List<GetPage> getPages() {
    return [
      GetPage(
          name: '/barbershop/setup_profile',
          page: () => const BarbershopAccountSetUpPage(),
          binding: BarbershopBinding(),
          children: [
            GetPage(
              name: '/barbershop/setup_banner',
              page: () => const BarbershopAccountSetUpPageBanner(),
            ),
            GetPage(
              name: '/barbershop/setup_logo',
              page: () => const BarbershopAccountSetUpPageLogo(),
            ),
          ]),
      GetPage(
        name: '/customer/setup_profile',
        page: () => const CustomerAccountSetUpPage(),
        binding: CustomerBinding(),
      ),
      GetPage(
          name: '/customer/dashboard',
          page: () => const CustomerDashboard(),
          binding: CustomerBinding(),
          children: [
            GetPage(
              name: '/customer/customerNotifications',
              page: () => const CustomerNotifications(),
            ),
            GetPage(
              name: '/customer/appointments',
              page: () => const CustomerAppointments(),
            ),
          ]),
      GetPage(
        name: '/barbershop/dashboard',
        page: () => const BarbershopDashboard(),
        binding: BarbershopBinding(),
      ),
      GetPage(
        name: '/admin',
        page: () => const AdminPanel(),
      ),
    ];
  }
}
