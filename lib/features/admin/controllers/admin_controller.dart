import 'package:barbermate/data/models/available_days/available_days.dart';
import 'package:barbermate/data/models/combined_model/barbershop_combined_model.dart';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:barbermate/data/models/review_model/review_model.dart';
import 'package:barbermate/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate/data/repository/barbershop_repo/barbershop_repo.dart';
import 'package:barbermate/data/repository/barbershop_repo/timeslot_repository.dart';
import 'package:barbermate/data/repository/review_repo/review_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:rxdart/rxdart.dart' as rx;
import '../../auth/models/barbershop_model.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();

  final BarbershopRepository _barbershopRepository = Get.find();
  final TimeslotRepository _timeslotsRepository = Get.find();
  final ReviewRepo _reviewRepository = Get.find();
  RxList<BarbershopCombinedModel> barbershopCombinedModel =
      <BarbershopCombinedModel>[].obs;

  var isLoading = true.obs;
  var error = ''.obs;

  var documents = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchAllBarbershopData();
  }

  void fetchAllBarbershopData() {
    isLoading(true);

    _barbershopRepository.fetchAllBarbershopsFromAdmin().listen(
        (barbershopList) {
      List<Stream<BarbershopCombinedModel>> barbershopDataStreams =
          barbershopList.map((barbershop) {
        // Fetch haircut, timeslot, and review streams for each barbershop
        Stream<List<HaircutModel>> haircutsStream =
            _barbershopRepository.fetchBarbershopHaircuts(barbershop.id);
        Stream<List<TimeSlotModel>> timeSlotsStream =
            _timeslotsRepository.fetchBarbershopTimeSlotsStream(barbershop.id);
        Stream<List<ReviewsModel>> reviewsStream =
            _reviewRepository.fetchReviews(barbershop.id);
        Stream<AvailableDaysModel?> availableDaysStream = _timeslotsRepository
            .getAvailableDaysWhenCustomerIsCurrentUserStream(barbershop.id);

        // Combine all streams for a single barbershop
        return rx.CombineLatestStream.combine4<
            List<HaircutModel>,
            List<TimeSlotModel>,
            List<ReviewsModel>,
            AvailableDaysModel?,
            BarbershopCombinedModel>(
          haircutsStream,
          timeSlotsStream,
          reviewsStream,
          availableDaysStream,
          (haircuts, timeSlots, reviews, availableDays) {
            logger.i('Barbershop ID: ${barbershop.id}');
            logger.i('Haircuts (${haircuts.length}): $haircuts');
            logger.i('Time Slots (${timeSlots.length}): $timeSlots');
            logger.i('Reviews (${reviews.length}): $reviews');

            logger.i(
                'Available Days: ${availableDays?.disabledDates ?? 'No data'}');

            return BarbershopCombinedModel(
              barbershop: barbershop,
              haircuts: haircuts,
              timeslot: timeSlots,
              review: reviews,
              availableDays: availableDays,
            );
          },
        );
      }).toList();

      // Combine all barbershops data streams
      rx.CombineLatestStream(
        barbershopDataStreams,
        (List<BarbershopCombinedModel> combinedList) => combinedList,
      ).listen((result) {
        barbershopCombinedModel.assignAll(result);
        isLoading(false); // Hide loading spinner
      }, onError: (error) {
        logger.e("Error fetching combined data: $error");
        isLoading(false);
      });
    }, onError: (error) {
      logger.e("Error fetching barbershops: $error");
      isLoading(false);
    });
  }

  void fetchDocuments(String barbershopId) async {
    final documentRef = _firestore
        .collection('Barbershops')
        .doc(barbershopId)
        .collection('Business_Documents');

    try {
      final querySnapshot = await documentRef.get();
      final Map<String, String> loadedDocuments = {};

      for (var doc in querySnapshot.docs) {
        final documentData = doc.data();
        final url =
            documentData[doc.id] as String?; // Use doc.id to get the URL
        final name = doc.id; // Document ID is used as the document type

        if (url != null) {
          loadedDocuments[name] = url;
        }
      }

      documents.value = loadedDocuments;
      logger
          .d('Fetched Documents: ${loadedDocuments.toString()}'); // Debug print
    } catch (e) {
      logger.e('Error fetching documents: $e');
    }
  }

  Future<void> updateStatus(String barbershopId, String status) async {
    try {
      final barbershopDoc =
          _firestore.collection('Barbershops').doc(barbershopId);
      final barbershopData = await barbershopDoc.get();

      if (barbershopData.exists) {
        final userId = barbershopData.data()?['id'];

        // Update the status in the Barbershops collection
        await barbershopDoc.update({'status': status});

        // If a userId is present, update the status in the Users collection as well
        if (userId != null) {
          final userDoc = _firestore.collection('Users').doc(userId);
          await userDoc.update({'status': status});
        }
      } else {
        logger.d('Barbershop document does not exist.');
      }
    } catch (e) {
      logger.e('Error updating status: $e');
    }
  }

  Future<BarbershopModel?> fetchBarbershopDetails(String barbershopId) async {
    try {
      final doc =
          await _firestore.collection('Barbershops').doc(barbershopId).get();
      if (doc.exists) {
        return BarbershopModel.fromSnapshot(doc);
      } else {
        return null;
      }
    } catch (e) {
      logger.e('Error fetching barbershop details: $e');
      return null;
    }
  }
}
