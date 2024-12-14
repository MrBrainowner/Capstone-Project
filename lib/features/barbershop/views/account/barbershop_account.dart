import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/views/account/edit_address.dart';
import 'package:barbermate/features/barbershop/views/account/edit_barbershop_name.dart';
import 'package:barbermate/features/barbershop/views/account/edit_email.dart';
import 'package:barbermate/features/barbershop/views/account/edit_floors.dart';
import 'package:barbermate/features/barbershop/views/account/edit_landmark.dart';
import 'package:barbermate/features/barbershop/views/account/edit_name.dart';
import 'package:barbermate/features/barbershop/views/account/edit_number.dart';
import 'package:barbermate/features/barbershop/views/account/edit_password.dart';
import 'package:barbermate/features/barbershop/views/appointments/appointments.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopAccount extends StatelessWidget {
  const BarbershopAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final BarbershopController barbershopController = Get.find();
    final BFormatter format = Get.put(BFormatter());

    return PopScope(
      canPop: true,
      onPopInvoked: (didPop) async {
        barbershopController.clear();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Account'),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          child: Obx(() {
            // Show loading indicator when data is being fetched
            if (barbershopController.profileLoading.value) {
              return const Center(child: CircularProgressIndicator());
            }

            // Access customer data
            final barbershop = barbershopController.barbershop;

            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Profile Image with if statement
                  Container(
                    height: 100,
                    width: 100,
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                    ),
                    child: ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: Image.network(
                          barbershop.value.profileImage,
                          fit: BoxFit.cover,
                        )),
                  ),

                  TextButton(
                      onPressed: () =>
                          barbershopController.uploadImage('Profile'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          iconoir.MediaImagePlus(),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Upload Photo'),
                        ],
                      )),
                  Text(
                    'Credentials',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  const Divider(),
                  // Full Name
                  CanBeEdited(
                    text:
                        '${barbershop.value.firstName} ${barbershop.value.lastName}',
                    widget: const iconoir.User(),
                    onPressed: () {
                      Get.to(() => const EditNameBarbershop());
                    },
                  ),

                  // Email
                  CanBeEdited(
                    text: barbershop.value.email,
                    widget: const iconoir.Mail(),
                    onPressed: () => Get.to(() => const BarbershopEditEmail()),
                  ),

                  // Phone Number
                  CanBeEdited(
                    text: barbershop.value.phoneNo,
                    widget: const iconoir.Phone(),
                    onPressed: () => Get.to(() => const BarbershopEditNumber()),
                  ),

                  CanBeEdited(
                    text: 'Change Password',
                    widget: const iconoir.Lock(),
                    onPressed: () {
                      Get.to(() => const BarbershopEditPassword());
                    },
                  ),
                  const SizedBox(height: 10),
                  Text(
                    'Barbershop Information',
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),

                  const Divider(),
                  Container(
                    height: 200,
                    width: 300,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Obx(
                      () => ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: barbershop.value.barbershopBannerImage.isEmpty
                            ? const Center(child: Text('Upload Profile'))
                            : Image.network(
                                barbershop.value.barbershopBannerImage,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () =>
                          barbershopController.uploadImage('Banner'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          iconoir.MediaImagePlus(),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Upload Banner'),
                        ],
                      )),
                  const Divider(),
                  Container(
                    height: 100,
                    width: 100,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                    ),
                    child: Obx(
                      () => ClipRRect(
                        borderRadius:
                            const BorderRadius.all(Radius.circular(10)),
                        child: barbershop.value.barbershopProfileImage.isEmpty
                            ? const Center(child: Text('Upload Logo'))
                            : Image.network(
                                barbershop.value.barbershopProfileImage,
                                fit: BoxFit.cover,
                              ),
                      ),
                    ),
                  ),
                  TextButton(
                      onPressed: () => barbershopController.uploadImage('Logo'),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          iconoir.MediaImagePlus(),
                          SizedBox(
                            width: 5,
                          ),
                          Text('Upload Logo'),
                        ],
                      )),
                  const Divider(),
                  const SizedBox(height: 10),
                  CanBeEdited(
                    text: barbershop.value.address,
                    widget: const iconoir.MapPin(),
                    onPressed: () =>
                        Get.to(() => const BarbershopEditAddress()),
                  ),

                  CanBeEdited(
                    text: barbershop.value.barbershopName,
                    widget: const iconoir.Shop(),
                    onPressed: () =>
                        Get.to(() => const BarbershopEditBarbershopName()),
                  ),

                  CanBeEdited(
                    text: barbershop.value.landMark.isEmpty
                        ? 'None'
                        : barbershop.value.landMark,
                    widget: const iconoir.Neighbourhood(),
                    onPressed: () =>
                        Get.to(() => const BarbershopEditLandMark()),
                  ),

                  CanBeEdited(
                    text: barbershop.value.floorNumber.isEmpty
                        ? 'None'
                        : barbershop.value.floorNumber,
                    widget: const iconoir.Elevator(),
                    onPressed: () => Get.to(() => const BarbershopEditFloors()),
                  ),

                  const Divider(),
                  CannotBeEdited(
                    text:
                        'Created at ${format.formatDate(barbershop.value.createdAt)}',
                    widget: const iconoir.Calendar(),
                  ),
                  const SizedBox(height: 10),
                  CannotBeEdited(
                    text: barbershop.value.streetAddress,
                    widget: const iconoir.MapPin(),
                  ),
                  const SizedBox(height: 10),
                  CannotBeEdited(
                    text: "Account status ${barbershop.value.status}",
                    widget: const iconoir.MapPin(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                          child: ElevatedButton(
                        child: const Text('Verify account'),
                        onPressed: () {
                          Get.to(() => const BarbershopAppointments());
                        },
                      ))
                    ],
                  )
                ],
              ),
            );
          }),
        ),
      ),
    );
  }
}

class CannotBeEdited extends StatelessWidget {
  const CannotBeEdited({
    super.key,
    required this.text,
    required this.widget,
  });

  final String text;
  final Widget widget;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget,
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
      ],
    );
  }
}

class CanBeEdited extends StatelessWidget {
  const CanBeEdited({
    super.key,
    required this.text,
    required this.onPressed,
    required this.widget,
  });

  final String text;
  final Widget widget;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        widget,
        const SizedBox(width: 5),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        IconButton(
          onPressed: onPressed,
          icon: const iconoir.ArrowRight(),
        ),
      ],
    );
  }
}
