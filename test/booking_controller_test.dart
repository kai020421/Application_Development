import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/assignment_4/models/booking_model.dart';
import 'package:project/assignment_4/models/room_model.dart';
import 'package:project/assignment_4/providers/roomback_providers.dart';
import 'package:project/assignment_4/services/booking_repository.dart';

class FakeUser implements User {
  @override
  String get uid => 'test-user-0493';

  @override
  String? get email => '0493@iba.edu.pk';

  @override
  String? get displayName => 'Test Student';

  @override
  noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class FakeBookingRepository implements BookingRepository {
  bool simulateSlotTaken = false;
  int activeBookingCountForUser = 0;
  int bookCalls = 0;
  String? lastCancelledId;

  @override
  Future<void> bookSlotAtomic({
    required String roomId,
    required String date,
    required DateTime slotStart,
    required DateTime slotEnd,
    required String userId,
    required String userName,
  }) async {
    bookCalls++;
    if (simulateSlotTaken) {
      throw StateError('Someone just booked this slot—pick another slot.');
    }
    if (activeBookingCountForUser >= 2) {
      throw StateError(
        'You already have 2 active bookings. Cancel or finish one before booking another.',
      );
    }
    activeBookingCountForUser++;
  }

  @override
  Future<void> cancelBooking(String bookingId) async {
    lastCancelledId = bookingId;
  }

  @override
  Future<List<BookingModel>> fetchPastBookingsPage({
    required String userId,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async => [];

  @override
  Future<(List<BookingModel> items, DocumentSnapshot? lastDoc)>
      fetchPastBookingsPageWithCursor({
    required String userId,
    DocumentSnapshot? startAfterDoc,
    int limit = 10,
  }) async => (<BookingModel>[], null);

  @override
  Stream<List<BookingModel>> watchBookingsForDate(String date) =>
      const Stream.empty();

  @override
  Stream<List<BookingModel>> watchRoomBookingsForDate({
    required String roomId,
    required String date,
  }) =>
      const Stream.empty();

  @override
  Stream<List<RoomModel>> watchRooms() => const Stream.empty();

  @override
  Stream<List<BookingModel>> watchUserBookings(String userId) =>
      const Stream.empty();
}

Future<ProviderContainer> _createTestContainer(
  FakeBookingRepository fakeRepo,
) async {
  final fakeUser = FakeUser();
  final container = ProviderContainer(
    overrides: [
      bookingRepositoryProvider.overrideWithValue(fakeRepo),
      authStateProvider.overrideWith((ref) => Stream<User?>.value(fakeUser)),
      currentUserProfileProvider.overrideWith((ref) => Stream.value(null)),
    ],
  );
  container.listen(authStateProvider, (_, _) {});
  await Future<void>.delayed(Duration.zero);
  await Future<void>.delayed(Duration.zero);
  return container;
}

void main() {
  test('surfaces error when slot is already taken', () async {
    final fakeRepo = FakeBookingRepository()..simulateSlotTaken = true;
    final container = await _createTestContainer(fakeRepo);
    addTearDown(container.dispose);

    final day = DateTime(2026, 11, 20);
    await container.read(bookingActionProvider.notifier).bookSlot(
          roomId: 'Room-0493-1',
          day: day,
          slotStart: DateTime(2026, 11, 20, 9, 0),
          slotEnd: DateTime(2026, 11, 20, 9, 30),
        );

    final state = container.read(bookingActionProvider);
    expect(state.hasError, isTrue);
    expect(state.error.toString(), contains('Someone just booked this slot'));
  });

  test('enforces max 2 active bookings cap', () async {
    final fakeRepo = FakeBookingRepository()..activeBookingCountForUser = 2;
    final container = await _createTestContainer(fakeRepo);
    addTearDown(container.dispose);

    final day = DateTime(2026, 11, 20);
    await container.read(bookingActionProvider.notifier).bookSlot(
          roomId: 'Room-0493-2',
          day: day,
          slotStart: DateTime(2026, 11, 20, 10, 0),
          slotEnd: DateTime(2026, 11, 20, 10, 30),
        );

    final state = container.read(bookingActionProvider);
    expect(state.hasError, isTrue);
    expect(state.error.toString(), contains('2 active bookings'));
  });

  test('succeeds and delegates cancelBooking when valid', () async {
    final fakeRepo = FakeBookingRepository();
    final container = await _createTestContainer(fakeRepo);
    addTearDown(container.dispose);

    final day = DateTime(2026, 11, 20);
    await container.read(bookingActionProvider.notifier).bookSlot(
          roomId: 'Room-0493-3',
          day: day,
          slotStart: DateTime(2026, 11, 20, 11, 0),
          slotEnd: DateTime(2026, 11, 20, 11, 30),
        );

    expect(container.read(bookingActionProvider).hasError, isFalse);
    expect(fakeRepo.bookCalls, 1);

    await container.read(bookingActionProvider.notifier).cancelBooking('b-123');
    expect(fakeRepo.lastCancelledId, 'b-123');
  });
}