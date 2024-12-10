import 'dart:async';
import 'package:barbermate/data/models/available_days/available_days.dart';
import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/timeslot_repository.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:rxdart/rxdart.dart' as rx;

class BarbershopController extends GetxController {
  static BarbershopController get instance => Get.find();

  // Variables
  final profileLoading = false.obs;
  Rx<BarbershopModel> barbershop = BarbershopModel.empty().obs;
  final BarbershopRepository barbershopRepository = Get.find();
  final _authRepository = Get.put(AuthenticationRepository());
  final TimeslotRepository _timeslotsRepository = Get.find();
  final ReviewRepo _reviewRepository = Get.find();
  var isLoading = true.obs;
  final firstName = TextEditingController();
  final lastName = TextEditingController();
  TextEditingController email = TextEditingController();
  final password = TextEditingController();
  final number = TextEditingController();
  final address = TextEditingController();
  final floors = TextEditingController();
  final landmark = TextEditingController();
  final barbershopName = TextEditingController();
  final currentPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  GlobalKey<FormState> signUpFormKey = GlobalKey<FormState>();
  final hidePassword = true.obs;
  final ImagePicker _picker = ImagePicker();
  final Logger logger = Logger();
  var error = ''.obs;
  GlobalKey<FormState> key = GlobalKey<FormState>();

  Rx<BarbershopCombinedModel> barbershopCombinedModel =
      BarbershopCombinedModel.empty().obs;

  @override
  void onInit() {
    super.onInit();
    listenToBarbershopStream();
  }

  // update the exist field to make the profile setup only once
  void makeBarbershopExist() async {
    await barbershopRepository.makeBarbershopExist();
  }

  Future<void> uploadImage(String type) async {
    try {
      // Pick an image from the gallery
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);

      if (pickedFile == null) {
        return;
      } else {
        ToastNotif(message: 'Your image is uploading', title: 'Uploading')
            .showSuccessNotif(Get.context!);
      }

      // Upload the image to Firebase Storage
      final downloadUrl = await barbershopRepository.uploadImageToStorage(
          XFile(pickedFile.path), type);

      if (downloadUrl != null) {
        // Update Firestore with the image URL
        await barbershopRepository.updateProfileImageInFirestore(
            barbershop.value.id, downloadUrl, type);

        ToastNotif(
                message: 'Profile image updated successfully', title: 'Success')
            .showSuccessNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(message: 'Failed to upload profile image', title: 'Error')
          .showSuccessNotif(Get.context!);
    }
  }

  // Fetch Barbershop Data
  void listenToBarbershopStream() {
    isLoading(true); // Show loading indicator

    // Fetch the specific barbershop by its ID
    barbershopRepository.barbershopDetailsStream().listen((barbershop) {
      // Fetch the streams for haircuts, time slots, reviews, and available days
      Stream<List<HaircutModel>> haircutsStream = barbershopRepository
          .fetchBarbershopHaircuts(_authRepository.authUser!.uid);
      Stream<List<TimeSlotModel>> timeSlotsStream = _timeslotsRepository
          .fetchBarbershopTimeSlotsStream(_authRepository.authUser!.uid);
      Stream<List<ReviewsModel>> reviewsStream =
          _reviewRepository.fetchReviews(_authRepository.authUser!.uid);
      Stream<AvailableDaysModel?> availableDaysStream =
          _timeslotsRepository.getAvailableDaysWhenCustomerIsCurrentUserStream(
              _authRepository.authUser!.uid);

      // Combine all the streams for the barbershop data
      rx.CombineLatestStream.combine4<List<HaircutModel>, List<TimeSlotModel>,
          List<ReviewsModel>, AvailableDaysModel?, BarbershopCombinedModel>(
        haircutsStream,
        timeSlotsStream,
        reviewsStream,
        availableDaysStream,
        (haircuts, timeSlots, reviews, availableDays) {
          logger.i('Barbershop ID: ${_authRepository.authUser!.uid}');
          logger.i('Haircuts (${haircuts.length}): $haircuts');
          logger.i('Time Slots (${timeSlots.length}): $timeSlots');
          logger.i('Reviews (${reviews.length}): $reviews');
          logger.i(
              'Available Days: ${availableDays?.disabledDates ?? 'No data'}');

          // Return the combined model for the specific barbershop
          return BarbershopCombinedModel(
            barbershop: barbershop,
            haircuts: haircuts,
            timeslot: timeSlots,
            review: reviews,
            availableDays: availableDays,
          );
        },
      ).listen((result) {
        // Update the state with the fetched data for the barbershop
        barbershopCombinedModel.value =
            result; // Use .value to assign a single value
        isLoading(false); // Hide loading spinner
      }, onError: (error) {
        logger.e("Error fetching combined data for barbershop: $error");
        isLoading(false);
      });
    }, onError: (error) {
      logger.e("Error fetching barbershop by ID: $error");
      isLoading(false);
    });
  }

  // Save Barbershop data from any registration provider
  Future<void> saveBarbershopData({
    String? firstNamee,
    String? lastNamee,
  }) async {
    try {
      final user = FirebaseAuth.instance.currentUser;

      if (user != null) {
        final existingData = barbershop.value;

        // Create an updated model only with the fields you want to change
        final updatedBarbershop = existingData.copyWith(
          firstName: firstNamee ?? barbershop.value.firstName,
          lastName: lastNamee ?? barbershop.value.lastName,
        );

        // Update the barbershop data in Firestore
        await barbershopRepository.updateBarbershopData(updatedBarbershop);
        ToastNotif(message: 'Update Successful', title: 'Success')
            .showSuccessNotif(Get.context!);
      }
    } catch (e) {
      ToastNotif(
              message: 'Someting went wrong while saving your information. $e.',
              title: 'Data not saved')
          .showWarningNotif(Get.context!);
    }
  }

  // Update a single fied
  Future<void> updateSingleFieldBarbershop(Map<String, dynamic> json) async {
    try {
      await barbershopRepository.updateBarbershopSingleField(json);
      ToastNotif(
        message: 'Field updated successfully.',
        title: 'Success',
      ).showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(
        message: e.toString(),
        title: 'Error',
      ).showErrorNotif(Get.context!);
    }
  }

  // change password
  Future<void> changePassword() async {
    try {
      profileLoading.value = true;

      if (!signUpFormKey.currentState!.validate()) {
        return;
      }

      // Call the repository method to change the password
      await _authRepository.changePassword(
          email.text.trim(),
          currentPasswordController.text.trim(),
          newPasswordController.text.trim());
    } catch (e) {
      // Show an error message if something went wrong
      Get.snackbar('Error', 'Failed to change password: ${e.toString()}');
    } finally {
      profileLoading.value = false;
    }
  }
}
