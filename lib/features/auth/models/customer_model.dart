import 'package:cloud_firestore/cloud_firestore.dart';

class CustomerModel {
  // keep those values final which you don't want to update
  final String id;
  String firstName;
  String lastName;
  final String email;
  String profileImage;
  String phoneNo;
  final String role;
  final DateTime? createdAt;

  CustomerModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.profileImage,
    required this.phoneNo,
    required this.role,
    required this.createdAt,
  });

  // Static function to create an empty Customer model
  static CustomerModel empty() {
    return CustomerModel(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      profileImage: '',
      phoneNo: '',
      role: '',
      createdAt: DateTime.now(),
    );
  }

  // Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'profile_image': profileImage,
      'phone_no': phoneNo,
      'role': role,
      'created_at': createdAt?.toIso8601String(),
    };
  }

  // Factory method to create a CustomerModel from a Firebase document snapshot
  factory CustomerModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return CustomerModel(
      id: document.id,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      profileImage: data['profile_image'] ?? '',
      phoneNo: data['phone_no'] ?? '',
      role: data['role'] ?? '',
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  // CopyWith method for creating a modified copy of the current instance
  CustomerModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? profileImage,
    String? phoneNo,
    String? role,
    DateTime? createdAt,
  }) {
    return CustomerModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      phoneNo: phoneNo ?? this.phoneNo,
      role: role ?? this.role,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  // Convert model to entity (if using with any state management or other libraries)
  // This method can be customized based on your application's requirements
  // For example, if you need to convert it to a domain entity or DTO (Data Transfer Object)
  // The implementation will vary based on your architecture.
  // For simplicity, it's left out in this example.
}
