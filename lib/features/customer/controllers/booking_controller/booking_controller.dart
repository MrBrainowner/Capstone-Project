import 'dart:async';
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

class CustomerBookingController extends GetxController {
  static CustomerBookingController get instance => Get.find();

  final BookingRepo _repo = Get.find();
  final authId = Get.put(AuthenticationRepository.instance.authUser?.uid);

  // final notifs = Get.put(CustomerNotificationController());
  // final controller = Get.put(GetHaircutsAndBarbershopsController());
  // final notificationController = Get.put(CustomerNotificationController());
  final GetHaircutsAndBarbershopsController controller = Get.find();
  final CustomerNotificationController notificationController = Get.find();
  final CustomerController customer = Get.find();

  Rx<HaircutModel> selectedHaircut = HaircutModel.empty().obs;
  Rx<TimeSlotModel> selectedTimeSlot = TimeSlotModel.empty().obs;
  Rx<BarbershopModel> chosenBarbershop = BarbershopModel.empty().obs;
  var selectedDate = Rx<DateTime?>(null);

  Rx<HaircutModel?> toggleHaircut = HaircutModel.empty().obs;
  Rx<TimeSlotModel?> toggleTimeSlot = TimeSlotModel.empty().obs;
  RxBool isLoading = false.obs;

  // Create a reactive RxList for pending bookings
  RxList<BookingModel> pendingAndConfirmedBookings = <BookingModel>[].obs;
  RxList<BookingModel> doneBookings = <BookingModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    listenToBookingsStream(); // Start listening when the controller is initialized
  }

  Future<void> refreshData() async {
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
          barbershopToken: chosenBarbershop.value.fcmToken.toString(),
          customerToken: customer.customer.value.fcmToken.toString(),
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
              '${customer.customer.value.firstName} ${customer.customer.value.lastName}',
          barbershopName: chosenBarbershop.value.barbershopName,
          customerPhoneNo: customer.customer.value.phoneNo,
          timeSlot: selectedTimeSlot.value.schedule,
          barbershopProfileImageUrl:
              chosenBarbershop.value.barbershopProfileImage,
          customerProfileImageUrl: customer.customer.value.profileImage);

      await _repo.addBooking(
          booking, chosenBarbershop.value, customer.customer.value);

      clearBookingData();
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
          '${booking.customerName} canceled an appointment',
          'notRead');

      ToastNotif(message: 'Appointment canceled', title: 'Success')
          .showSuccessNotif(Get.context!);
    } catch (e) {
      ToastNotif(message: 'Error canceling appoiment $e', title: 'Error')
          .showErrorNotif(Get.context!);
    }
  }

  // Listen to the stream for new bookings
  void listenToBookingsStream() {
    isLoading.value = true;
    // Fetch bookings as a stream
    _repo.fetchBookingsCustomer().listen(
      (newBookings) {
        // If there is new data, update the bookings and show toast
        bookings.assignAll(newBookings);
        filterPendingAndConfirmedBookings();
        filterDoneBookings();

        // Once the first data comes in, stop loading
        if (isLoading.value) {
          isLoading(false);
        }
      },
      onError: (error) {
        // Handle error if any occurs in the stream
        ToastNotif(message: 'Error fetching bookings: $error', title: 'Error')
            .showErrorNotif(Get.context!);
      },
      onDone: () {
        isLoading.value = false; // Stop loading when stream is done
      },
    );
  }

  void filterPendingAndConfirmedBookings() {
    pendingAndConfirmedBookings.value = bookings
        .where((booking) =>
            booking.status == 'confirmed' || booking.status == 'pending')
        .toList();
  }

  void filterDoneBookings() {
    doneBookings.value = bookings
        .where((booking) =>
            booking.status == 'done' || booking.status == 'canceled')
        .toList();
  }
}
