import 'package:barbermate/common/widgets/toast.dart';
import 'package:barbermate/data/models/timeslot_model/timeslot_model.dart';
import 'package:barbermate/data/repository/auth_repo/auth_repo.dart';
import 'package:barbermate/data/repository/booking_repo/booking_repo.dart';
import 'package:barbermate/features/auth/models/barbershop_model.dart';
import 'package:barbermate/features/customer/controllers/customer_controller/customer_controller.dart';
import 'package:barbermate/features/customer/controllers/get_haircuts_and_barbershops_controller/get_haircuts_and_barbershops_controller.dart';
import 'package:barbermate/features/customer/controllers/notification_controller/notification_controller.dart';
import 'package:get/get.dart';
import '../../../../data/models/booking_model/booking_model.dart';
import '../../../../data/models/haircut_model/haircut_model.dart';
import '../../../../utils/popups/full_screen_loader.dart';
// Import your BookingModel

class CustomerBookingController extends GetxController {
  static CustomerBookingController get instance => Get.find();

  final _repo = Get.put(BookingRepo());
  final notifs = Get.put(CustomerNotificationController());
  final controller = Get.put(GetHaircutsAndBarbershopsController());
  final authId = Get.put(AuthenticationRepository.instance.authUser?.uid);
  final customer = Get.put(CustomerController.instance.customer);
  final notificationController = Get.put(CustomerNotificationController());

  Rx<HaircutModel> selectedHaircut = HaircutModel.empty().obs;
  Rx<TimeSlotModel> selectedTimeSlot = TimeSlotModel.empty().obs;
  Rx<BarbershopModel> chosenBarbershop = BarbershopModel.empty().obs;
  var selectedDate = Rx<DateTime?>(null);

  Rx<HaircutModel?> toggleHaircut = HaircutModel.empty().obs;
  Rx<TimeSlotModel?> toggleTimeSlot = TimeSlotModel.empty().obs;

  // Create a reactive RxList for pending bookings
  RxList<BookingModel> pendingBookings = <BookingModel>[].obs;
  RxList<BookingModel> confirmedBookings = <BookingModel>[].obs;
  RxList<BookingModel> doneBookings = <BookingModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    fetchBookings();
  }

// Listen to changes in bookings and filter them for 'pending' status
  void filterPendingBookings() {
    pendingBookings.value =
        bookings.where((booking) => booking.status == 'pending').toList();
  }

  void filterConfirmedBookings() {
    confirmedBookings.value =
        bookings.where((booking) => booking.status == 'confirmed').toList();
  }

  void filterDoneBookings() {
    doneBookings.value = bookings
        .where((booking) =>
            booking.status == 'done' || booking.status == 'canceled')
        .toList();
  }

  Future<void> refreshData() async {
    await controller.fetchBarbershopTimeSlots(chosenBarbershop.value.id);
    selectedTimeSlot.value = TimeSlotModel.empty();
  }

  RxList<BookingModel> bookings = <BookingModel>[].obs;

  void clearBookingData() {
    chosenBarbershop.value = BarbershopModel.empty();
    selectedHaircut.value = HaircutModel.empty();
    selectedTimeSlot.value = TimeSlotModel.empty();
    selectedDate.value = null;
  }

  // Add a new booking
  Future<void> addBooking() async {
    try {
      //Start Loading
      FullScreenLoader.openLoadingDialog(
          'Please wait...', 'assets/images/animation.json');

      final booking = BookingModel(
          haircutName: selectedHaircut.value.name,
          haircutPrice: selectedHaircut.value.price,
          barberShopId: chosenBarbershop.value.id,
          customerId: authId.toString(),
          haircutId: selectedHaircut.value.id ?? 'None',
          date: controller.formatDate(
              selectedDate.value ?? controller.getNextAvailableDate()),
          timeSlotId: selectedTimeSlot.value.id.toString(),
          status: 'pending',
          createdAt: DateTime.now(),
          id: '',
          barberId: '',
          customerName:
              '${customer.value.firstName} ${customer.value.lastName}',
          barbershopName: chosenBarbershop.value.barbershopName,
          customerPhoneNo: customer.value.phoneNo,
          timeSlot: selectedTimeSlot.value.schedule);

      await _repo.addBooking(booking, chosenBarbershop.value, customer.value);
      await controller.fetchBarbershopTimeSlots(chosenBarbershop.value.id);
      clearBookingData();
      await notifs.fetchNotifications();
      ToastNotif(message: 'Booking successful', title: 'Succesful')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      FullScreenLoader.stopLoading();
      ToastNotif(message: e.toString(), title: 'Booking Failed')
          .showErrorNotif(Get.context!);
    } finally {
      FullScreenLoader.stopLoading();
    }
  }

  // Cancel a booking
  Future<void> cancelBooking(BookingModel booking) async {
    try {
      await _repo.cancelBooking(booking);

      await notificationController.sendNotifWhenBookingUpdatedCustomers(
          booking,
          'booking',
          'Appointment Canceled',
          '${booking.customerName} canceled this appointment',
          'notRead');
      await fetchBookings();
      ToastNotif(message: 'Appointment canceled', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: 'Error canceling appoiment $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // Get a specific booking by ID
  Future<void> fetchBookings() async {
    try {
      final data = await _repo.fetchBookingsCustomer();
      bookings.value = data;
      filterPendingBookings();
      filterConfirmedBookings();
      filterDoneBookings();
    } catch (e) {
      ToastNotif(message: 'Error fetching bookings $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
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

