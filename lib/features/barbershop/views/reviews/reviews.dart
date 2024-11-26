import 'package:barbermate/features/barbershop/controllers/review_controller/review_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewsPage extends StatelessWidget {
  const ReviewsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final reviewController = Get.put(ReviewController());

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Barbershop Reviews'),
        centerTitle: true,
      ),
      body: RefreshIndicator(
        onRefresh: () async {},
        child: Obx(
          () => ListView.builder(
            itemCount: reviewController.reviewsList.length,
            padding: const EdgeInsets.all(20),
            itemBuilder: (context, index) {
              final review = reviewController.reviewsList[index];
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
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              color: Colors.grey[300],
                            ),
                            child: ClipRRect(
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(10)),
                              child: review.customerImage.isNotEmpty
                                  ? Image.network(
                                      review.customerImage,
                                      fit: BoxFit.cover,
                                      errorBuilder:
                                          (context, error, stackTrace) {
                                        // Placeholder in case of an error loading the image
                                        return const Icon(
                                          Icons.person,
                                          size: 30,
                                          color: Colors.grey,
                                        );
                                      },
                                    )
                                  : const Icon(
                                      Icons.person,
                                      size: 30,
                                      color: Colors.grey,
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
                              child: Text(
                                review.reviewText,
                                textAlign: TextAlign.justify,
                                style: Theme.of(context).textTheme.bodyMedium,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 3,
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
          ),
        ),
      ),
    );
  }
}
