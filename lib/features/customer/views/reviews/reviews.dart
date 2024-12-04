import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:barbermate/features/customer/controllers/review_controller/review_controller.dart';
import 'package:barbermate/features/customer/views/dashboard/dashboard.dart';
import 'package:barbermate/utils/constants/format_date.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomerReviewsPage extends StatelessWidget {
  const CustomerReviewsPage({super.key, required this.barbershop});

  final BarbershopCombinedModel barbershop;

  @override
  Widget build(BuildContext context) {
    final ReviewControllerCustomer controller = Get.find();
    final GetHaircutsAndBarbershopsController customerController = Get.find();
    final BFormatter format = Get.put(BFormatter());

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('Write a Review'),
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Obx(
          () {
            if (customerController.isLoading.value) {
              return const Center(child: CircularProgressIndicator());
            } else if (barbershop.review.isEmpty) {
              return const Center(child: Text('No reviews available.'));
            } else {
              return ListView.builder(
                itemCount: barbershop.review.length,
                padding: const EdgeInsets.all(20),
                itemBuilder: (context, index) {
                  final review = barbershop.review[index];
                  return Padding(
                    padding: const EdgeInsets.all(5.0),
                    child: SizedBox(
                      height: 90,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Column(
                            children: [
                              Container(
                                height: 50,
                                width: 50,
                                decoration: BoxDecoration(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  color: Colors.grey[300],
                                ),
                                child: ClipRRect(
                                  borderRadius: const BorderRadius.all(
                                      Radius.circular(10)),
                                  child: Image(
                                    fit: BoxFit.cover,
                                    image: NetworkImage(review.customerImage),
                                  ),
                                ),
                              ),
                              const SizedBox(height: 5),
                              Row(
                                children: [
                                  const Icon(Icons.star,
                                      size: 15, color: Colors.orange),
                                  const SizedBox(width: 3),
                                  Text('${review.rating}'),
                                ],
                              )
                            ],
                          ),
                          const SizedBox(width: 5),
                          Expanded(
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              child: Container(
                                height: 100,
                                color: Colors.grey.shade300,
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Column(
                                    children: [
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            review.name,
                                            textAlign: TextAlign.justify,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                          Text(
                                            format.formatDate(review.createdAt),
                                            textAlign: TextAlign.justify,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                            overflow: TextOverflow.ellipsis,
                                            maxLines: 1,
                                          ),
                                        ],
                                      ),
                                      const Divider(),
                                      Row(
                                        children: [
                                          Flexible(
                                            child: Text(
                                              review.reviewText,
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyMedium,
                                              overflow: TextOverflow.ellipsis,
                                              maxLines: 4,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
      bottomNavigationBar: SizedBox(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: ElevatedButton(
            onPressed: () => _showWriteReviewDialog(context, controller),
            child: const Text('Write a Review'),
          ),
        ),
      ),
    );
  }

  void _showWriteReviewDialog(
      BuildContext context, ReviewControllerCustomer controller) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Write a Review'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: controller.reviewText,
                decoration: const InputDecoration(labelText: 'Your Review'),
                maxLines: 3,
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.ratingController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(labelText: 'Rating (0-5)'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Get.back(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () async {
                final rating =
                    double.tryParse(controller.ratingController.text) ?? 0.0;

                if (controller.reviewText.text.isNotEmpty &&
                    rating > 0 &&
                    rating <= 5) {
                  controller.review.value.rating = rating;
                  controller.addReview(barbershop.barbershop.id);
                  Get.off(() => const CustomerDashboard());
                } else {
                  Get.snackbar('Invalid Input',
                      'Please provide valid review and rating.');
                }
              },
              child: const Text('Submit'),
            ),
          ],
        );
      },
    );
  }
}
