import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/haircuts_controller/haircuts_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

import '../../../customer/views/widgets/booking_page/haircuts_card.dart';

class BarbershopProfile extends StatelessWidget {
  const BarbershopProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopController());
    final haircut = Get.put(HaircutController());

    return DefaultTabController(
      initialIndex: 1,
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Barbershop Profile'),
          centerTitle: true,
          automaticallyImplyLeading: true,
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: double.infinity,
                        height: 150,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: Image.asset('assets/images/barbershop.jpg',
                              fit: BoxFit.cover),
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        controller.barbershop.value.barbershopName,
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        controller.barbershop.value.address,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8.0),
                      const Row(
                        children: [
                          iconoir.StarSolid(
                            height: 15,
                          ),
                          SizedBox(width: 3),
                          Text(
                            '4.5',
                          )
                        ],
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
                // kani ang tab name
                SizedBox(
                  height: 30,
                  child: TabBar(tabs: [
                    Tab(
                      child: Text(
                        'Haircuts',
                        style: Theme.of(context).textTheme.bodyLarge,
                      ),
                    ),
                    Tab(
                      child: Text('Reviews',
                          style: Theme.of(context).textTheme.bodyLarge),
                    )
                  ]),
                ),
                //kani ang body sa mga tab
                SizedBox(
                  height: 500,
                  child: TabBarView(children: [
                    Tab(
                      child: SizedBox(
                        child: Obx(() {
                          if (haircut.isLoading.value) {
                            return const Center(
                                child: CircularProgressIndicator());
                          } else if (haircut.haircuts.isEmpty) {
                            return const Center(
                                child: Text('No barber available.'));
                          } else {
                            final haircutss = haircut.haircuts;
                            return GridView.builder(
                              gridDelegate:
                                  const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2, // 2 columns
                                mainAxisSpacing: 15, // Spacing between rows
                                crossAxisSpacing: 15, // Spacing between columns
                                childAspectRatio: 0.7,
                                mainAxisExtent:
                                    215, // Aspect ratio for vertical cards
                              ),
                              itemCount: haircutss.length,
                              itemBuilder: (BuildContext context, int index) {
                                final barbershopHaircut = haircutss[index];
                                return HaircutsCard(haircut: barbershopHaircut);
                              },
                            );
                          }
                        }),
                      ),
                    ),
                    const Tab(
                      child: Text('Reviews Page'),
                    )
                  ]),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
