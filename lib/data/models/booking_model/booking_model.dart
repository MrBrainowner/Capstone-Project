// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  String id;
  String customerName;
  String haircutName;
  double haircutPrice;
  String barbershopName;
  String customerPhoneNo;
  String timeSlot;
  String barberShopId;
  String barberId;
  String customerId;
  String? haircutId;
  String date; // YYYY-MM-DD format
  String timeSlotId; // e.g., '9:00 AM'
  String status; // 'pending', 'confirmed', 'completed', 'canceled'
  final DateTime createdAt;

  BookingModel({
    required this.id,
    required this.customerName,
    required this.haircutName,
    required this.haircutPrice,
    required this.barbershopName,
    required this.customerPhoneNo,
    required this.timeSlot,
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
      haircutName: '', // empty name for haircut
      haircutPrice: 0.0, // default price of 0
      date: '',
      timeSlotId: '',
      status: 'pending',
      createdAt: DateTime.now(),
      customerName: '',
      barbershopName: '',
      customerPhoneNo: '',
      timeSlot: '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'barbershop_id': barberShopId,
      'customerName': customerName,
      'barbershopName': barbershopName,
      'customerPhoneNo': customerPhoneNo,
      'timeSlot': timeSlot,
      'barber_id': barberId,
      'customer_id': customerId,
      'haircut_id': haircutId,
      'haircutName': haircutName, // Add haircut name
      'haircutPrice': haircutPrice, // Add haircut price
      'date': date,
      'time_slot_id': timeSlotId,
      'status': status,
      'created_at': Timestamp.fromDate(createdAt),
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
      haircutName: data['haircutName'] ?? '', // Retrieve haircut name
      haircutPrice: data['haircutPrice'] ?? 0.0, // Retrieve haircut price
      date: data['date'] ?? '',
      timeSlotId: data['time_slot_id'] ?? '',
      status: data['status'] ?? 'pending',
      createdAt: (data['created_at'] as Timestamp).toDate(),
      customerName: data['customerName'] ?? '',
      barbershopName: data['barbershopName'] ?? '',
      customerPhoneNo: data['customerPhoneNo'] ?? '',
      timeSlot: data['timeSlot'] ?? '',
    );
  }

  BookingModel copyWith({
    String? id,
    String? barberShopId,
    String? customerName,
    String? barbershopName,
    String? customerPhoneNo,
    String? timeSlot,
    String? barberId,
    String? customerId,
    String? haircutId,
    String? haircutName,
    double? haircutPrice,
    String? date,
    String? timeSlotId,
    String? status,
    DateTime? createdAt,
  }) {
    return BookingModel(
      id: id ?? this.id,
      barberShopId: barberShopId ?? this.barberShopId,
      barberId: barberId ?? this.barberId,
      customerName: customerName ?? this.customerName,
      barbershopName: barbershopName ?? this.barbershopName,
      timeSlot: timeSlot ?? this.timeSlot,
      customerPhoneNo: customerPhoneNo ?? this.customerPhoneNo,
      customerId: customerId ?? this.customerId,
      haircutId: haircutId ?? this.haircutId,
      haircutName: haircutName ?? this.haircutName, // Update haircut name
      haircutPrice: haircutPrice ?? this.haircutPrice, // Update haircut price
      date: date ?? this.date,
      timeSlotId: timeSlotId ?? this.timeSlotId,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
