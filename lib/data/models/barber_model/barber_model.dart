import 'package:cloud_firestore/cloud_firestore.dart';

class BarberModel {
  String? id;
  String fullName;
  String profileImage;
  List<Map<String, String>>
      workingHours; // Example: [{'day': 'Monday', 'open': '9:00', 'close': '18:00'}]
  final DateTime? createdAt;

  BarberModel({
    this.id,
    required this.fullName,
    required this.profileImage,
    required this.workingHours,
    required this.createdAt,
  });

  static BarberModel empty() {
    return BarberModel(
      id: null,
      fullName: '',
      profileImage: '',
      workingHours: [],
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'fullName': fullName,
      'profileImage': profileImage,
      'working_hours': workingHours,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory BarberModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BarberModel(
      id: document.id,
      fullName: data['fullName'] ?? '',
      profileImage: data['profileImage'] ?? '',
      workingHours: List<Map<String, String>>.from(data['working_hours'] ?? []),
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  BarberModel copyWith({
    String? id,
    String? fullName,
    String? profileImage,
    List<Map<String, String>>? workingHours,
    DateTime? createdAt,
  }) {
    return BarberModel(
      id: id ?? this.id,
      fullName: fullName ?? this.fullName,
      profileImage: profileImage ?? this.profileImage,
      workingHours: workingHours ?? this.workingHours,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
