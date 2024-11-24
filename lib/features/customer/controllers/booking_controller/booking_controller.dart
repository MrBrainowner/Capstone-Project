import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/customer_repos/booking_repo.dart';
import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:get/get.dart';
import '../../../../data/models/booking_model/booking_model.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../utils/popups/full_screen_loader.dart';
// Import your BookingModel

class CustomerBookingController extends GetxController {
  static CustomerBookingController get instance => Get.find();

  final _repo = Get.put(BookingRepo());
  final controller = Get.put(GetHaircutsAndBarbershopsController());
  final authId = Get.put(AuthenticationRepository.instance.authUser?.uid);

  Rx<HaircutModel?> selectedHaircut = HaircutModel.empty().obs;
  Rx<TimeSlotModel> selectedTimeSlot = TimeSlotModel.empty().obs;
  Rx<BarbershopModel> chosenBarbershopId = BarbershopModel.empty().obs;
  var selectedDate = Rx<DateTime?>(null);

  Rx<HaircutModel?> toggleHaircut = HaircutModel.empty().obs;
  Rx<TimeSlotModel?> toggleTimeSlot = TimeSlotModel.empty().obs;

  // Add a new booking
  Future<void> addBooking() async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog(
          'Creating booking...', 'assets/images/animation.json');

      final booking = BookingModel(
          barberShopId: chosenBarbershopId.value.id,
          customerId: authId.toString(),
          haircutId: selectedHaircut.value?.id ?? 'None',
          date: controller.formatDate(
              selectedDate.value ?? controller.getNextAvailableDate()),
          timeSlotId: selectedTimeSlot.value.id.toString(),
          status: 'pending',
          createdAt: DateTime.now(),
          id: '',
          barberId: '');

      await _repo.addBooking(booking);
    } catch (e) {
      FullScreenLoader.stopLoading();
      ToastNotif(message: e.toString(), title: 'Booking Failed')
          .showErrorNotif(Get.context!);
    } finally {
      ToastNotif(message: 'Booking successful', title: 'Succesful')
          .showSuccessNotif(Get.context!);
      FullScreenLoader.stopLoading();
    }
  }

  // Update an existing booking (e.g., reschedule)
  Future<void> updateBooking(String bookingId, BookingModel booking) async {
    try {} catch (e) {
      throw ('Error updating booking: $e');
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(String bookingId) async {
    try {} catch (e) {
      throw ('Error canceling booking: $e');
    }
  }

  // Get a specific booking by ID
  Future<BookingModel?> getBookingById(String bookingId) async {
    return null;
  }
}

  // Get all bookings for a specific customer
  // Future<List<BookingModel>> getBookingsForCustomer(String customerId) async {
  //   try {
  //     QuerySnapshot querySnapshot = await bookingsCollection
  //         .where('customer_id', isEqualTo: customerId)
  //         .get();
  //     return querySnapshot.docs
  //         .map((doc) => BookingModel.fromSnapshot(
  //             doc as DocumentSnapshot<Map<String, dynamic>>))
  //         .toList();
  //   } catch (e) {
  //     throw ('Error fetching bookings: $e');
  //   }
  // }

  // Get all bookings for a specific date
  // Future<List<BookingModel>> getBookingsForDate(String date) async {
  //   try {
  //     QuerySnapshot querySnapshot =
  //         await bookingsCollection.where('date', isEqualTo: date).get();
  //     return querySnapshot.docs
  //         .map((doc) => BookingModel.fromSnapshot(
  //             doc as DocumentSnapshot<Map<String, dynamic>>))
  //         .toList();
  //   } catch (e) {
  //     throw ('Error fetching bookings: $e');
  //   }
  // }

