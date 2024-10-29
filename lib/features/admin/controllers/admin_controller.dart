import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../auth/models/barbershop_model.dart';

class AdminController extends GetxController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final Logger logger = Logger();

  var barbershops = <BarbershopModel>[].obs;
  var documents = <String, String>{}.obs;

  @override
  void onInit() {
    super.onInit();
    fetchBarbershops();
  }

  void fetchBarbershops() async {
    try {
      final snapshot = await _firestore.collection('Barbershops').get();
      final barbershopDocs = snapshot.docs;
      final List<BarbershopModel> loadedBarbershops = [];

      for (var doc in barbershopDocs) {
        final barbershop = BarbershopModel.fromSnapshot(doc);
        loadedBarbershops.add(barbershop);
      }

      barbershops.value = loadedBarbershops;
    } catch (e) {
      logger.e('Error fetching barbershops: $e');
    }
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

        fetchBarbershops(); // Refresh the list
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
