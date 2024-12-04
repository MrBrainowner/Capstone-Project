// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:barbermate/features/customer/views/barbershop/barbershop.dart';
import 'package:barbermate/utils/themes/text_theme.dart';
import '../../../../../utils/themes/outline_button_theme.dart';
import '../../../controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import '../../booking/choose_haircut.dart';

class CustomerBarbershopCard extends StatelessWidget {
  const CustomerBarbershopCard({
    super.key,
    required this.barbershop,
  });

  final BarbershopCombinedModel barbershop;

  @override
  Widget build(BuildContext context) {
    final darkThemeOutlinedButton =
        BarbermateOutlinedButton.darkThemeOutlinedButton.style;
    final forOutlinedDarkText = BarbermateTextTheme.darkTextTheme.bodyMedium;
    final GetHaircutsAndBarbershopsController controller = Get.find();

    const ngolor = Color.fromRGBO(238, 238, 238, 1);
    return SizedBox(
      width: 300,
      height: 300,
      child: Card(
        color: Theme.of(context).primaryColor,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SizedBox.expand(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Stack(
                  children: [
                    SizedBox(
                      width: double.infinity,
                      height: 130,
                      child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(5)),
                        child:
                            barbershop.barbershop.barbershopBannerImage.isEmpty
                                ? Image.asset('assets/images/barbershop.jpg',
                                    fit: BoxFit.cover)
                                : Image.network(
                                    barbershop.barbershop.barbershopBannerImage,
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
                            const SizedBox(width: 3),
                            iconoir.StarSolid(
                              height: 15,
                              color: Colors.yellow.shade600,
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
                                style: TextStyle(color: Colors.yellow.shade600),
                              ),
                            ),
                            const SizedBox(width: 3),
                          ],
                        ),
                      ),
                    )
                  ],
                ),
                Row(
                  children: [
                    Text(
                      barbershop.barbershop.openHours == null ||
                              barbershop.barbershop.openHours!.isEmpty
                          ? 'UNVERIFIED'
                          : controller.isOpenNow.value
                              ? 'OPEN NOW'
                              : 'CLOSED',
                      maxLines: 1,
                      style: Theme.of(context).textTheme.labelLarge?.copyWith(
                            color: barbershop.barbershop.openHours == null ||
                                    barbershop.barbershop.openHours!.isEmpty
                                ? Colors.orange
                                : controller.isOpenNow.value
                                    ? Colors.green
                                    : Colors.red,
                          ),
                    )
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Text(barbershop.barbershop.barbershopName,
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
                          child: Text(barbershop.barbershop.address,
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
                                onPressed: () async {
                                  Get.to(() => BarbershopProfilePage(
                                      barbershop: barbershop));
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
                                  onPressed: () async {
                                    Get.to(() => ChooseHaircut(
                                        barbershopCombinedData: barbershop));
                                  },
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
