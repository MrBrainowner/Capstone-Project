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
  final customer = Get.put(CustomerController());
  Rx<ReviewsModel> review = ReviewsModel.empty().obs;

  // Observable for storing the average rating
  final averageRating = 0.0.obs;

  // Add a review
  Future<void> addReview() async {
    try {
      await _repo.createReview(review.value, customer.customer.value);
      Get.snackbar('Success', 'Review added successfully!');
      fetchReviews(); // Refresh the reviews list
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Fetch reviews for a barbershop and update the observable list
  Future<void> fetchReviews() async {
    try {
      final reviews = await _repo.fetchReviews(review.value.barberShopId);
      reviewsList.value = reviews;
      calculateAverageRating(review.value.barberShopId);
    } catch (e) {
      ToastNotif(message: e.toString(), title: 'Error fetching reviews')
          .showErrorNotif(Get.context!);
    }
  }

  // Calculate average rating for a barbershop
  Future<void> calculateAverageRating(String barberShopId) async {
    try {
      final rating = await _repo.calculateAverageRating(barberShopId);
      averageRating.value = rating;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
