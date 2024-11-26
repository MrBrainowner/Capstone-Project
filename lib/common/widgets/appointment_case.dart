import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/features/customer/views/widgets/dashboard/appointment_card.dart';
import 'package:flutter/material.dart';

Widget buildAppointmentWidget(BookingModel booking) {
  switch (booking.status) {
    case 'pending':
      return AppointmentCardCustomers(title: '', message: '', booking: booking);
    case 'confirmed':
      return AppointmentConfirmedCardCustomers(
          title: '', message: '', booking: booking);
    default:
      return AppointmentCardCustomers(
          title: 'Unknown', message: 'unknown appointment', booking: booking);
  }
}
