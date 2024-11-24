import 'package:cloud_firestore/cloud_firestore.dart';

class NotificationModel {
  String? id;
  final String type; // e.g., "booking", "appointment_status", etc.
  final String title;
  final String message;
  final String? status; // Optional, used for specific notifications
  final DateTime? createdAt; // Optional field for timestamp

  NotificationModel({
    this.id,
    required this.type,
    required this.title,
    required this.message,
    this.status,
    this.createdAt,
  });

  // Static method for an empty Notification (if needed)
  static NotificationModel empty() {
    return NotificationModel(
      id: '',
      type: '',
      title: '',
      message: '',
      status: null,
      createdAt: DateTime.now(),
    );
  }

  // Convert the NotificationModel into a Map (for Firestore)
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'title': title,
      'message': message,
      'status': status,
      'created_at': createdAt?.toIso8601String(), // Optional field
    };
  }

  // Create a NotificationModel from a Firestore snapshot
  factory NotificationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return NotificationModel(
      id: document.id,
      type: data['type'] ?? '',
      title: data['title'] ?? '',
      message: data['message'] ?? '',
      status: data['status'], // Can be null
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  // Copy with method to update specific fields while keeping others unchanged
  NotificationModel copyWith({
    String? id,
    String? type,
    String? title,
    String? message,
    String? status,
    DateTime? createdAt,
  }) {
    return NotificationModel(
      id: id ?? this.id,
      type: type ?? this.type,
      title: title ?? this.title,
      message: message ?? this.message,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
