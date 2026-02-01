import 'package:cloud_firestore/cloud_firestore.dart';

class Visitor {
  String? id;
  final String name;
  final String phone;
  final String flatNumber;
  final String purpose;
  final String checkInTime;
  final String? checkOutTime; // Optional
  final String? notes; // Optional
  final String status; // 'IN' or 'OUT'
  final DateTime createdAt;
  final bool hasVehicle;
  final String? vehicleNumber;

  Visitor({
    this.id,
    required this.name,
    required this.phone,
    required this.flatNumber,
    required this.purpose,
    required this.checkInTime,
    this.checkOutTime,
    this.notes,
    required this.status,
    required this.createdAt,
    this.hasVehicle = false,
    this.vehicleNumber,
  });

  // Convert Visitor to Map for Firestore
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'phone': phone,
      'flatNumber': flatNumber,
      'purpose': purpose,
      'checkInTime': checkInTime,
      'checkOutTime': checkOutTime,
      'notes': notes,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
      'hasVehicle': hasVehicle,
      'vehicleNumber': vehicleNumber,
    };
  }

  // Create Visitor from Firestore Document
  factory Visitor.fromDocument(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return Visitor(
      id: doc.id,
      name: data['name'] ?? '',
      phone: data['phone'] ?? '',
      flatNumber: data['flatNumber'] ?? '',
      purpose: data['purpose'] ?? '',
      checkInTime: data['checkInTime'] ?? '',
      checkOutTime: data['checkOutTime'],
      notes: data['notes'],
      status: data['status'] ?? 'IN',
      createdAt: (data['createdAt'] as Timestamp).toDate(),
      hasVehicle: data['hasVehicle'] ?? false,
      vehicleNumber: data['vehicleNumber'],
    );
  }
}
