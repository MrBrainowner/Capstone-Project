import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:path/path.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:logger/logger.dart';

import '../../models/barbershops_verfication_model/document_model.dart';

class VerificationRepo {
  static VerificationRepo get instance => VerificationRepo();

  final Logger logger = Logger();

  final _firestore = FirebaseFirestore.instance;

  /// Uploads a file to Firebase Storage and adds the document details to Firestore
  Future<void> uploadFile(File file, String documentType) async {
    const int maxRetries = 3;
    int attempt = 0;

    while (attempt < maxRetries) {
      try {
        final fileName = basename(file.path);
        final barbershopId =
            AuthenticationRepository.instance.authUser?.uid ?? '';

        if (barbershopId.isEmpty) {
          throw Exception('No authenticated user found.');
        }

        // Upload the file to Firebase Storage
        final storageRef = FirebaseStorage.instance
            .ref('Barbershops/$barbershopId/documents/$documentType/$fileName');
        final uploadTask = storageRef.putFile(file);

        // Monitor the upload progress
        uploadTask.snapshotEvents.listen((event) {
          final progress = (event.bytesTransferred / event.totalBytes) * 100;
          logger.i('Upload progress: ${progress.toStringAsFixed(2)}%');
        });

        await uploadTask.whenComplete(() => null);
        final downloadUrl = await storageRef.getDownloadURL();

        // Add the document to Firestore under the barbershop application
        final applicationRef = _firestore
            .collection('Barbershops')
            .doc(barbershopId)
            .collection('Documents')
            .doc(barbershopId);

        final snapshot = await applicationRef.get();

        if (!snapshot.exists) {
          // If the application doesn't exist, create a new one
          final application = BarbershopApplicationModel(
            barbershopId: barbershopId,
            documents: [
              BarbershopDocumentModel(
                documentType: documentType,
                documentURL: downloadUrl,
              ),
            ],
            createdAt: DateTime.now(),
          );

          await applicationRef.set(application.toJson());
        } else {
          // If the application exists, update the document list
          final existingApplication =
              BarbershopApplicationModel.fromSnapshot(snapshot);

          final updatedDocuments = [
            ...existingApplication.documents,
            BarbershopDocumentModel(
              documentType: documentType,
              documentURL: downloadUrl,
            ),
          ];

          await applicationRef.update({
            'documents': updatedDocuments.map((doc) => doc.toJson()).toList(),
          });
        }

        logger.i('Document $documentType uploaded and saved successfully.');
        return; // Exit loop on success
      } catch (e) {
        attempt++;
        logger.e('Error uploading file (Attempt $attempt): $e');
        if (attempt >= maxRetries) {
          throw Exception('Failed to upload file after $maxRetries attempts.');
        }
      }
    }
  }

  /// Fetches all documents for the current barbershop
  Future<List<BarbershopDocumentModel>> fetchDocuments() async {
    final barbershopId = AuthenticationRepository.instance.authUser?.uid ?? '';

    if (barbershopId.isEmpty) {
      throw Exception('No authenticated user found.');
    }

    final applicationRef =
        _firestore.collection('BarbershopApplications').doc(barbershopId);

    final snapshot = await applicationRef.get();

    if (!snapshot.exists) {
      return [];
    }

    final application = BarbershopApplicationModel.fromSnapshot(snapshot);
    return application.documents;
  }

  /// Updates the status and feedback of a specific document
  Future<void> updateDocumentStatus(
      String barbershopId, String documentType, String status,
      {String? feedback}) async {
    final applicationRef =
        _firestore.collection('BarbershopApplications').doc(barbershopId);

    final snapshot = await applicationRef.get();

    if (!snapshot.exists) {
      throw Exception('Barbershop application not found.');
    }

    final application = BarbershopApplicationModel.fromSnapshot(snapshot);

    final updatedDocuments = application.documents.map((doc) {
      if (doc.documentType == documentType) {
        return doc.copyWith(
          status: status,
          feedback: feedback,
        );
      }
      return doc;
    }).toList();

    await applicationRef.update({
      'documents': updatedDocuments.map((doc) => doc.toJson()).toList(),
    });
  }
}
