import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/barbershop/controllers/barbershop_controller/barbershop_controller.dart';
import 'package:barbermate/features/customer/views/account/edit_name.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;

class BarbershopAccount extends StatelessWidget {
  const BarbershopAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final barbershopController = Get.put(BarbershopController());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading indicator when data is being fetched
        if (barbershopController.profileLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Access customer data
        final barbershop = barbershopController.barbershop.value;

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
                      barbershopController.barbershop.value.profileImage,
                      fit: BoxFit.cover,
                    )),
              ),
              const SizedBox(height: 16),
              TextButton(
                  onPressed: () => barbershopController.uploadProfileImage(),
                  child: const Text('Upload Photo')),
              // Full Name
              CanBeEdited(
                text: '${barbershop.firstName} ${barbershop.lastName}',
                leading: 'Name',
              ),
              const SizedBox(height: 10),
              // Email
              CannotBeEdited(
                text: barbershop.email,
                leading: 'Email',
              ),
              const SizedBox(height: 8),
              // Phone Number
              CannotBeEdited(
                text: barbershop.phoneNo,
                leading: 'Phone',
              ),
            ],
          ),
        );
      }),
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
            Get.to(() => const EditName());
          },
          icon: const iconoir.ArrowRight(),
        ),
      ],
    );
  }
}
