import 'dart:async';

import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewControllerCustomer extends GetxController {
  static ReviewControllerCustomer get instance => Get.find();
  final ReviewRepo _repo = Get.put(ReviewRepo());

  // Observable list for storing reviews in real-time
  final reviewsList = <ReviewsModel>[].obs;
  final reviewTextController = TextEditingController();
  final ratingController = TextEditingController();
  final CustomerController customer = Get.find();
  Rx<ReviewsModel> review = ReviewsModel.empty().obs;

  // Observable for storing the average rating
  final averageRating = 0.0.obs;

  StreamSubscription? _reviewsStreamSubscription;

  // Add a review
  Future<void> addReview(String babershopId) async {
    try {
      await _repo.createReview(review.value, customer.customer.value);
      Get.snackbar('Success', 'Review added successfully!');
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Fetch reviews for a barbershop and update the observable list
  void listenToReviewsStream(String barberShopId) {
    // Listen to the reviews stream
    _repo.fetchReviewsStream(barberShopId).listen(
      (reviews) {
        reviewsList.assignAll(reviews); // Update the reviews list reactively

        // Calculate average rating whenever the reviews list is updated
        calculateAverageRating(reviews);
      },
      onError: (error) {
        // Handle errors here
        ToastNotif(message: error.toString(), title: 'Error fetching reviews')
            .showErrorNotif(Get.context!);
      },
    );
  }

// Calculate the average rating from the reviews list
  void calculateAverageRating(List<ReviewsModel> reviews) {
    try {
      if (reviews.isEmpty) {
        averageRating.value = 0.0; // If no reviews, set average to 0
        return;
      }

      double totalRating = 0.0;
      for (var review in reviews) {
        totalRating += review.rating; // Sum up all ratings
      }

      // Calculate the average rating and format it to 1 decimal place
      double calculatedRating = totalRating / reviews.length;
      averageRating.value = double.parse(
          calculatedRating.toStringAsFixed(1)); // Format to 1 decimal place
    } catch (e) {
      Get.snackbar('Error', 'Error calculating average rating: $e');
    }
  }

  @override
  void onClose() {
    // Cancel the stream subscription to prevent memory leaks
    _reviewsStreamSubscription?.cancel();
    super.onClose();
  }
}
