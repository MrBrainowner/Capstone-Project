import 'package:barbermate/data/models/barber_model/barber_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../management/barbers/edit.dart';

class BarberCard extends StatelessWidget {
  final BarberModel barber;

  const BarberCard({
    super.key,
    required this.barber,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Get.to(() => EditBarberPage(barberModel: barber)),
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
                  image: barber.profileImage.isNotEmpty
                      ? NetworkImage(barber.profileImage)
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
                      barber.fullName,
                      style: const TextStyle(
                          color: Color.fromRGBO(238, 238, 238, 1)),
                    )
                  ],
                )),
              ],
            ),
          )
        ],
      ),
    );
  }
}
