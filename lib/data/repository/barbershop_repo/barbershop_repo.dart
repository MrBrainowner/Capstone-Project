import 'dart:io';

import 'package:barbermate/data/models/fetch_with_subcollection/all_barbershops_information.dart';
import 'package:barbermate/data/models/haircut_model/haircut_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:uuid/uuid.dart';

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

  String generateImageHash(File file) {
    final bytes = file.readAsBytesSync();
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

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

  // Fetch all barbershops with their haircuts (stream-based)
  Stream<List<BarbershopWithHaircuts>> fetchAllBarbershopsWithHaircuts() {
    return fetchAllBarbershops().asyncMap((barbershopList) async {
      // Create a list to hold the combined barbershop and haircuts data
      List<BarbershopWithHaircuts> barbershopWithHaircutsList = [];

      for (var barbershop in barbershopList) {
        print('Fetching haircuts for barbershop: ${barbershop.firstName}');

        // Fetch the stream of haircuts for each barbershop
        var haircutsStream = fetchBarbershopHaircuts(barbershop.id);

        await for (var haircuts in haircutsStream) {
          print(
              'Fetched ${haircuts.length} haircuts for ${barbershop.address}');

          // Combine the barbershop and its current haircuts into one object
          barbershopWithHaircutsList.add(BarbershopWithHaircuts(
            barbershop: barbershop,
            haircuts: haircuts,
          ));
        }
      }

      if (barbershopWithHaircutsList.isEmpty) {
        print('No barbershop data or haircuts found');
      }

      return barbershopWithHaircutsList;
    });
  }

  Future<String?> uploadImageToStorage(XFile file, String type) async {
    try {
      // Generate a unique file name using UUID
      const uuid = Uuid();
      final uniqueFileName =
          '${uuid.v4()}_${file.name}'; // Unique name + original file name

      final ref = _storage.ref().child(
          'Barbershops/${AuthenticationRepository.instance.authUser?.uid}/Information_images/$type/$uniqueFileName');

      // Upload the file to Firebase Storage
      await ref.putFile(File(file.path));

      // Get the download URL
      final downloadUrl = await ref.getDownloadURL();
      return downloadUrl;
    } catch (e) {
      return null;
    }
  }

  Future<void> updateProfileImageInFirestore(
      String barbershopId, String imageUrl, String type) async {
    try {
      switch (type) {
        case 'Profile':
          await _db.collection('Barbershops').doc(barbershopId).update({
            'profile_image': imageUrl,
          });
          break;
        case 'Banner':
          await _db.collection('Barbershops').doc(barbershopId).update({
            'barbershop_banner_image': imageUrl,
          });
          break;
        case 'Logo':
          await _db.collection('Barbershops').doc(barbershopId).update({
            'barbershop_profile_image': imageUrl,
          });
      }
    } catch (e) {
      throw Exception('Failed to update profile image in Firestore');
    }
  }

  Future<void> makeBarbershopExist() async {
    try {
      final futures = [
        _db
            .collection('Users')
            .doc(AuthenticationRepository.instance.authUser?.uid)
            .update({'existing': true}),
        _db
            .collection('Barbershops')
            .doc(AuthenticationRepository.instance.authUser?.uid)
            .update({'existing': true}),
      ];

      // Execute all Futures concurrently
      await Future.wait(futures);
    } catch (e) {
      throw Exception('Failed to update barbershop Firestore: $e');
    }
  }
}
