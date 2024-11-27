import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import '../../models/haircut_model/haircut_model.dart';
import '../auth_repo/auth_repo.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class HaircutRepository extends GetxController {
  static HaircutRepository get instance => Get.find();

  final CollectionReference haircutsCollection = FirebaseFirestore.instance
      .collection('Barbershops')
      .doc(AuthenticationRepository.instance.authUser?.uid)
      .collection('Haircuts');

  final storage = FirebaseStorage.instance;

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  String generateImageHash(File file) {
    final bytes = file.readAsBytesSync();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  Future<List<String>> uploadImageToStorage(
      List<XFile> imageFiles, String haircutId) async {
    final List<String> urls = [];

    try {
      for (var image in imageFiles) {
        final file = File(image.path);
        final imageHash = generateImageHash(file);

        final ref = storage.ref().child(
            'Barbershops/${AuthenticationRepository.instance.authUser?.uid}/haircuts/$haircutId/$imageHash');
        await ref.putFile(file);
        final url = await ref.getDownloadURL();
        urls.add(url);
      }
    } catch (e) {
      throw Exception('Failed to upload images: $e');
    }
    return urls;
  }

  Future<String> addHaircut(HaircutModel haircut) async {
    try {
      // Generate a new document reference with an auto-generated ID
      final docRef = haircutsCollection.doc();

      // Set the ID in the haircut model to match the document ID
      haircut.id = docRef.id;

      // Add the haircut data using the generated document ID
      await docRef.set(haircut.toJson());

      // Return the document ID
      return docRef.id;
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  // to make the folder name of the image the id document
  Future<void> updateHaircutImages(
      String haircutId, List<String> imageUrls) async {
    try {
      // Update the specific document with image URLs
      await haircutsCollection.doc(haircutId).update({'imageUrls': imageUrls});
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> addHaircutImages(
      String haircutId, List<String> imageUrls) async {
    try {
      // Add new image URLs to the existing document without deleting existing URLs
      await haircutsCollection.doc(haircutId).update({
        'imageUrls': FieldValue.arrayUnion(imageUrls),
      });

      logger.i('Image Files: ${imageUrls.toString()}');
      logger.i('Id: ${haircutId.toString()}');
    } on FirebaseException catch (e) {
      logger.e('FirebaseException: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('FormatException occurred');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e('PlatformException: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unknown error: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> updateHaircut(String haircutId, HaircutModel haircut) async {
    try {
      await haircutsCollection.doc(haircutId).update(haircut.toJson());
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteHaircut(String haircutId) async {
    try {
      // Fetch the haircut document to get image URLs
      final docSnapshot = await haircutsCollection.doc(haircutId).get();
      final data = docSnapshot.data() as Map<String, dynamic>?;

      if (data != null && data['imageUrls'] != null) {
        final List<String> imageUrls = List<String>.from(data['imageUrls']);

        // Delete images from Firebase Storage
        for (var url in imageUrls) {
          final ref = storage.refFromURL(url);
          await ref.delete();
        }
      }

      // Delete the haircut document from Firestore
      await haircutsCollection.doc(haircutId).delete();
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Stream<List<HaircutModel>> fetchHaircuts() {
    try {
      return haircutsCollection.snapshots().map(
        (querySnapshot) {
          return querySnapshot.docs.map((doc) {
            return HaircutModel.fromSnapshot(
                doc as DocumentSnapshot<Map<String, dynamic>>);
          }).toList();
        },
      );
    } catch (e) {
      throw 'Something went wrong. Please try again';
    }
  }

  Future<void> deleteImageAndRemoveUrl(
      String haircutId, List<String> imageUrl) async {
    try {
      // Remove image URL from Firestore
      await removeImageUrlFromFirestore(haircutId, imageUrl);

      // Delete image from Storage
      await deleteImages(imageUrl);

      logger.i('Image successfully deleted and URL removed.');
    } catch (e) {
      logger.e('Error in deleting image and removing URL: $e');
      throw 'Error in deleting image and removing URL: $e';
    }
  }

  Future<void> deleteImages(List<String> imageUrls) async {
    try {
      for (final url in imageUrls) {
        final ref = FirebaseStorage.instance.refFromURL(url);
        await ref.delete();
      }
    } on FirebaseException catch (e) {
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      throw BPlatformException(e.code).message;
    } catch (e) {
      throw 'Failed to delete images: $e';
    }
  }

  Future<void> removeImageUrlFromFirestore(
      String haircutId, List<String> imageUrl) async {
    try {
      // Remove the image URL from the Firestore document
      await haircutsCollection.doc(haircutId).update({
        'imageUrls': FieldValue.arrayRemove(imageUrl),
      });

      logger.i('Image URL removed from Firestore: $imageUrl');
    } on FirebaseException catch (e) {
      logger.e('FirebaseException: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on PlatformException catch (e) {
      logger.e('PlatformException: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Failed to remove image URL from Firestore: $e');
      throw 'Failed to remove image URL from Firestore: $e';
    }
  }
}
