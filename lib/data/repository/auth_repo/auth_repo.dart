import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:logger/logger.dart';

import '../../../features/admin/views/admin_view.dart';
import '../../../features/auth/views/email_verification/email_verification.dart';
import '../../../features/auth/views/onboarding/onboarding.dart';
import '../../../features/auth/views/sign_in/sign_in_page.dart';
import '../../../features/barbershop/views/dashboard/dashboard.dart';
import '../../../features/customer/views/dashboard/dashboard.dart';
import '../../../utils/exceptions/firebase_auth_exeptions.dart';
import '../../../utils/exceptions/firebase_exceptions.dart';
import '../../../utils/exceptions/format_exceptions.dart';
import '../../../utils/exceptions/platform_exceptions.dart';

class AuthenticationRepository extends GetxController {
  static AuthenticationRepository get instance => Get.find();
  final Logger logger = Logger();

  //======================================= Variables
  final deviceStorage = GetStorage();
  final _auth = FirebaseAuth.instance;
  final _firestore = FirebaseFirestore.instance; // Firestore instance

  User? get authUser => _auth.currentUser;

  //======================================= On App Launch
  @override
  void onReady() {
    FlutterNativeSplash.remove();
    pageRedirect();
  }

  //============================================================================== Email and Password

  //======================================= Function Redirect Page
  void pageRedirect() async {
    final user = _auth.currentUser;
    if (user != null) {
      if (user.emailVerified) {
        // Get the user's role from Firestore
        DocumentSnapshot userDoc =
            await _firestore.collection('Users').doc(user.uid).get();
        String role = userDoc['role'];

        if (role == 'customer') {
          //Remove Loader
          // FullScreenLoader.stopLoading();
          Get.offAll(() => const CustomerDashboard());
        } else if (role == 'barbershop') {
          //Remove Loader
          // FullScreenLoader.stopLoading();
          Get.offAll(() => const BarbershopDashboard());
        } else if (role == 'admin') {
          Get.offAll(() => const AdminPanel());
        }
      } else {
        Get.offAll(() => EmailVerification(email: user.email));
      }
    } else {
      // Local Storage
      deviceStorage.writeIfNull('isFirstTime', true);
      deviceStorage.read('isFirstTime') != true
          ? Get.offAll(() => const SignInPage())
          : Get.offAll(() => const Onboarding());
    }
  }

  //======================================= Sign In
  Future<UserCredential> loginWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.signInWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      logger
          .e('Firebase Auth Exception during login: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e('Firebase Exception during login: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during login');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e('Platform Exception during login: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during login: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Sign Up
  Future<UserCredential> registerWithEmailAndPassword(
      String email, String password) async {
    try {
      return await _auth.createUserWithEmailAndPassword(
          email: email, password: password);
    } on FirebaseAuthException catch (e) {
      logger.e(
          'Firebase Auth Exception during registration: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e(
          'Firebase Exception during registration: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during registration');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during registration: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during registration: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Email Verification
  Future<void> sendEmailVerification() async {
    try {
      await _auth.currentUser?.sendEmailVerification();
    } on FirebaseAuthException catch (e) {
      logger.e(
          'Firebase Auth Exception during email verification: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e(
          'Firebase Exception during email verification: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during email verification');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during email verification: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during email verification: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Forget Password
  Future<void> sendPasswordResetEmail(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException catch (e) {
      logger.e(
          'Firebase Auth Exception during password reset: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e(
          'Firebase Exception during password reset: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during password reset');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e(
          'Platform Exception during password reset: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during password reset: $e');
      throw 'Something went wrong. Please try again';
    }
  }

  //======================================= Re Authenticate User

  //============================================================================== Social Sign In

  //======================================= Goolgle

  //======================================= Facebook

  //============================================================================== Other

  //======================================= Log Out
  Future<void> logOut() async {
    try {
      await FirebaseAuth.instance.signOut();
      Get.offAll(() => const SignInPage());
    } on FirebaseAuthException catch (e) {
      logger
          .e('Firebase Auth Exception during logout: ${e.code} - ${e.message}');
      throw BFirebaseAuthException(e.code).message;
    } on FirebaseException catch (e) {
      logger.e('Firebase Exception during logout: ${e.code} - ${e.message}');
      throw BFirebaseException(e.code).message;
    } on FormatException catch (_) {
      logger.e('Format Exception: Invalid format during logout');
      throw BFormatException('').message;
    } on PlatformException catch (e) {
      logger.e('Platform Exception during logout: ${e.code} - ${e.message}');
      throw BPlatformException(e.code).message;
    } catch (e) {
      logger.e('Unexpected Error during logout: $e');
      throw 'Something went wrong. Please try again';
    }
  }
}
