// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';

class BarbershopModel {
  final String id;
  String firstName;
  String lastName;
  final String email;
  String phoneNo;
  final String barbershopName;
  String barbershopProfileImage;
  String barbershopBannerImage;
  final String role;
  String status;
  final DateTime createdAt;
  final String address;
  final double latitude; // New field
  final double longitude;
  final String landMark;
  final int postal;
  final String streetAddress;
  final String floorNumber;

  BarbershopModel({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phoneNo,
    required this.barbershopName,
    required this.barbershopProfileImage,
    required this.barbershopBannerImage,
    required this.role,
    required this.status,
    required this.createdAt,
    required this.address,
    required this.latitude,
    required this.longitude,
    required this.landMark,
    required this.postal,
    required this.streetAddress,
    required this.floorNumber,
  });

  // Static function to create an empty Barbershop model
  static BarbershopModel empty() {
    return BarbershopModel(
      id: '',
      firstName: '',
      lastName: '',
      email: '',
      phoneNo: '',
      barbershopName: '',
      barbershopProfileImage: '',
      barbershopBannerImage: '',
      role: '',
      status: '',
      createdAt: DateTime.now(),
      address: '',
      latitude: 0.0,
      longitude: 0.0,
      landMark: '',
      postal: 0,
      streetAddress: '',
      floorNumber: '',
    );
  }

  // Convert model to JSON structure for storing data in Firebase
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'first_name': firstName,
      'last_name': lastName,
      'email': email,
      'phone_no': phoneNo,
      'barbershop_name': barbershopName,
      'barbershop_profile_image': barbershopProfileImage,
      'barbershop_banner_image': barbershopBannerImage,
      'role': role,
      'status': status,
      'created_at': createdAt.toIso8601String(),
      'address': address,
      'latitude': latitude,
      'longitude': longitude,
      'landMark': landMark,
      'postal': postal,
      'street_address': streetAddress,
      'floorNumber': floorNumber,
    };
  }

  // Factory method to create a BarbershopModel from a Firebase document snapshot
  factory BarbershopModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BarbershopModel(
      id: document.id,
      firstName: data['first_name'] ?? '',
      lastName: data['last_name'] ?? '',
      email: data['email'] ?? '',
      phoneNo: data['phone_no'] ?? '',
      barbershopName: data['barbershop_name'] ?? '',
      barbershopProfileImage: data['barbershop_profile_image'] ?? '',
      barbershopBannerImage: data['barbershop_banner_image'] ?? '',
      role: data['role'] ?? '',
      status: data['status'] ?? '',
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
      address: data['address'] ?? '',
      latitude: data['latitude']?.toDouble() ?? 0.0, // Parse latitude
      longitude: data['longitude']?.toDouble() ?? 0.0,
      landMark: data['landMark'] ?? '', // Parse longitude
      postal: data['postal']?.toInt() ?? 0, // Parse postal
      streetAddress: data['street_address'] ?? '',
      floorNumber: data['floorNumber'] ?? '', // Parse streetAddress
    );
  }

  // CopyWith method for creating a modified copy of the current instance
  BarbershopModel copyWith({
    String? id,
    String? firstName,
    String? lastName,
    String? email,
    String? phoneNo,
    String? barbershopName,
    String? barbershopProfileImage,
    String? barbershopBannerImage,
    String? role,
    String? status,
    DateTime? createdAt,
    String? address,
    double? latitude,
    double? longitude,
    String? landMark,
    int? postal,
    String? streetAddress,
    String? floorNumber,
  }) {
    return BarbershopModel(
      id: id ?? this.id,
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      phoneNo: phoneNo ?? this.phoneNo,
      barbershopName: barbershopName ?? this.barbershopName,
      barbershopProfileImage:
          barbershopProfileImage ?? this.barbershopProfileImage,
      barbershopBannerImage:
          barbershopBannerImage ?? this.barbershopBannerImage,
      role: role ?? this.role,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      address: address ?? this.address,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      landMark: landMark ?? this.landMark,
      postal: postal ?? this.postal,
      streetAddress: streetAddress ?? this.streetAddress,
      floorNumber: floorNumber ?? this.floorNumber,
    );
  }

  // Convert model to entity (if using with any state management or other libraries)
  // This method can be customized based on your application's requirements
  // For example, if you need to convert it to a domain entity or DTO (Data Transfer Object)
  // The implementation will vary based on your architecture.
  // For simplicity, it's left out in this example.
}
