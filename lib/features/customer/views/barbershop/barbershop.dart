import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:barbermate/features/customer/controllers/review_controller/review_controller.dart';
import 'package:barbermate/features/customer/views/booking/choose_haircut.dart';
import 'package:barbermate/features/customer/views/reviews/reviews.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import '../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import '../widgets/booking_page/haircuts_card.dart';

class BarbershopProfilePage extends StatelessWidget {
  final BarbershopModel barbershop;

  const BarbershopProfilePage({
    super.key,
    required this.barbershop,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(GetHaircutsAndBarbershopsController());
    final controllerReviews = Get.put(ReviewControllerCustomer());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          barbershop.barbershopName,
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: double.infinity,
                height: 150,
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(5)),
                  child: Image.asset('assets/images/barbershop.jpg',
                      fit: BoxFit.cover),
                ),
              ),
              const SizedBox(height: 8.0),
              Text(
                barbershop.barbershopName,
                style: Theme.of(context).textTheme.headlineMedium,
              ),
              const SizedBox(height: 8.0),
              Text(
                barbershop.address,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8.0),
              Text(
                barbershop.phoneNo,
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              const SizedBox(height: 8.0),
              GestureDetector(
                onTap: () async {
                  controllerReviews.review.value.barberShopId = barbershop.id;
                  await controllerReviews.fetchReviews();
                  Get.to(
                      () => CustomerReviewsPage(barbershopId: barbershop.id));
                },
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
                            const Text(
                              '4.5',
                            ),
                            const SizedBox(width: 5),
                            Text(
                              'Reviews',
                              style: Theme.of(context).textTheme.bodyMedium,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10.0),
              SizedBox(
                height: 400,
                child: Obx(() {
                  if (controller.isLoading.value) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (controller.barbershopHaircuts.isEmpty) {
                    return const Center(child: Text('No barber available.'));
                  } else {
                    final haircuts = controller.barbershopHaircuts;
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2, // 2 columns
                        mainAxisSpacing: 15, // Spacing between rows
                        crossAxisSpacing: 15, // Spacing between columns
                        childAspectRatio: 0.7,
                        mainAxisExtent: 215, // Aspect ratio for vertical cards
                      ),
                      itemCount: haircuts.length,
                      itemBuilder: (BuildContext context, int index) {
                        final barbershopHaircut = haircuts[index];
                        return HaircutsCard(haircut: barbershopHaircut);
                      },
                    );
                  }
                }),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SizedBox(
            child: ElevatedButton(
                onPressed: () {
                  Get.to(() => const ChooseHaircut());
                },
                child: const Text('Book Now')),
          )),
    );
  }
}
