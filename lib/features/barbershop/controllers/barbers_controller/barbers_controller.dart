// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:get_storage/get_storage.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:logger/logger.dart';
// import '../../../../data/models/barber_model/barber_model.dart';
// import '../../../../common/widgets/toast.dart';
// import '../../../../data/repository/barbershop_repo/barbers_repository.dart';
// import '../../../../utils/popups/full_screen_loader.dart';

// class BarberController extends GetxController {
//   static BarberController get instance => Get.find();

//   final BarbersRepository _barberRepository = Get.find();

//   final nameController = TextEditingController();
//   var imageUrl = ''.obs;

//   GlobalKey<FormState> addBarberFormKey = GlobalKey<FormState>();

//   RxList<BarberModel> barbers = <BarberModel>[].obs;
//   var isLoading = true.obs;
//   final String schedulesKey = 'schedules';
//   Rx<File?> imageFile = Rx<File?>(null);

//   final logger = Logger(
//     printer: PrettyPrinter(),
//   );

//   @override
//   void onInit() {
//     super.onInit();
//   }

//   void resetForm() {
//     nameController.clear();
//     imageFile.value = null;
//   }

//   //================================= adding barber
//   Future<void> addBarber() async {
//     FullScreenLoader.openLoadingDialog(
//         'Adding Barber...', 'assets/images/animation.json');

//     if (addBarberFormKey.currentState?.validate() ?? false) {
//       // Check if an image is selected
//       if (imageFile.value == null) {
//         // Show a warning if no image is selected
//         ToastNotif(message: 'Please upload an image', title: 'Error')
//             .showErrorNotif(Get.context!);
//         return;
//       }

//       // Create a BarberModel with an empty profileImage initially
//       final newBarber = BarberModel(
//         fullName: nameController.text.trim(),
//         profileImage: '', // Placeholder, will be updated later
//         workingHours: [], // Initialize with empty list
//         createdAt: DateTime.now(),
//       );

//       try {
//         // Step 1: Add barber to Firestore to get the document ID
//         final barberId = await _barberRepository.addBarber(newBarber);

//         // Step 2: Upload the image using the document ID as the folder name
//         final imageUrl = await _barberRepository.uploadImageToFirebase(
//           XFile(imageFile.value!.path),
//           barberId,
//         );

//         // Step 3: Update the barber document with the image URL
//         await _barberRepository.updateBarberImage(barberId, imageUrl);

//         // Optionally, provide feedback or navigate here
//         ToastNotif(message: 'Barber added successfuly', title: 'Barber Added')
//             .showSuccessNotif(Get.context!);
//         resetForm();
//         Get.back();
//       } catch (e) {
//         // Handle any errors
//         ToastNotif(message: 'Error adding barbers', title: 'Error')
//             .showErrorNotif(Get.context!);
//       } finally {
//         FullScreenLoader.stopLoading();
//       }
//     }
//   }

//   //==================================================================== fetching barbers
//   // Listen to the stream for new barbers
//   void listenToBarbersStream() {
//     isLoading(true); // Set loading to true while fetching
//     _barberRepository.fetchBarbers().listen(
//       (newBarbers) {
//         // Update the list of barbers
//         barbers.assignAll(newBarbers);
//         isLoading(false);
//       },
//       onError: (error) {
//         // Handle error if any occurs in the stream
//         ToastNotif(message: 'Error fetching barbers: $error', title: 'Error')
//             .showErrorNotif(Get.context!);
//       },
//       onDone: () {
//         isLoading(false); // Stop loading when the stream is done
//       },
//     );
//   }

//   //===================================================================== Controller function to update barber details including image
//   Future<void> updateBarber({
//     required String docId,
//     required BarberModel updatedBarber,
//   }) async {
//     FullScreenLoader.openLoadingDialog(
//         'Updating Barber...', 'assets/images/animation.json');

//     if (addBarberFormKey.currentState?.validate() ?? false) {
//       // Check if an image is selected
//       if (imageFile.value == null) {
//         // Show a warning if no image is selected
//         ToastNotif(message: 'Please upload an image', title: 'Error')
//             .showErrorNotif(Get.context!);
//         return;
//       }
//       try {
//         XFile? newImageFile;

//         // Convert Rx<File?> to XFile if a new image is selected
//         if (imageFile.value != null) {
//           newImageFile = XFile(imageFile.value!.path);
//         }

//         // Call the repository update function
//         await _barberRepository.updateBarber(
//           name: nameController.text,
//           docId: docId,
//           updatedBarber: updatedBarber,
//           newImageFile: newImageFile,
//         );
//         ToastNotif(
//                 message: 'Barber updated successfuly', title: 'Barber Updated')
//             .showSuccessNotif(Get.context!);
//         resetForm();
//         Get.back();
//       } catch (e) {
//         ToastNotif(message: 'Error updating barber', title: 'Error')
//             .showErrorNotif(Get.context!);
//       } finally {
//         FullScreenLoader.stopLoading();
//       }
//     }
//   }

// //=====================================================================deleting barber
//   Future<void> deleteBarber(String docId) async {
//     FullScreenLoader.openLoadingDialog(
//         'Updating Barber...', 'assets/images/animation.json');
//     try {
//       // Call the repository method to delete the barber
//       await _barberRepository.deleteBarber(docId: docId);
//       ToastNotif(message: 'Barber deleted successfuly', title: 'Barber Updated')
//           .showSuccessNotif(Get.context!);
//       resetForm();
//     } catch (e) {
//       ToastNotif(message: 'Error deleting barber', title: 'Error')
//           .showErrorNotif(Get.context!);
//     } finally {
//       FullScreenLoader.stopLoading();
//     }
//   }
// }
