import 'package:cloud_firestore/cloud_firestore.dart';

class TimeSlotModel {
  final String? id;
  final DateTime startTime; // Start time of the time slot
  final DateTime endTime; // End time of the time slot
  int maxBooking; // Max bookings per time slot
  bool? isAvailable; // If the time slot is available or not
  final DateTime? createdAt;

  TimeSlotModel({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.maxBooking,
    this.isAvailable,
    this.createdAt,
  });

  static TimeSlotModel empty() {
    return TimeSlotModel(
      id: null,
      startTime: DateTime.now(),
      endTime: DateTime.now(),
      maxBooking: 0,
      isAvailable: false,
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'start_time': startTime.toIso8601String(),
      'end_time': endTime.toIso8601String(),
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
      startTime: DateTime.parse(data['start_time']),
      endTime: DateTime.parse(data['end_time']),
      maxBooking: data['max_booking'] ?? 0,
      isAvailable: data['is_available'] ?? false,
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  TimeSlotModel copyWith({
    String? id,
    DateTime? startTime,
    DateTime? endTime,
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

  String get schedule =>
      "${startTime.hour}:${startTime.minute} - ${endTime.hour}:${endTime.minute}";
}
