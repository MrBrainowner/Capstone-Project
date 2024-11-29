import 'dart:async';

import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ReviewControllerCustomer extends GetxController {
  static ReviewControllerCustomer get instance => Get.find();
  final ReviewRepo _repo = Get.find();

  // Observable list for storing reviews in real-time
  final reviewsList = <ReviewsModel>[].obs;
  final reviewTextController = TextEditingController();
  final ratingController = TextEditingController();
  final CustomerController customer = Get.find();
  Rx<ReviewsModel> review = ReviewsModel.empty().obs;

  // Observable for storing the average rating
  final averageRatingValue = 0.0.obs;

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
  Future<void> loadReviews(String barberShopId) async {
    try {
      final reviews = await _repo.fetchReviews(barberShopId);
      reviewsList.assignAll(reviews); // Update the reviews list reactively
    } catch (error) {
      // Handle errors here
      ToastNotif(message: error.toString(), title: 'Error fetching reviews')
          .showErrorNotif(Get.context!);
    }
  }

  Future<void> loadAverageRating(String barberShopId) async {
    try {
      final averageRating = await _repo.fetchAverageRating(barberShopId);
      averageRatingValue.value = averageRating;
    } catch (error) {
      ToastNotif(
        message: error.toString(),
        title: 'Error fetching rating',
      ).showErrorNotif(Get.context!);
    }
  }
}
