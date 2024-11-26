import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/controllers/haircuts_controller/haircuts_controller.dart';
import 'package:barbermate/features/barbershop/controllers/review_controller/review_controller.dart';
import 'package:barbermate/features/barbershop/views/reviews/reviews.dart';
import 'package:barbermate/features/barbershop/views/widgets/management/haircut_card.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopProfile extends StatelessWidget {
  const BarbershopProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopController());
    final haircut = Get.put(HaircutController());
    final reviewsController = Get.put(ReviewController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barbershop'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
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
                      Text(
                        controller.barbershop.value.phoneNo,
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                      const SizedBox(height: 8.0),
                      GestureDetector(
                        onTap: () => Get.to(() => const ReviewsPage()),
                        child: Row(
                          children: [
                            Card(
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(
                                  children: [
                                    const iconoir.StarSolid(
                                      height: 15,
                                    ),
                                    const SizedBox(width: 3),
                                    Text(
                                      '${reviewsController.averageRating}',
                                    ),
                                    const SizedBox(width: 5),
                                    Text(
                                      'Reviews',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyMedium,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 10.0),
                    ],
                  ),
                ),
                const SizedBox(height: 10.0),
                Text(
                  'Haircuts',
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20.0),
                //kani ang body sa mga tab
                SizedBox(
                  height: 400,
                  child: Obx(() {
                    if (haircut.isLoading.value) {
                      return const Center(child: CircularProgressIndicator());
                    } else if (haircut.haircuts.isEmpty) {
                      return const Center(child: Text('No barber available.'));
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
                          return HaircutCard2(haircut: barbershopHaircut);
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
    );
  }
}
