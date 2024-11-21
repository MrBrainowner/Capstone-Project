import 'package:get/get.dart';
import '../../../../common/widgets/toast.dart';
import '../../../../data/models/timeslot_model/timeslot_model.dart';
import '../../../../data/repository/barbershop_repo/timeslot_repository.dart';

class TimeSlotController extends GetxController {
  static TimeSlotController get instance => Get.find();

  final TimeslotRepository _repository = Get.put(TimeslotRepository());
  final isLoading = false.obs;

  RxList<TimeSlotModel> timeSlots = <TimeSlotModel>[].obs;

  void init() async {
    await fetchTimeSlots();
    super.onInit();
  }

  // Create a time slot
  Future<void> createTimeSlot(TimeSlotModel timeSlot) async {
    isLoading.value = true;
    try {
      await _repository.createTimeSlot(timeSlot);
      Get.snackbar("Success", "Time slot created successfully.");
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Update a time slot
  Future<void> updateTimeSlot(
      String timeSlotId, Map<String, dynamic> updates) async {
    isLoading.value = true;
    try {
      final hasBookings = await _repository.hasActiveBookings(timeSlotId);
      if (hasBookings) {
        Get.snackbar("Error", "Cannot update time slot with active bookings.");
      } else {
        await _repository.updateTimeSlot(timeSlotId, updates);
        Get.snackbar("Success", "Time slot updated successfully.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  // Delete a time slot
  Future<void> deleteTimeSlot(String timeSlotId) async {
    isLoading.value = true;
    try {
      final hasBookings = await _repository.hasActiveBookings(timeSlotId);
      if (hasBookings) {
        Get.snackbar("Error", "Cannot delete time slot with active bookings.");
      } else {
        await _repository.deleteTimeSlot(timeSlotId);
        Get.snackbar("Success", "Time slot deleted successfully.");
      }
    } catch (e) {
      Get.snackbar("Error", e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchTimeSlots() async {
    isLoading.value = true;
    try {
      final slots = await _repository.fetchTimeSlots();
      timeSlots.value = slots;
    } catch (e) {
      ToastNotif(message: 'Error Fetching TimeSlots', title: 'Error')
          .showErrorNotif(Get.context!);
    } finally {
      isLoading.value = false;
    }
  }
}
