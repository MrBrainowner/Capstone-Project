import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../features/auth/models/customer_model.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';
import '../auth_repo/auth_repo.dart';
import 'get_directions_repository.dart';

class CustomerRepository extends GetxController {
  static CustomerRepository get instance => Get.find();

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final _storage = FirebaseStorage.instance;

  @override
  void onInit() async {
    super.onInit();
    GetDirectionsRepository();
  }

  //======================================= Save the customer data to firestore
  Future<void> saveCustomerData(CustomerModel customer) async {
    try {
      // list of Futures
      final futures = [
        _db.collection("Users").doc(customer.id).set(customer.toJson()),
        _db.collection("Customers").doc(customer.id).set(customer.toJson()),
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

  //======================================= Fetch customer details based on user ID
  Future<CustomerModel> fetchCustomerDetails() async {
    try {
      final documentSnapshot = await _db
          .collection("Customers")
          .doc(AuthenticationRepository.instance.authUser?.uid)
          .get();
      if (documentSnapshot.exists) {
        return CustomerModel.fromSnapshot(documentSnapshot);
      } else {
        return CustomerModel.empty();
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
  Future<void> updateCustomerData(CustomerModel updateCustomer) async {
    try {
      // Update both collections (Customers and Users) concurrently
      final futures = [
        _db
            .collection("Customers")
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
  Future<void> updateCustomerSingleField(Map<String, dynamic> json) async {
    try {
      // list of Futures
      final futures = [
        _db
            .collection("Users")
            .doc(AuthenticationRepository.instance.authUser?.uid)
            .update(json),
        _db
            .collection("Customers")
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
  Future<void> removeCustomerRecord(String userId) async {
    try {
      // list of Futures
      final futures = [
        _db.collection("Users").doc(userId).delete(),
        _db.collection("Customers").doc(userId).delete()
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

  //======================================= Upload any image

  Future<String?> fetchProfileImage(String customerId) async {
    try {
      final doc = await _db.collection('Customers').doc(customerId).get();
      if (doc.exists) {
        return doc.data()?['profile_image'];
      }
    } catch (e) {
      return null;
    }
    return null;
  }

  Future<String?> uploadImageToStorage(String customerId, File file) async {
    try {
      final fileName = 'profile_images/$customerId.jpg';
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
      String customerId, String imageUrl) async {
    try {
      await _db.collection('Customers').doc(customerId).update({
        'profile_image': imageUrl,
      });
    } catch (e) {
      throw Exception('Failed to update profile image in Firestore');
    }
  }
}
