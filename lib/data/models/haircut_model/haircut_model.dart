import 'package:cloud_firestore/cloud_firestore.dart';

class HaircutModel {
  String? id;
  String name;
  String description;
  double price;
  int duration;
  List<String> category;
  List<String> imageUrls; // New field for image URLs
  final DateTime? createdAt;

  HaircutModel({
    required this.id,
    required this.name,
    required this.description,
    required this.price,
    required this.duration,
    required this.category,
    required this.imageUrls, // Initialize new field
    this.createdAt,
  });

  static HaircutModel empty() {
    return HaircutModel(
      id: null,
      name: '',
      description: '',
      price: 0.0,
      duration: 0,
      category: [],
      imageUrls: [], // Initialize with an empty list
      createdAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price': price,
      'duration': duration,
      'category': category,
      'imageUrls': imageUrls, // Serialize new field
      'created_at': createdAt?.toIso8601String(),
    };
  }

  factory HaircutModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return HaircutModel(
      id: document.id,
      name: data['name'] ?? '',
      description: data['description'] ?? '',
      price: data['price'] ?? 0.0,
      duration: data['duration'] ?? 0,
      category: List<String>.from(data['category'] ?? []),
      imageUrls:
          List<String>.from(data['imageUrls'] ?? []), // Deserialize new field
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : null,
    );
  }

  HaircutModel copyWith({
    String? id,
    String? name,
    String? description,
    double? price,
    int? duration,
    List<String>? category,
    List<String>? imageUrls, // Add new field to copyWith
    DateTime? createdAt,
  }) {
    return HaircutModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      price: price ?? this.price,
      duration: duration ?? this.duration,
      category: category ?? this.category,
      imageUrls: imageUrls ?? this.imageUrls, // Update new field
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
