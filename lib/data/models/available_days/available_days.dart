import 'package:cloud_firestore/cloud_firestore.dart';

class AvailableDaysModel {
  // Map to store the status of each day of the week
  Map<String, bool> daysOfWeekStatus;
  List<DateTime> disabledDates; // List of disabled specific dates

  AvailableDaysModel({
    required this.daysOfWeekStatus,
    required this.disabledDates,
  });

  // Convert model data into a JSON format for Firestore
  Map<String, dynamic> toJson() {
    return {
      'days_of_week_status': daysOfWeekStatus,
      'disabled_dates':
          disabledDates.map((date) => date.toIso8601String()).toList(),
    };
  }

  // Create a model from Firestore snapshot
  factory AvailableDaysModel.fromSnapshot(DocumentSnapshot snapshot) {
    final data = snapshot.data() as Map<String, dynamic>;
    final disabledDatesList = (data['disabled_dates'] as List)
        .map((date) => DateTime.parse(date as String))
        .toList();
    final daysOfWeekStatus =
        Map<String, bool>.from(data['days_of_week_status']);

    return AvailableDaysModel(
      daysOfWeekStatus: daysOfWeekStatus,
      disabledDates: disabledDatesList,
    );
  }
}
