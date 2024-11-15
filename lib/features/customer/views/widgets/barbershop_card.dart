import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:barbermate/features/customer/views/barbershop/barbershop.dart';
import 'package:barbermate/utils/themes/text_theme.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

import '../../../../utils/themes/outline_button_theme.dart';

class CustomerBarbershopCard extends StatelessWidget {
  const CustomerBarbershopCard({super.key, required this.barberhop});

  final BarbershopModel barberhop;

  @override
  Widget build(BuildContext context) {
    final darkThemeOutlinedButton =
        BarbermateOutlinedButton.darkThemeOutlinedButton.style;
    final forOutlinedDarkText = BarbermateTextTheme.darkTextTheme.bodyMedium;

    const ngolor = Color.fromRGBO(238, 238, 238, 1);
    return SizedBox(
      width: 280,
      height: 300,
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox.expand(
            child: Column(
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 130,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child: Image.asset('assets/images/barbershop.jpg',
                            fit: BoxFit.cover),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius:
                              const BorderRadius.all(Radius.circular(5)),
                          color: Theme.of(context).primaryColor,
                        ),
                        height: 20,
                        width: 50,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            iconoir.StarSolid(
                              height: 15,
                              color: Colors.yellow.shade700,
                            ),
                            const SizedBox(width: 3),
                            const Text(
                              '4.5',
                              style: TextStyle(color: ngolor),
                            )
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 10),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text('OPEN NOW',
                            maxLines: 1,
                            style: Theme.of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(color: Colors.green))
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Text(barberhop.barbershopName,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyLarge
                                  ?.copyWith(color: ngolor)),
                        )
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Text(barberhop.address,
                              overflow: TextOverflow.clip,
                              maxLines: 1,
                              style: Theme.of(context)
                                  .textTheme
                                  .labelMedium
                                  ?.copyWith(color: ngolor)),
                        )
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: [
                        Expanded(
                          child: Row(
                            children: [
                              OutlinedButton(
                                onPressed: () {
                                  Get.to(() => BarbershopProfilePage(
                                      barbershopName: barberhop.barbershopName,
                                      barbershopAddress: barberhop.address,
                                      barbershopImage:
                                          barberhop.barbershopBannerImage,
                                      rating: 0,
                                      reviewCount: 0,
                                      haircuts: const []));
                                },
                                style: darkThemeOutlinedButton,
                                child: const iconoir.Shop(
                                  color: ngolor,
                                  height: 30,
                                ),
                              ),
                              const SizedBox(width: 5),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () {},
                                  style: darkThemeOutlinedButton,
                                  child: Text(
                                    'Book Now',
                                    style: forOutlinedDarkText,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
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
