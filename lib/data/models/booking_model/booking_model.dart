import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String id;
  String barberShopId;
  String barberId;
  String customerId;
  String? haircutId;
  String date; // YYYY-MM-DD format
  String timeSlotId; // e.g., '9:00 AM'
  String status; // 'pending', 'confirmed', 'completed', 'canceled'
  final DateTime? createdAt;

  BookingModel({
    required this.id,
    required this.barberShopId,
    required this.barberId,
    required this.customerId,
    required this.haircutId,
    required this.date,
    required this.timeSlotId,
    required this.status,
    required this.createdAt,
  });

  static BookingModel empty() {
    return BookingModel(
      id: '',
      barberShopId: '',
      barberId: '',
      customerId: '',
      haircutId: '',
      date: '',
      timeSlotId: '',
      status: 'pending',
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barbershop_id': barberShopId,
      'barber_id': barberId,
      'customer_id': customerId,
      'haircut_id': haircutId,
      'date': date,
      'time_slot_id': timeSlotId,
      'status': status,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory BookingModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BookingModel(
      id: document.id,
      barberShopId: data['barbershop_id'] ?? '',
      barberId: data['barber_id'] ?? '',
      customerId: data['customer_id'] ?? '',
      haircutId: data['haircut_id'] ?? '',
      date: data['date'] ?? '',
      timeSlotId: data['time_slot_id'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  BookingModel copyWith({
    String? id,
    String? barberShopId,
    String? barberId,
    String? customerId,
    String? haircutId,
    String? date,
    String? timeSlotId,
    String? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      barberShopId: barberShopId ?? this.barberShopId,
      barberId: barberId ?? this.barberId,
      customerId: customerId ?? this.customerId,
      haircutId: haircutId ?? this.haircutId,
      date: date ?? this.date,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
