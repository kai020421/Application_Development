import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/booking_model.dart';
import '../models/room_model.dart';

abstract class BookingRepository {
  Stream<List<RoomModel>> watchRooms();
  Stream<List<BookingModel>> watchRoomBookingsForDate({
    required String roomId,
    required String date,
  });
  Stream<List<BookingModel>> watchBookingsForDate(String date);
  Stream<List<BookingModel>> watchUserBookings(String userId);
  Future<List<BookingModel>> fetchPastBookingsPage({
    required String userId,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  });
  Future<(List<BookingModel> items, DocumentSnapshot? lastDoc)>
      fetchPastBookingsPageWithCursor({
    required String userId,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  });
  Future<void> bookSlotAtomic({
    required String roomId,
    required String date,
    required DateTime slotStart,
    required DateTime slotEnd,
    required String userId,
    required String userName,
  });
  Future<void> cancelBooking(String bookingId);
}

class FirestoreBookingRepository implements BookingRepository {
  final FirebaseFirestore _db;

  FirestoreBookingRepository({FirebaseFirestore? db})
      : _db = db ?? FirebaseFirestore.instance;

  @override
  Stream<List<RoomModel>> watchRooms() {
    return _db.collection('rooms').orderBy('name').snapshots().map(
          (snap) => snap.docs
              .map((doc) => RoomModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Stream<List<BookingModel>> watchRoomBookingsForDate({
    required String roomId,
    required String date,
  }) {
    return _db
        .collection('bookings')
        .where('roomId', isEqualTo: roomId)
        .where('date', isEqualTo: date)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => BookingModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Stream<List<BookingModel>> watchBookingsForDate(String date) {
    return _db
        .collection('bookings')
        .where('date', isEqualTo: date)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((doc) => BookingModel.fromMap(doc.id, doc.data()))
              .toList(),
        );
  }

  @override
  Stream<List<BookingModel>> watchUserBookings(String userId) {
    return _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .snapshots()
        .map((snap) {
      final list = snap.docs
          .map((doc) => BookingModel.fromMap(doc.id, doc.data()))
          .toList();
      list.sort((a, b) => a.slotStart.compareTo(b.slotStart));
      return list;
    });
  }

  @override
  Future<List<BookingModel>> fetchPastBookingsPage({
    required String userId,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async {
    final (items, _) = await fetchPastBookingsPageWithCursor(
      userId: userId,
      startAfterDoc: startAfterDoc,
      limit: limit,
    );
    return items;
  }

  @override
  Future<(List<BookingModel> items, DocumentSnapshot? lastDoc)>
      fetchPastBookingsPageWithCursor({
    required String userId,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async {
    var query = _db
        .collection('bookings')
        .where('userId', isEqualTo: userId)
        .where('status', whereIn: ['completed', 'expired', 'cancelled'])
        .orderBy('slotStart', descending: true)
        .limit(limit);

    if (startAfterDoc != null) {
      query = query.startAfterDocument(startAfterDoc);
    }

    final snap = await query.get();
    final items = snap.docs
        .map((doc) => BookingModel.fromMap(doc.id, doc.data()))
        .toList();
    final lastDoc = snap.docs.isNotEmpty ? snap.docs.last : null;
    return (items, lastDoc);}
    

  @override
  Future<void> bookSlotAtomic({
    required String roomId,
    required String date,
    required DateTime slotStart,
    required DateTime slotEnd,
    required String userId,
    required String userName,
  }) async {
    final bookingsRef = _db.collection('bookings');
    final startTs = Timestamp.fromDate(slotStart);

    // Deterministic doc ID for natural uniqueness on (roomId, date, slotStart)
    final safeStart = slotStart.toIso8601String().replaceAll(':', '-');
    final slotDocRef = bookingsRef.doc('${roomId}_${date}_$safeStart');

    await _db.runTransaction((tx) async {
      // 1. Re-read target slot inside the transaction
      final existingSlotSnap = await tx.get(slotDocRef);
      if (existingSlotSnap.exists) {
        final existingData = existingSlotSnap.data()!;
        final status = existingData['status'] as String? ?? '';
        final end = (existingData['slotEnd'] as Timestamp?)?.toDate();
        final isStillActive =
            status == 'active' && (end == null || DateTime.now().isBefore(end));
        if (isStillActive) {
          throw StateError('Someone just booked this slot—pick another slot.');
        }
      }

      // 2. Check active booking count across all dates for this user (max 2)
      final activeQuerySnap = await bookingsRef
          .where('userId', isEqualTo: userId)
          .where('status', isEqualTo: 'active')
          .get();

      final now = DateTime.now();
      int activeCount = 0;
      for (final doc in activeQuerySnap.docs) {
        final end = (doc.data()['slotEnd'] as Timestamp?)?.toDate();
        if (end == null || now.isBefore(end)) {
          activeCount++;
        }
      }

      if (activeCount >= 2) {
        throw StateError(
          'You already have 2 active bookings. Cancel or finish one before booking another.',
        );
      }

      // 3. Create booking atomically
      tx.set(slotDocRef, {
        'roomId': roomId,
        'date': date,
        'slotStart': startTs,
        'slotEnd': Timestamp.fromDate(slotEnd),
        'userId': userId,
        'userName': userName,
        'status': 'active',
        'createdAt': Timestamp.fromDate(now),
      });
    });
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    await _db.collection('bookings').doc(bookingId).update({
      'status': 'cancelled',
    });
  }
}