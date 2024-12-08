import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/views/widgets/management/haircut_card.dart';
import 'package:barbermate/features/customer/views/widgets/barbershop/barbershop_infos.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopProfile extends StatelessWidget {
  const BarbershopProfile({super.key});

  @override
  Widget build(BuildContext context) {
    const double bannerHeight = 150;
    const double profileHeight = 80;
    const top = bannerHeight - profileHeight / 2;
    const bottom = profileHeight / 2;
    final controller = Get.put(BarbershopController());

    return DefaultTabController(
        length: 2,
        initialIndex: 0,
        child: Scaffold(
          appBar: AppBar(
            centerTitle: true,
            title: Text(
              controller.barbershop.value.barbershopName,
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
                            child: controller.barbershopCombinedModel.value
                                    .barbershop.barbershopBannerImage.isEmpty
                                ? Image.asset('assets/images/barbershop.jpg',
                                    fit: BoxFit.cover)
                                : Image.network(
                                    controller.barbershopCombinedModel.value
                                        .barbershop.barbershopBannerImage,
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
                                  color: Theme.of(context)
                                      .scaffoldBackgroundColor)),
                          child: SizedBox(
                            width: 80,
                            height: profileHeight,
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: controller.barbershopCombinedModel.value
                                      .barbershop.barbershopProfileImage.isEmpty
                                  ? Image.asset('assets/images/prof.jpg',
                                      fit: BoxFit.cover)
                                  : Image.network(
                                      controller.barbershopCombinedModel.value
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
                        child: Text(
                            controller.barbershopCombinedModel.value.barbershop
                                .barbershopName,
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
                              text: controller.barbershopCombinedModel.value
                                  .barbershop.streetAddress,
                              widget: const iconoir.MapPin()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: controller.barbershopCombinedModel.value
                                  .barbershop.phoneNo,
                              widget: const iconoir.Phone()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: controller.barbershopCombinedModel.value
                                      .barbershop.landMark.isEmpty
                                  ? 'Nearby landmark not specified'
                                  : "Near ${controller.barbershopCombinedModel.value.barbershop.landMark}",
                              widget: const iconoir.Neighbourhood()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: controller.barbershopCombinedModel.value
                                  .barbershop.email,
                              widget: const iconoir.Mail()),
                          const SizedBox(height: 8.0),
                          BarbershopInfos(
                              text: controller.barbershopCombinedModel.value
                                      .barbershop.floorNumber.isEmpty
                                  ? 'Ground Floor'
                                  : "Floor ${controller.barbershopCombinedModel.value.barbershop.floorNumber}",
                              widget: const iconoir.Elevator()),
                          const SizedBox(height: 8.0),
                          OutlinedButton(
                            onPressed: () async {
                              // Get.to(() =>
                              //     CustomerReviewsPage(barbershop: barbershop));
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
                                    (controller.barbershopCombinedModel.value
                                                .review.isEmpty
                                            ? 0.0
                                            : controller.barbershopCombinedModel
                                                    .value.review
                                                    .fold(
                                                        0.0,
                                                        (sum, review) =>
                                                            sum +
                                                            review.rating) /
                                                controller
                                                    .barbershopCombinedModel
                                                    .value
                                                    .review
                                                    .length)
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
                          return const Center(
                              child: CircularProgressIndicator());
                        } else if (controller
                            .barbershopCombinedModel.value.haircuts.isEmpty) {
                          return const Center(
                              child: Text('No haircuts available.'));
                        } else {
                          final haircut =
                              controller.barbershopCombinedModel.value.haircuts;
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
                            itemCount: controller
                                .barbershopCombinedModel.value.haircuts.length,
                            itemBuilder: (BuildContext context, int index) {
                              final barbershopHaircut = haircut[index];
                              return HaircutCard2(haircut: barbershopHaircut);
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
        ));
  }
}
