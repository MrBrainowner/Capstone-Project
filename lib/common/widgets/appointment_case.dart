import 'package:barbermate/data/models/booking_model/booking_model.dart';
import 'package:barbermate/features/barbershop/views/widgets/appoiments/appoiments_widget.dart';
import 'package:barbermate/features/customer/views/widgets/dashboard/appointment_card.dart';
import 'package:flutter/material.dart';

Widget buildAppointmentWidgetCustomers(BookingModel booking) {
  switch (booking.status) {
    case 'pending':
      return AppointmentCardCustomers(booking: booking);
    case 'confirmed':
      return AppointmentConfirmedCardCustomers(booking: booking);
    case 'canceled':
      return AppointmentDoneCardCustomers(booking: booking);
    case 'declined':
      return AppointmentDoneCardCustomers(booking: booking);
    case 'done':
      return AppointmentDoneCardCustomers(booking: booking);
    default:
      return AppointmentCardCustomers(booking: booking);
  }
}

Widget buildAppointmentWidgetBarbershops(BookingModel booking) {
  switch (booking.status) {
    case 'pending':
      return AppointmentCard(
        booking: booking,
      );
    case 'confirmed':
      return AppointmentConfirmedCard(
        booking: booking,
      );
    case 'canceled':
      return AppointmentDoneCard(
        booking: booking,
      );
    case 'declined':
      return AppointmentDoneCard(
        booking: booking,
      );
    case 'done':
      return AppointmentDoneCard(
        booking: booking,
      );
    default:
      return AppointmentCardCustomers(booking: booking);
  }
}
