import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopProfile extends StatelessWidget {
  const BarbershopProfile({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(BarbershopController());
    const ngolor = Color.fromRGBO(238, 238, 238, 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Barbershop Profile'),
        centerTitle: true,
        automaticallyImplyLeading: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(5),
                ),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Obx(
                            () => Container(
                              decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.only(
                                      topLeft: Radius.circular(5),
                                      topRight: Radius.circular(5)),
                                  border: Border.all(
                                      width: 1,
                                      color: Theme.of(context).primaryColor)),
                              height: 160,
                              child: controller.barbershop.value
                                      .barbershopBannerImage.isNotEmpty
                                  ? Image.network(
                                      controller.barbershop.value
                                          .barbershopBannerImage,
                                      fit: BoxFit.cover)
                                  : ClipRRect(
                                      borderRadius: const BorderRadius.only(
                                          topLeft: Radius.circular(5),
                                          topRight: Radius.circular(5)),
                                      child: Image.asset(
                                          'assets/images/barbershop.jpg',
                                          fit: BoxFit.cover),
                                    ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          border: Border.all(
                              width: 1, color: Theme.of(context).primaryColor)),
                      child: Row(
                        children: [
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  height: 70,
                                  width: 70,
                                  decoration: const BoxDecoration(
                                      borderRadius:
                                          BorderRadius.all(Radius.circular(5))),
                                  child: const ClipRRect(
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(5)),
                                    child: Image(
                                        fit: BoxFit.cover,
                                        image: AssetImage(
                                            'assets/images/prof.jpg')),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Obx(
                                  () => Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller
                                            .barbershop.value.barbershopName,
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleLarge
                                            ?.copyWith(color: Colors.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                      ),
                                      Text(
                                        controller.barbershop.value.address,
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodyMedium
                                            ?.copyWith(color: Colors.white),
                                        maxLines: 2,
                                        overflow: TextOverflow.fade,
                                      ),
                                      const SizedBox(height: 5),
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          iconoir.StarSolid(
                                            color: ngolor,
                                            height: 15,
                                          ),
                                          iconoir.StarSolid(
                                            color: ngolor,
                                            height: 15,
                                          ),
                                          iconoir.StarSolid(
                                            color: ngolor,
                                            height: 15,
                                          ),
                                          iconoir.StarSolid(
                                            color: ngolor,
                                            height: 15,
                                          ),
                                          iconoir.Star(
                                            color: ngolor,
                                            height: 15,
                                          )
                                        ],
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24.0),
            ],
          ),
        ),
      ),
    );
  }
}
