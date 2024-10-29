import 'dart:io';

import 'package:barbermate/data/models/barber_model/barber_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class BarbersRepository extends GetxController {
  static BarbersRepository get instance => Get.find();

  final CollectionReference barbersCollection = FirebaseFirestore.instance
      .collection('Barbershops')
      .doc(AuthenticationRepository.instance.authUser?.uid)
      .collection('Barbers');

  final FirebaseStorage storage = FirebaseStorage.instance;

  final logger = Logger(
    printer: PrettyPrinter(),
  );

  //====================================================================== adding barbers - getting id to name to the folder in storage
  Future<String> uploadImageToFirebase(XFile file, String barberId) async {
    final storageRef = FirebaseStorage.instance.ref();

    // Generate a unique file name using UUID
    const uuid = Uuid();
    final uniqueFileName =
        '${uuid.v4()}_${file.name}'; // Unique name + original file name

    final fileRef = storageRef.child(
        'Barbershops/${AuthenticationRepository.instance.authUser?.uid}/barbers/$barberId/images/$uniqueFileName');

    try {
      // Upload the file to Firebase Storage
      await fileRef.putFile(File(file.path));

      // Get the download URL of the uploaded file
      final downloadURL = await fileRef.getDownloadURL();
      return downloadURL;
    } catch (e) {
      throw 'Error uploading image: $e';
    }
  }

  Future<String> addBarber(BarberModel barber) async {
    try {
      // Generate a new document reference with an auto-generated ID
      final docRef = barbersCollection.doc();

      // Set the ID in the haircut model to match the document ID
      barber.id = docRef.id;

      // Add the haircut data using the generated document ID
      await docRef.set(barber.toJson());

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

  Future<void> updateBarberImage(String docId, String imageUrl) async {
    try {
      await barbersCollection.doc(docId).update({
        'profileImage': imageUrl,
      });
    } catch (e) {
      throw 'Error updating barber image: $e';
    }
  }

  //====================================================================== fetching barbers

  Future<List<BarberModel>> fetchBarbers() async {
    try {
      final querySnapshot = await barbersCollection.get();
      return querySnapshot.docs.map((doc) {
        return BarberModel.fromSnapshot(
            doc as DocumentSnapshot<Map<String, dynamic>>);
      }).toList();
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

  //====================================================================== update barbers
  // Function to delete image from Firebase Storage
  Future<void> deleteImageFromFirebase(String imageUrl) async {
    try {
      final storageRef = FirebaseStorage.instance.refFromURL(imageUrl);
      await storageRef.delete();
    } catch (e) {
      throw 'Error deleting image: $e';
    }
  }

  //================================================Function to update barber details, including replacing the profile image
  Future<void> updateBarber({
    required String docId,
    required BarberModel updatedBarber,
    required String name, // Add a required name parameter
    XFile? newImageFile,
  }) async {
    try {
      // Fetch the current barber details from Firestore
      final barberDoc = await barbersCollection.doc(docId).get();

      if (barberDoc.exists) {
        final BarberModel currentBarber = BarberModel.fromSnapshot(
            barberDoc as DocumentSnapshot<Map<String, dynamic>>);

        // If a new image is provided, handle the image replacement
        if (newImageFile != null) {
          // Delete the old image from Firebase Storage
          if (currentBarber.profileImage.isNotEmpty) {
            await deleteImageFromFirebase(currentBarber.profileImage);
          }

          // Upload the new image to Firebase Storage
          final newImageUrl = await uploadImageToFirebase(newImageFile, docId);

          // Update the barber model with the new image URL
          updatedBarber.profileImage = newImageUrl;
        } else {
          // Keep the old image URL if no new image is uploaded
          updatedBarber.profileImage = currentBarber.profileImage;
        }

        // Update the name in the barber model
        updatedBarber.fullName = name;

        // Update the barber data in Firestore
        await barbersCollection.doc(docId).update(updatedBarber.toJson());
      } else {
        logger.d('Barber not found');
      }
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

//=======================================================delete barber

  // Function to fetch barber details and delete the barber
  Future<void> deleteBarber({
    required String docId,
  }) async {
    try {
      // Fetch the current barber details to get the image URL
      final barberDoc = await barbersCollection.doc(docId).get();

      if (barberDoc.exists) {
        final BarberModel barber = BarberModel.fromSnapshot(
            barberDoc as DocumentSnapshot<Map<String, dynamic>>);

        // Delete the image from Firebase Storage
        if (barber.profileImage.isNotEmpty) {
          await deleteImageFromFirebase(barber.profileImage);
        }

        // Delete the barber document from Firestore
        await barbersCollection.doc(docId).delete();
      } else {
        logger.d('Barber not found');
      }
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
}
