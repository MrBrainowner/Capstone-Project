import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class TimeSlotModel {
  final String? id;
  final TimeOfDay startTime; // Start time of the time slot
  final TimeOfDay endTime; // End time of the time slot
  int maxBooking; // Max bookings per time slot
  bool isAvailable; // If the time slot is available or not
  final DateTime? createdAt;

  TimeSlotModel({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.maxBooking,
    required this.isAvailable,
    this.createdAt,
  });

  static TimeSlotModel empty() {
    return TimeSlotModel(
      id: null,
      startTime: TimeOfDay.now(),
      endTime: TimeOfDay.now(),
      maxBooking: 0,
      isAvailable: false,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': timeOfDayToString(startTime), // Store time with AM/PM
      'end_time': timeOfDayToString(endTime), // Store time with AM/PM
      'max_booking': maxBooking,
      'is_available': isAvailable,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory TimeSlotModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return TimeSlotModel(
      id: document.id,
      startTime: _stringToTimeOfDay(
          data['start_time']), // Convert to TimeOfDay from string
      endTime: _stringToTimeOfDay(
          data['end_time']), // Convert to TimeOfDay from string
      maxBooking: data['max_booking'] ?? 1,
      isAvailable: data['is_available'] ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  TimeSlotModel copyWith({
    String? id,
    TimeOfDay? startTime,
    TimeOfDay? endTime,
    int? maxBooking,
    bool? isAvailable,
    DateTime? createdAt,
  }) {
    return TimeSlotModel(
      id: id ?? this.id,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      maxBooking: maxBooking ?? this.maxBooking,
      isAvailable: isAvailable ?? this.isAvailable,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  String get schedule => "${formatTime(startTime)} - ${formatTime(endTime)}";

  static String timeOfDayToString(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod; // Convert to 12-hour format for AM/PM
    final minute = time.minute
        .toString()
        .padLeft(2, '0'); // Add leading zero to minute if necessary
    final period = time.period == DayPeriod.am
        ? 'AM'
        : 'PM'; // Get AM/PM based on the period

    return '$hour:$minute $period'; // Format like '9:00 AM'
  }

  static TimeOfDay _stringToTimeOfDay(String timeString) {
    final parts = timeString.split(':');
    final hourAndPeriod = parts[0];
    final minute = int.parse(parts[1].substring(0, 2)); // Extract minute part

    final hour = int.parse(hourAndPeriod);
    parts[1].substring(3).toUpperCase() == 'AM' ? DayPeriod.am : DayPeriod.pm;

    return TimeOfDay(hour: hour, minute: minute);
  }

  static String formatTime(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0
        ? 12
        : time.hourOfPeriod; // Convert hour to 12-hour format if it's 0 AM
    final minute = time.minute
        .toString()
        .padLeft(2, '0'); // Add leading zero to minutes if needed
    final period = time.period == DayPeriod.am ? "AM" : "PM"; // Add AM/PM

    return '$hour:$minute $period'; // Format as '9:00 AM' or '9:00 PM'
  }
}
