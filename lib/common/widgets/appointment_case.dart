import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/features/customer/views/widgets/dashboard/appointment_card.dart';
import 'package:flutter/material.dart';

Widget buildAppointmentWidget(BookingModel booking) {
  switch (booking.status) {
    case 'pending':
      return AppointmentCardCustomers(
          title: 'Appointment Pending',
          message: 'You appointment with ${booking.barbershopName} is pending',
          booking: booking);
    case 'confirmed':
      return AppointmentConfirmedCardCustomers(
          title: 'Appointment Confirmed',
          message:
              'You appointment with ${booking.barbershopName} is confirmed',
          booking: booking);
    default:
      return AppointmentCardCustomers(
          title: 'Unknown', message: 'unknown appointment', booking: booking);
  }
}
