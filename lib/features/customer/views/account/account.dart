import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerAccount extends StatelessWidget {
  const CustomerAccount({super.key});

  @override
  Widget build(BuildContext context) {
    final customerController = Get.put(CustomerController());

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
                    borderRadius: BorderRadius.all(Radius.circular(10))),
                child: ClipRRect(
                  borderRadius: const BorderRadius.all(Radius.circular(10)),
                  child: Image(
                      fit: BoxFit.cover,
                      image: customer.profileImage.isNotEmpty
                          ? NetworkImage(customer.profileImage)
                          : const AssetImage('assets/images/prof.jpg')
                              as ImageProvider),
                ),
              ),
              const SizedBox(height: 16),
              // Full Name
              Row(
                children: [
                  Expanded(
                    child: Text(
                      '${customer.firstName} ${customer.lastName}',
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // Email
              Row(
                children: [
                  Expanded(
                    child: Text(
                      customer.email,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right_outlined),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Phone Number
              Row(
                children: [
                  Expanded(
                    child: Text(
                      customer.phoneNo,
                      style: Theme.of(context).textTheme.bodyMedium,
                    ),
                  ),
                  IconButton(
                    onPressed: () {},
                    icon: const Icon(Icons.chevron_right_outlined),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
