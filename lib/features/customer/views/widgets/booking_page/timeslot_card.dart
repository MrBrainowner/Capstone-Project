import 'package:barbermate/features/customer/controllers/booking_controller/booking_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../../../data/models/timeslot_model/timeslot_model.dart';

class TimeSlotCard extends StatelessWidget {
  const TimeSlotCard({
    super.key,
    required this.timeSlot,
  });

  final TimeSlotModel timeSlot;

  @override
  Widget build(BuildContext context) {
    final CustomerBookingController bookingController = Get.find();

    return Obx(() {
      final isSelected = bookingController.toggleTimeSlot.value == timeSlot;
      final isAvailable = timeSlot.isAvailable;

      return GestureDetector(
        onTap: isAvailable
            ? () {
                // Only allow selection if the timeslot is available
                if (isSelected) {
                  bookingController.toggleTimeSlot.value = null;
                } else {
                  bookingController.toggleTimeSlot.value = timeSlot;
                }
                bookingController.selectedTimeSlot.value = timeSlot;
              }
            : null, // Disable taps if not available
        child: Container(
          decoration: BoxDecoration(
            color: isAvailable
                ? (isSelected
                    ? Theme.of(context).primaryColor
                    : Colors.blue.shade50)
                : Colors.grey.shade300, // Greyed out for unavailable
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 2,
              color: isAvailable
                  ? (isSelected ? Theme.of(context).primaryColor : Colors.grey)
                  : Colors.grey.shade500, // Grey border for unavailable
            ),
          ),
          child: Center(
            child: Text(
              isAvailable ? timeSlot.schedule : '${timeSlot.schedule}\nFull',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isAvailable
                    ? (isSelected ? Colors.white : Colors.black)
                    : Colors.grey, // Grey text for unavailable
              ),
            ),
          ),
        ),
      );
    });
  }
}
