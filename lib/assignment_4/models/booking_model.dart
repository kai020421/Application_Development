import 'package:cloud_firestore/cloud_firestore.dart';

class BookingModel {
  final String id;
  final String roomId;
  final String date; // YYYY-MM-DD
  final DateTime slotStart;
  final DateTime slotEnd;
  final String userId;
  final String userName;
  final String status; // 'active' | 'cancelled' | 'expired' | 'completed'
  final DateTime createdAt;

  const BookingModel({
    required this.id,
    required this.roomId,
    required this.date,
    required this.slotStart,
    required this.slotEnd,
    required this.userId,
    required this.userName,
    required this.status,
    required this.createdAt,
  });

  String get effectiveStatus {
    if (status == 'active' && DateTime.now().isAfter(slotEnd)) {
      return 'expired';
    }
    return status;
  }

  bool get isActiveEffective => effectiveStatus == 'active';

  factory BookingModel.fromMap(String id, Map<String, dynamic> data) {
    return BookingModel(
      id: id,
      roomId: data['roomId'] as String? ?? '',
      date: data['date'] as String? ?? '',
      slotStart: (data['slotStart'] as Timestamp).toDate(),
      slotEnd: (data['slotEnd'] as Timestamp).toDate(),
      userId: data['userId'] as String? ?? '',
      userName: data['userName'] as String? ?? '',
      status: data['status'] as String? ?? 'active',
      createdAt: (data['createdAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'roomId': roomId,
      'date': date,
      'slotStart': Timestamp.fromDate(slotStart),
      'slotEnd': Timestamp.fromDate(slotEnd),
      'userId': userId,
      'userName': userName,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}