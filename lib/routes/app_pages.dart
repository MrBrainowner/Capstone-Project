// import 'package:barbermate/bindings/barbershop_bindings.dart';
// import 'package:barbermate/bindings/customer_bindings.dart';
// import 'package:barbermate/features/barbershop/views/account/edit_name.dart';
// import 'package:barbermate/features/barbershop/views/dashboard/dashboard.dart';
// import 'package:barbermate/features/customer/views/account/account.dart';
// import 'package:barbermate/features/customer/views/appointments/appointments.dart';
// import 'package:barbermate/features/customer/views/barbershop/barbershop.dart';
// import 'package:barbermate/features/customer/views/booking/choose_haircut.dart';
// import 'package:barbermate/features/customer/views/booking/choose_schedule.dart';
// import 'package:barbermate/features/customer/views/dashboard/dashboard.dart';
// import 'package:barbermate/features/customer/views/drawer/drawer.dart';
// import 'package:barbermate/features/customer/views/face_shape_detector/face_shape_detection_ai.dart';
// import 'package:get/get.dart';

// class RouteManager {
//   static final List<GetPage> pages = [
//     GetPage(
//       name: '/barbershopDashboard',
//       page: () => const BarbershopDashboard(),
//       binding: BarbershopBinding(),
//     ),
//     GetPage(
//         name: '/customerDashboard',
//         page: () => const CustomerDashboard(),
//         binding: CustomerBinding(),
//         children: [
//           GetPage(
//               name: '/customerAccount',
//               page: () => const CustomerAccount() // Correct usage with function
//               ),
//           GetPage(
//               name: '/editNameCustomer',
//               page: () =>
//                   const CustomerAppointments() // Correct usage with function
//               ),
//           GetPage(
//               name: '/chooseSchedule',
//               page: () => const ChooseSchedule() // Correct usage with function
//               ),
//           // GetPage(
//           //     name: '/chooseHaircut',
//           //     page: () => const ChooseHaircut() // Correct usage with function
//           //     ),
//           GetPage(
//               name: '/customerDrawer',
//               page: () => const CustomerDrawer() // Correct usage with function
//               ),
//           GetPage(
//               name: '/daceShapeDetectionAi',
//               page: () =>
//                   const FaceShapeDetectionAi() // Correct usage with function
//               ),
//         ]),
//   ];
// }
