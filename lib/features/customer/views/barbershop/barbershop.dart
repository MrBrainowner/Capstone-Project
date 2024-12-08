import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:barbermate/features/customer/views/booking/choose_haircut.dart';
import 'package:barbermate/features/customer/views/reviews/reviews.dart';
import 'package:barbermate/features/customer/views/widgets/barbershop/barbershop_infos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

import '../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import '../widgets/booking_page/haircuts_card.dart';

class BarbershopProfilePage extends StatelessWidget {
  const BarbershopProfilePage({
    super.key,
    required this.barbershop,
  });

  final BarbershopCombinedModel barbershop;

  @override
  Widget build(BuildContext context) {
    final GetHaircutsAndBarbershopsController controller = Get.find();
    const double bannerHeight = 150;
    const double profileHeight = 80;
    const top = bannerHeight - profileHeight / 2;
    const bottom = profileHeight / 2;

    return DefaultTabController(
      length: 2,
      initialIndex: 0,
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            barbershop.barbershop.barbershopName,
            style: Theme.of(context).textTheme.bodyLarge,
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  clipBehavior: Clip.none,
                  alignment: Alignment.center,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(bottom: bottom),
                      child: SizedBox(
                        width: double.infinity,
                        height: bannerHeight,
                        child: ClipRRect(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          child: barbershop
                                  .barbershop.barbershopBannerImage.isEmpty
                              ? Image.asset('assets/images/barbershop.jpg',
                                  fit: BoxFit.cover)
                              : Image.network(
                                  barbershop.barbershop.barbershopBannerImage,
                                  fit: BoxFit.cover),
                        ),
                      ),
                    ),
                    Positioned(
                      top: top,
                      child: Container(
                        decoration: BoxDecoration(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            border: Border.all(
                                width: 3,
                                color:
                                    Theme.of(context).scaffoldBackgroundColor)),
                        child: SizedBox(
                          width: 80,
                          height: profileHeight,
                          child: ClipRRect(
                            borderRadius:
                                const BorderRadius.all(Radius.circular(5)),
                            child: barbershop
                                    .barbershop.barbershopProfileImage.isEmpty
                                ? Image.asset('assets/images/prof.jpg',
                                    fit: BoxFit.cover)
                                : Image.network(
                                    barbershop
                                        .barbershop.barbershopProfileImage,
                                    fit: BoxFit.cover),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Text(barbershop.barbershop.barbershopName,
                          maxLines: 2,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                  ],
                ),
                TabBar(
                    labelStyle: Theme.of(context).textTheme.bodyMedium,
                    tabs: const [
                      Tab(
                        text: 'About',
                      ),
                      Tab(
                        text: 'Haircuts',
                      ),
                    ]),
                SizedBox(
                  height: 400,
                  child: TabBarView(children: [
                    Column(
                      children: [
                        const SizedBox(height: 20),
                        BarbershopInfos(
                            text: barbershop.barbershop.streetAddress,
                            widget: const iconoir.MapPin()),
                        const SizedBox(height: 8.0),
                        BarbershopInfos(
                            text: barbershop.barbershop.phoneNo,
                            widget: const iconoir.Phone()),
                        const SizedBox(height: 8.0),
                        BarbershopInfos(
                            text: barbershop.barbershop.landMark.isEmpty
                                ? 'Nearby landmark not specified'
                                : "Near ${barbershop.barbershop.landMark}",
                            widget: const iconoir.Neighbourhood()),
                        const SizedBox(height: 8.0),
                        BarbershopInfos(
                            text: barbershop.barbershop.email,
                            widget: const iconoir.Mail()),
                        const SizedBox(height: 8.0),
                        BarbershopInfos(
                            text: barbershop.barbershop.floorNumber.isEmpty
                                ? 'Ground Floor'
                                : "Floor ${barbershop.barbershop.floorNumber}",
                            widget: const iconoir.Elevator()),
                        const SizedBox(height: 8.0),
                        OutlinedButton(
                          onPressed: () async {
                            Get.to(() =>
                                CustomerReviewsPage(barbershop: barbershop));
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const SizedBox(width: 3),
                              const Text('Reviews'),
                              const SizedBox(width: 3),
                              iconoir.StarSolid(
                                height: 15,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 3),
                              Flexible(
                                child: Text(
                                  // Calculate the average rating
                                  (barbershop.review.isEmpty
                                          ? 0.0
                                          : barbershop.review.fold(
                                                  0.0,
                                                  (sum, review) =>
                                                      sum + review.rating) /
                                              barbershop.review.length)
                                      .toStringAsFixed(
                                          1), // Average rating rounded to 1 decimal place
                                  overflow: TextOverflow.clip,
                                  maxLines: 1,
                                ),
                              ),
                              const SizedBox(width: 3),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Obx(() {
                      if (controller.isLoading.value) {
                        return const Center(child: CircularProgressIndicator());
                      } else if (barbershop.haircuts.isEmpty) {
                        return const Center(
                            child: Text('No haircuts available.'));
                      } else {
                        final haircut = barbershop.haircuts;
                        return GridView.builder(
                          shrinkWrap: true,
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2, // 2 columns
                            mainAxisSpacing: 15, // Spacing between rows
                            crossAxisSpacing: 15, // Spacing between columns
                            childAspectRatio: 0.7,
                            mainAxisExtent:
                                215, // Aspect ratio for vertical cards
                          ),
                          itemCount: barbershop.haircuts.length,
                          itemBuilder: (BuildContext context, int index) {
                            final barbershopHaircut = haircut[index];
                            return HaircutsCard(haircut: barbershopHaircut);
                          },
                        );
                      }
                    }),
                  ]),
                ),
              ],
            ),
          ),
        ),
        bottomNavigationBar: Padding(
            padding: const EdgeInsets.fromLTRB(20, 5, 20, 20),
            child: SizedBox(
              child: ElevatedButton(
                  onPressed: () {
                    Get.to(() =>
                        ChooseHaircut(barbershopCombinedData: barbershop));
                  },
                  child: const Text('Book Now')),
            )),
      ),
    );
  }
}
