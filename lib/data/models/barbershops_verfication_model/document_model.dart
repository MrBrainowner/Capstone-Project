import 'package:cloud_firestore/cloud_firestore.dart';

class BarbershopDocumentModel {
  final String documentType; // Document type, e.g., 'License', 'Certificate'
  final String documentURL; // URL to the uploaded document in Firebase Storage
  final String
      status; // Document status, e.g., 'Pending', 'Approved', 'Rejected'
  final String? feedback; // Optional feedback field, can be null

  BarbershopDocumentModel({
    required this.documentType,
    required this.documentURL,
    this.status = 'Pending', // Default to 'Pending'
    this.feedback,
  });

  // Convert model to a JSON map to save to Firestore
  Map<String, dynamic> toJson() {
    return {
      'document_type': documentType,
      'document_url': documentURL,
      'status': status,
      'feedback': feedback,
    };
  }

  // Factory method to create a model from Firestore data
  factory BarbershopDocumentModel.fromJson(Map<String, dynamic> data) {
    return BarbershopDocumentModel(
      documentType: data['document_type'] ?? '',
      documentURL: data['document_url'] ?? '',
      status: data['status'] ?? 'Pending',
      feedback: data['feedback'],
    );
  }

  // Copy method for creating an updated instance of this model
  BarbershopDocumentModel copyWith({
    String? documentType,
    String? documentURL,
    String? status,
    String? feedback,
  }) {
    return BarbershopDocumentModel(
      documentType: documentType ?? this.documentType,
      documentURL: documentURL ?? this.documentURL,
      status: status ?? this.status,
      feedback: feedback ?? this.feedback,
    );
  }
}

class BarbershopApplicationModel {
  final String barbershopId; // Barbershop identifier
  final List<BarbershopDocumentModel> documents; // List of uploaded documents
  final DateTime createdAt; // Submission date

  BarbershopApplicationModel({
    required this.barbershopId,
    required this.documents,
    required this.createdAt,
  });

  // Convert model to a JSON map to save to Firestore
  Map<String, dynamic> toJson() {
    return {
      'barbershop_id': barbershopId,
      'documents': documents.map((doc) => doc.toJson()).toList(),
      'created_at': createdAt.toIso8601String(),
    };
  }

  // Factory method to create a model from Firestore document snapshot
  factory BarbershopApplicationModel.fromSnapshot(
      DocumentSnapshot<Map<String, dynamic>> document) {
    final data = document.data()!;
    return BarbershopApplicationModel(
      barbershopId: data['barbershop_id'] ?? '',
      documents: (data['documents'] as List<dynamic>? ?? [])
          .map((doc) =>
              BarbershopDocumentModel.fromJson(doc as Map<String, dynamic>))
          .toList(),
      createdAt: data['created_at'] != null
          ? DateTime.parse(data['created_at'])
          : DateTime.now(),
    );
  }

  // Copy method for modifying the current model
  BarbershopApplicationModel copyWith({
    String? barbershopId,
    List<BarbershopDocumentModel>? documents,
    DateTime? createdAt,
  }) {
    return BarbershopApplicationModel(
      barbershopId: barbershopId ?? this.barbershopId,
      documents: documents ?? this.documents,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
