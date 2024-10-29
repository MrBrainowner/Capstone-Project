import 'package:cloud_firestore/cloud_firestore.dart';
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
  Future<BarbershopModel> fetchBarbershopDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Barbershops")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return BarbershopModel.fromSnapshot(documentSnapshot);
      } else {
        return BarbershopModel.empty();
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

  //======================================= Update customer data in Firestore (also sync it to Users collection)
  Future<void> updateBarbershopData(BarbershopModel updateCustomer) async {
    try {
      // Update both collections (Customers and Users) concurrently
      final futures = [
        _db
            .collection("Barbershops")
            .doc(updateCustomer.id)
            .update(updateCustomer.toJson()),
        _db
            .collection("Users")
            .doc(updateCustomer.id)
            .update(updateCustomer.toJson()),
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
  Future<List<BarbershopModel>> fetchAllBarbershops() async {
    try {
      final querySnapshot = await _db
          .collection("Barbershops")
          .where('status', isEqualTo: 'approved')
          .get();
      return querySnapshot.docs.map((doc) {
        return BarbershopModel.fromSnapshot(
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

  //======================================= Upload any image
}
