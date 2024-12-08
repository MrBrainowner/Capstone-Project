import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/barbershop/views/account/edit_address.dart';
import 'package:barbermate/features/barbershop/views/account/edit_barbershop_name.dart';
import 'package:barbermate/features/barbershop/views/account/edit_email.dart';
import 'package:barbermate/features/barbershop/views/account/edit_floors.dart';
import 'package:barbermate/features/barbershop/views/account/edit_landmark.dart';
import 'package:barbermate/features/barbershop/views/account/edit_name.dart';
import 'package:barbermate/features/barbershop/views/account/edit_number.dart';
import 'package:barbermate/features/barbershop/views/account/edit_password.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopAccount extends StatelessWidget {
  const BarbershopAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final barbershopController = Get.put(BarbershopController());
    final BFormatter format = Get.put(BFormatter());

    return Scaffold(
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
          final barbershop = barbershopController.barbershopCombinedModel;

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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        barbershop.value.barbershop.profileImage,
                        fit: BoxFit.cover,
                      )),
                ),

                TextButton(
                    onPressed: () =>
                        barbershopController.uploadImage('Profile'),
                    child: const Text('Upload Photo')),
                Text(
                  'Owner/Manager Account',
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const Divider(),
                // Full Name
                CanBeEdited(
                  text:
                      '${barbershop.value.barbershop.firstName} ${barbershop.value.barbershop.lastName}',
                  leading: 'Name',
                  onPressed: () {
                    Get.to(() => const EditNameBarbershop());
                  },
                ),

                // Email
                CanBeEdited(
                  text: barbershop.value.barbershop.email,
                  leading: 'Email',
                  onPressed: () => Get.to(() => const BarbershopEditEmail()),
                ),

                // Phone Number
                CanBeEdited(
                  text: barbershop.value.barbershop.phoneNo,
                  leading: 'Phone',
                  onPressed: () => Get.to(() => const BarbershopEditNumber()),
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: barbershop
                              .value.barbershop.barbershopBannerImage.isEmpty
                          ? const Center(child: Text('Upload Profile'))
                          : Image.network(
                              barbershop.value.barbershop.barbershopBannerImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () => barbershopController.uploadImage('Banner'),
                    child: const Text('Upload Your Barbershop Banner')),
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
                      borderRadius: const BorderRadius.all(Radius.circular(10)),
                      child: barbershop
                              .value.barbershop.barbershopProfileImage.isEmpty
                          ? const Center(child: Text('Upload Logo'))
                          : Image.network(
                              barbershop
                                  .value.barbershop.barbershopProfileImage,
                              fit: BoxFit.cover,
                            ),
                    ),
                  ),
                ),
                TextButton(
                    onPressed: () => barbershopController.uploadImage('Logo'),
                    child: const Text('Upload Your Barbershop Logo')),
                const Divider(),
                const SizedBox(height: 10),
                CanBeEdited(
                  text: barbershop.value.barbershop.address,
                  leading: 'Address',
                  onPressed: () => Get.to(() => const BarbershopEditAddress()),
                ),

                CanBeEdited(
                  text: barbershop.value.barbershop.barbershopName,
                  leading: 'Barbershop Name',
                  onPressed: () =>
                      Get.to(() => const BarbershopEditBarbershopName()),
                ),

                CanBeEdited(
                  text: barbershop.value.barbershop.floorNumber.isEmpty
                      ? 'None'
                      : barbershop.value.barbershop.floorNumber,
                  leading: 'Floor Number',
                  onPressed: () => Get.to(() => const BarbershopEditFloors()),
                ),

                CanBeEdited(
                  text: barbershop.value.barbershop.landMark.isEmpty
                      ? 'None'
                      : barbershop.value.barbershop.landMark,
                  leading: 'Nearby Land Mark',
                  onPressed: () => Get.to(() => const BarbershopEditLandMark()),
                ),
                CanBeEdited(
                  text: 'Change Password',
                  leading: 'Password',
                  onPressed: () {
                    Get.to(() => const BarbershopEditPassword());
                  },
                ),
                const Divider(),
                CannotBeEdited(
                  text:
                      format.formatDate(barbershop.value.barbershop.createdAt),
                  leading: 'Created At',
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}

class CannotBeEdited extends StatelessWidget {
  const CannotBeEdited({
    super.key,
    required this.text,
    required this.leading,
  });

  final String text;
  final String leading;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$leading:  '),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ),
        IconButton(
          onPressed: () {
            ToastNotif(
                    message: "You can't edit this section.",
                    title: 'Uneditable')
                .showNormalNotif(context);
          },
          icon: const iconoir.InfoCircle(),
        ),
      ],
    );
  }
}

class CanBeEdited extends StatelessWidget {
  const CanBeEdited({
    super.key,
    required this.text,
    required this.leading,
    required this.onPressed,
  });

  final String text;
  final String leading;
  final Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text('$leading:  '),
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
