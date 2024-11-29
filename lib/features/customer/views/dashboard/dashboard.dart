import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:barbermate/features/customer/views/face_shape_detector/face_shape_detection_ai.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../controllers/customer_controller/customer_controller.dart';
import '../drawer/drawer.dart';
import '../get_directions_page/directions_page.dart';
import '../widgets/dashboard/barbershop_card.dart';
import '../widgets/appbar/customer_appbar.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final CustomerController customerController = Get.find();
    final GetHaircutsAndBarbershopsController haircutBarberController =
        Get.find();
    final DateTime now = DateTime.now();
    final String formattedDate = DateFormat('MMMM d, y').format(now);

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomerAppBar(
        centertitle: false,
        scaffoldKey: scaffoldKey,
        title: const Text(''),
      ),
      drawer: const CustomerDrawer(),
      // Make sure you have a drawer defined here
      body: RefreshIndicator(
        triggerMode: RefreshIndicatorTriggerMode.anywhere,
        onRefresh: () => haircutBarberController.refreshData(),
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                                'Welcome to Barbermate, ${customerController.customer.value.firstName}',
                                maxLines: 3,
                                style: Theme.of(context).textTheme.displaySmall,
                              ),
                            ),
                          )
                        ],
                      )),
                    ],
                  ),
                  const SizedBox(height: 70),
                  Text(formattedDate,
                      style: Theme.of(context).textTheme.labelSmall),
                  Row(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: OutlinedButton(
                                    onPressed: () => Get.to(
                                        () => const SuggestHaircutAiPage()),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const iconoir.Scissor(
                                          height: 25,
                                        ),
                                        const SizedBox(width: 5),
                                        Text(
                                          'Suggest Me',
                                          overflow: TextOverflow.clip,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyMedium,
                                        ),
                                      ],
                                    )),
                              )
                            ],
                          ),
                          const SizedBox(width: 5),
                          ElevatedButton(
                            onPressed: () {
                              Get.to(() => const GetDirectionsPage2());
                            },
                            child: const iconoir.Map(
                                height: 25,
                                color: Color.fromRGBO(238, 238, 238, 1)),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),
                  Text('Book Now',
                      style: Theme.of(context).textTheme.labelSmall),
                  const SizedBox(height: 4),
                  SizedBox(
                    width: double.infinity,
                    height: 300,
                    child: Obx(() {
                      if (haircutBarberController.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (haircutBarberController.barbershops.isEmpty) {
                        return const Center(
                            child: Text('No Barbershop available.'));
                      } else {
                        final barbershop = haircutBarberController.barbershops;

                        return ListView.builder(
                          itemCount: haircutBarberController.barbershops.length,
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (context, index) {
                            final shops = barbershop[index];
                            haircutBarberController
                                .checkIsOpenNow(shops.openHours);

                            return CustomerBarbershopCard(
                              barberhop: shops,
                            );
                          },
                        );
                      }
                    }),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
