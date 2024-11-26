import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:get/get.dart';

class ReviewController extends GetxController {
  static ReviewController get instance => Get.find();

  final ReviewRepo _repo = Get.put(ReviewRepo());

  // Observable list for storing reviews in real-time
  final reviewsList = <ReviewsModel>[].obs;

  // Observable for storing the average rating
  final averageRating = 0.0.obs;

  @override
  void onInit() async {
    super.onInit();
    await fetchReviewsForBarbershop();
  }

  // Fetch reviews for a barbershop and update the observable list
  Future<void> fetchReviewsForBarbershop() async {
    try {
      final reviews = await _repo.fetchReviewsForBarbershop();
      reviewsList.value = reviews;
      calculateAverageForBarbershop();
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }

  // Calculate average rating for a barbershop
  Future<void> calculateAverageForBarbershop() async {
    try {
      final rating = await _repo.calculateAverageForBarbershop();
      averageRating.value = rating;
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}
