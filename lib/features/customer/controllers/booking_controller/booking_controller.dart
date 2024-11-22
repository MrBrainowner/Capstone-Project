import 'package:barbermate/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate/data/repository/customer_repos/booking_repo.dart';
import 'package:get/get.dart';
import '../../../../data/models/booking_model/booking_model.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
// Import your BookingModel

class CustomerBookingController extends GetxController {
  static CustomerBookingController get instance => Get.find();

  final _repo = Get.put(BookingRepo());

  Rx<HaircutModel?> selectedHaircut = HaircutModel.empty().obs;
  Rx<TimeSlotModel?> selectedTimeSlot = TimeSlotModel.empty().obs;
  Rx<DateTime?> selectedDate = Rx<DateTime?>(null);

  // Add a new booking
  Future<void> addBooking(BookingModel booking, TimeSlotModel timeSlot,
      String? haicutId, DateTime date, String barbershopId) async {
    try {
      await _repo.addBooking(booking, timeSlot, haicutId, date, barbershopId);
    } catch (e) {
      throw ('Error adding booking: $e');
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

