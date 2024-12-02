// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:barbermate/features/customer/views/account/edit_email.dart';
import 'package:barbermate/features/customer/views/account/edit_number.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconoir_flutter/iconoir_flutter.dart' as iconoir;
import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate/features/customer/views/account/edit_name.dart';

class CustomerAccount extends StatelessWidget {
  const CustomerAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final CustomerController customerController = Get.find();
    final BFormatter format = Get.put(BFormatter());

    return Scaffold(
      appBar: AppBar(
        title: const Text('Account'),
        centerTitle: true,
      ),
      body: Obx(() {
        // Show loading indicator when data is being fetched
        if (customerController.profileLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        // Access customer data
        final customer = customerController.customer.value;

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
                      customerController.customer.value.profileImage,
                      fit: BoxFit.cover,
                    )),
              ),
              TextButton(
                  onPressed: () => customerController.uploadImage('Profile'),
                  child: const Text('Upload Photo')),
              // Full Name
              const SizedBox(height: 5),
              CanBeEdited(
                text: '${customer.firstName} ${customer.lastName}',
                leading: 'Name',
                onPressed: () {
                  Get.to(() => const CustomerEditName());
                },
              ),
              const SizedBox(height: 5),
              // Email
              CanBeEdited(
                text: customer.email,
                leading: 'Email',
                onPressed: () {
                  Get.to(() => const CustomerEditEmail());
                },
              ),
              const SizedBox(height: 5),
              CanBeEdited(
                text: customer.phoneNo,
                leading: 'Phone',
                onPressed: () {
                  Get.to(() => const CustomerEditNumber());
                },
              ),
              CanBeEdited(
                text: 'Change Password',
                leading: 'Password',
                onPressed: () {
                  Get.to(() => const CustomerEditNumber());
                },
              ),
              const SizedBox(height: 5),
              CannotBeEdited(
                text: format.formatDate(customer.createdAt),
                leading: 'Created At',
              ),

              // Phone Number
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
