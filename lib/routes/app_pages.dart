import 'package:barbermate/bindings/barbershop_bindings.dart';
import 'package:barbermate/bindings/customer_bindings.dart';
import 'package:barbermate/features/admin/views/admin_view.dart';
import 'package:barbermate/features/barbershop/views/dashboard/dashboard.dart';
import 'package:barbermate/features/customer/views/appointments/appointments.dart';
import 'package:barbermate/features/customer/views/booking/choose_haircut.dart';
import 'package:barbermate/features/customer/views/dashboard/dashboard.dart';
import 'package:barbermate/features/customer/views/notifications/notifications.dart';
import 'package:get/get.dart';

class RoleBasedPage {
  static List<GetPage> getPages() {
    return [
      GetPage(
          name: '/customer',
          page: () => const CustomerDashboard(),
          binding: CustomerBinding(),
          children: [
            GetPage(
              name: '/customer/chooseHaircut',
              page: () => const ChooseHaircut(),
            ),
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
        name: '/barbershop',
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
