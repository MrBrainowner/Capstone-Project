import 'package:barbermate/features/barbershop/controllers/barbers_controller/barbers_controller.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/haircuts_controller/haircuts_controller.dart';
import 'package:barbermate/features/barbershop/views/management/haircut/management.dart';
import 'package:barbermate/features/barbershop/views/widgets/appbar/appbar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../management/barbers/management.dart';
import '../drawer/drawer.dart';
import '../management/timeslots/timeslots.dart';

class BarbershopDashboard extends StatelessWidget {
  const BarbershopDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.put(BarbershopController());
    final haircutController = Get.put(HaircutController());
    final barberController = Get.put(BarberController());

    return Scaffold(
      key: scaffoldKey,
      appBar: BarbershopAppBar(
        centertitle: false,
        scaffoldKey: scaffoldKey,
        title: Text(
          '',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      drawer: const BarbershopDrawer(),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                        child: Row(
                      children: [
                        Flexible(
                          child: Obx(
                            () => Text(
                              'Welcome to Barbermate, ${controller.barbershop.value.barbershopName}',
                              maxLines: 3,
                              style: Theme.of(context).textTheme.displaySmall,
                            ),
                          ),
                        )
                      ],
                    )),
                  ],
                ),
                const SizedBox(height: 90),
                Text('Haircut Styles | Time Slots | Barbers',
                    style: Theme.of(context).textTheme.labelSmall),
                Row(
                  children: [
                    Flexible(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                SizedBox(
                                  width: 150,
                                  child: OutlinedButton(
                                      onPressed: () {
                                        Get.to(() =>
                                            const HaircutManagementPage());
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const iconoir.Scissor(
                                            height: 25,
                                          ),
                                          const SizedBox(width: 10),
                                          Obx(
                                            () => Text(
                                                '${haircutController.haircuts.length}'),
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                            const SizedBox(width: 5),
                            Row(
                              children: [
                                SizedBox(
                                  child: OutlinedButton(
                                      onPressed: () {
                                        Get.to(() => const TimeslotsPage());
                                      },
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          const iconoir.Timer(
                                            height: 25,
                                          ),
                                          const SizedBox(width: 10),
                                          Obx(
                                            () => Text(
                                                '${haircutController.haircuts.length}'),
                                          ),
                                        ],
                                      )),
                                )
                              ],
                            ),
                            const SizedBox(width: 5),
                            Row(
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    Get.to(() => const ManageBarbersPage());
                                  },
                                  child: Row(
                                    children: [
                                      const iconoir.Group(
                                          height: 25,
                                          color:
                                              Color.fromRGBO(238, 238, 238, 1)),
                                      const SizedBox(width: 10),
                                      Obx(() => Text(
                                          '${barberController.barbers.length}')),
                                    ],
                                  ),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('You analytics',
                    style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 4),
                Column(
                  children: [
                    Container(
                      height: 280,
                      width: double.infinity,
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5))),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
