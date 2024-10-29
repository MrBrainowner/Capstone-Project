import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String? id;
  String barberId;
  String customerId;
  String haircutId;
  String date; // YYYY-MM-DD format
  String startTime; // e.g., '9:00 AM'
  String endTime; // e.g., '10:00 AM'
  String status; // 'pending', 'confirmed', 'completed', 'canceled'
  final DateTime? createdAt;

  BookingModel({
    required this.id,
    required this.barberId,
    required this.customerId,
    required this.haircutId,
    required this.date,
    required this.startTime,
    required this.endTime,
    required this.status,
    required this.createdAt,
  });

  static BookingModel empty() {
    return BookingModel(
      id: null,
      barberId: '',
      customerId: '',
      haircutId: '',
      date: '',
      startTime: '',
      endTime: '',
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barber_id': barberId,
      'customer_id': customerId,
      'haircut_id': haircutId,
      'date': date,
      'start_time': startTime,
      'end_time': endTime,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory BookingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BookingModel(
      id: document.id,
      barberId: data['barber_id'] ?? '',
      customerId: data['customer_id'] ?? '',
      haircutId: data['haircut_id'] ?? '',
      date: data['date'] ?? '',
      startTime: data['start_time'] ?? '',
      endTime: data['end_time'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  BookingModel copyWith({
    String? id,
    String? barberId,
    String? customerId,
    String? haircutId,
    String? date,
    String? startTime,
    String? endTime,
    String? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      barberId: barberId ?? this.barberId,
      customerId: customerId ?? this.customerId,
      haircutId: haircutId ?? this.haircutId,
      date: date ?? this.date,
      startTime: startTime ?? this.startTime,
      endTime: endTime ?? this.endTime,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
