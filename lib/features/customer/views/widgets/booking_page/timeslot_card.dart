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
    final bookingController = Get.put(CustomerBookingController());

    return Obx(() {
      final isSelected = bookingController.selectedTimeSlot.value == timeSlot;

      return GestureDetector(
        onTap: () {
          // Select or deselect the time slot
          if (isSelected) {
            bookingController.selectedTimeSlot.value = null;
          } else {
            bookingController.selectedTimeSlot.value = timeSlot;
          }
        },
        child: Container(
          decoration: BoxDecoration(
            color: isSelected
                ? Theme.of(context).primaryColor
                : Colors.blue.shade50,
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              width: 2,
              color: isSelected ? Theme.of(context).primaryColor : Colors.grey,
            ),
          ),
          child: Center(
            child: Text(
              timeSlot.schedule,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: isSelected ? Colors.white : Colors.black,
              ),
            ),
          ),
        ),
      );
    });
  }
}
