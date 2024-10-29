import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../management/haircut/edit.dart';

class HaircutCard extends StatelessWidget {
  final HaircutModel haircut;

  const HaircutCard({
    super.key,
    required this.haircut,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => HaircutEditPage(haircut: haircut)),
      child: Column(
        children: [
          Container(
            height: 150,
            width: double.infinity,
            decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(Radius.circular(5))),
            child: ClipRRect(
              borderRadius: const BorderRadius.all(Radius.circular(5)),
              child: Image(
                  fit: BoxFit.cover,
                  image: haircut.imageUrls.isNotEmpty
                      ? NetworkImage(haircut.imageUrls.first)
                      : const AssetImage('assets/images/prof.jpg')
                          as ImageProvider),
            ),
          ),
          const SizedBox(height: 3),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        haircut.name,
                        style: const TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 3),
          Container(
            decoration: BoxDecoration(
                color: Theme.of(context).primaryColor,
                borderRadius: const BorderRadius.all(Radius.circular(5))),
            child: Row(
              children: [
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "${haircut.price}",
                        style: const TextStyle(
                            color: Color.fromRGBO(238, 238, 238, 1)),
                      )
                    ],
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}
