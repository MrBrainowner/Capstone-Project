import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate/features/customer/views/barbershop/barbershop.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class SuggestHairstyle extends StatelessWidget {
  const SuggestHairstyle({
    super.key,
    required this.haircut,
    required this.barbershop,
  });

  final HaircutModel haircut;
  final BarbershopCombinedModel barbershop;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => BarbershopProfilePage(barbershop: barbershop));
      },
      child: SizedBox(
        child: Card(
          elevation: 2, // Add elevation for better feedback
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(8), // Border radius for rounded corners
          ),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(3)),
                  child: Image(
                    height: 140,
                    fit: BoxFit.cover,
                    image: haircut.imageUrl.isNotEmpty
                        ? NetworkImage(haircut.imageUrl)
                        : const AssetImage('assets/images/prof.jpg')
                            as ImageProvider,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  haircut.name,
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                ),
                const SizedBox(height: 2),
                Flexible(
                    child: Text(
                  barbershop.barbershop.barbershopName,
                  maxLines: 2,
                  overflow: TextOverflow.clip,
                )),
                // Row(
                //   mainAxisAlignment: MainAxisAlignment.start,
                //   children: [
                //     const SizedBox(width: 3),
                //     const iconoir.StarSolid(
                //       height: 15,
                //     ),
                //     const SizedBox(width: 3),
                //     Flexible(
                //       child: Text(
                //         // Calculate the average rating
                //         (barbershop.review.isEmpty
                //                 ? 0.0
                //                 : barbershop.review.fold(0.0,
                //                         (sum, review) => sum + review.rating) /
                //                     barbershop.review.length)
                //             .toStringAsFixed(
                //                 1), // Average rating rounded to 1 decimal place
                //         overflow: TextOverflow.clip,
                //         maxLines: 1,
                //       ),
                //     ),
                //     const SizedBox(width: 3),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
