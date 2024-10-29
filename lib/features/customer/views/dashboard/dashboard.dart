import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../controllers/customer_controller/customer_controller.dart';
import '../drawer/drawer.dart';
import '../get_directions_page/directions_page.dart';
import '../widgets/barbershop_card.dart';
import '../widgets/customer_appbar.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class CustomerDashboard extends StatelessWidget {
  const CustomerDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
    final controller = Get.put(CustomerController());
    final haircutBarber = Get.put(GetHaircutsAndBarbershopsController());

    return Scaffold(
      key: scaffoldKey,
      appBar: CustomerAppBar(
        centertitle: false,
        scaffoldKey: scaffoldKey,
        title: Text(
          '',
          style: Theme.of(context).textTheme.headlineSmall,
        ),
      ),
      drawer: const CustomerDrawer(),
      // Make sure you have a drawer defined here
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
                              'Welcome to Barbermate, ${controller.customer.value.firstName} ${controller.customer.value.lastName}',
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
                Text('Haircut Styles & Nearby Barbers',
                    style: Theme.of(context).textTheme.labelSmall),
                Row(
                  children: [
                    Flexible(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              SizedBox(
                                width: 150,
                                child: OutlinedButton(
                                    onPressed: () {},
                                    child: const Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        iconoir.Scissor(
                                          height: 25,
                                        ),
                                        SizedBox(width: 10),
                                        Text(''),
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
                                  Get.to(() => const GetDirectionsPage2());
                                },
                                child: const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    iconoir.MapsArrowDiagonal(
                                        height: 25,
                                        color:
                                            Color.fromRGBO(238, 238, 238, 1)),
                                  ],
                                ),
                              )
                            ],
                          )
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Text('Book Now', style: Theme.of(context).textTheme.labelSmall),
                const SizedBox(height: 4),
                SizedBox(
                  width: double.infinity,
                  height: 274,
                  child: Obx(() {
                    if (haircutBarber.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (haircutBarber.barbershops.isEmpty) {
                      return const Center(
                          child: Text('No Barbershop available.'));
                    } else {
                      final barbershop = haircutBarber.barbershops;

                      return ListView.builder(
                        itemCount: haircutBarber.barbershops.length,
                        scrollDirection: Axis.horizontal,
                        itemBuilder: (context, index) {
                          final shops = barbershop[index];

                          return CustomerBarbershopCard(
                            barberhop: shops,
                          );
                        },
                      );
                    }
                  }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
