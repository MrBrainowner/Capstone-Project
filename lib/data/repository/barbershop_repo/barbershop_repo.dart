import 'dart:io';

import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';

import '../../../features/auth/models/barbershop_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../auth_repo/auth_repo.dart';

class BarbershopRepository extends GetxController {
  static BarbershopRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;
  final Logger logger = Logger();

  //======================================= Save the barbershop data to firestore
  Future<void> saveBarbershopData(BarbershopModel barbershop) async {
    try {
      // list of Futures
      final futures = [
        _db.collection("Users").doc(barbershop.id).set(barbershop.toJson()),
        _db
            .collection("Barbershops")
            .doc(barbershop.id)
            .set(barbershop.toJson()),
      ];

      // Execute all Futures concurrently
      await Future.wait(futures);
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

  //======================================= Fetch barbershop details based on user ID
  Stream<BarbershopModel> barbershopDetailsStream() {
    try {
      return _db
          .collection("Barbershops")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .snapshots()
          .map((documentSnapshot) {
        if (documentSnapshot.exists) {
          return BarbershopModel.fromSnapshot(documentSnapshot);
        } else {
          return BarbershopModel.empty();
        }
      });
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

  //======================================= Update customer data in Firestore (also sync it to Users collection)
  Future<void> updateBarbershopData(BarbershopModel updateBarbershop) async {
    try {
      // Update both collections (Customers and Users) concurrently
      final futures = [
        _db
            .collection("Barbershops")
            .doc(updateBarbershop.id)
            .update(updateBarbershop.toJson()),
        _db
            .collection("Users")
            .doc(updateBarbershop.id)
            .update(updateBarbershop.toJson()),
      ];

      // Execute all updates concurrently
      await Future.wait(futures);
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

  //======================================= Update any field in specific customer collection (also sync it to Users collection)
  Future<void> updateBarbershopSingleField(Map<String, dynamic> json) async {
    try {
      // list of Futures
      final futures = [
        _db
            .collection("Users")
            .doc(AuthenticationRepository.instance.authUser?.uid)
            .update(json),
        _db
            .collection("Barbershops")
            .doc(AuthenticationRepository.instance.authUser?.uid)
            .update(json),
      ];

      // Execute all Futures concurrently
      await Future.wait(futures);
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

  //======================================= Remove customer data from Firestore
  Future<void> removeBarbershopRecord(String userId) async {
    try {
      // list of Futures
      final futures = [
        _db.collection("Users").doc(userId).delete(),
        _db.collection("Barbershops").doc(userId).delete()
      ];

      // Execute all Futures concurrently
      await Future.wait(futures);
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

  //======================================= Fetch all barbershops
  Stream<List<BarbershopModel>> fetchAllBarbershops() {
    try {
      return _db
          .collection("Barbershops")
          .where('status', isEqualTo: 'approved')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return BarbershopModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } catch (e) {
      throw 'Error fetching barbershops: $e';
    }
  }

  // Fetch a barbershop haircuts
  Stream<List<HaircutModel>> fetchBarbershopHaircuts(String barbershopId) {
    try {
      return _db
          .collection("Barbershops")
          .doc(barbershopId)
          .collection('Haircuts')
          .snapshots()
          .map((querySnapshot) {
        return querySnapshot.docs.map((doc) {
          return HaircutModel.fromSnapshot(
              doc as DocumentSnapshot<Map<String, dynamic>>);
        }).toList();
      });
    } catch (e) {
      throw 'Error fetching barbershop haircuts: $e';
    }
  }

  Future<String?> uploadImageToStorage(String barbershopId, File file) async {
    try {
      final fileName = 'profile_images/$barbershopId.jpg';
      final ref = _storage.ref().child(fileName);

      await ref.putFile(file);

      // Get the download URL
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfileImageInFirestore(
      String barbershopId, String imageUrl) async {
    try {
      await _db.collection('Barbershops').doc(barbershopId).update({
        'profile_image': imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to update profile image in Firestore');
    }
  }
}
