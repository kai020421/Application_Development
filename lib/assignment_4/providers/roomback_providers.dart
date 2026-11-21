import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../models/room_model.dart';
import '../models/user_model.dart';
import '../services/auth_service.dart';
import '../services/booking_repository.dart';

final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final bookingRepositoryProvider = Provider<BookingRepository>(
  (ref) => FirestoreBookingRepository(),
);

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges();
});

final currentUserProfileProvider = StreamProvider<AppUserModel?>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value(null);
  return ref.watch(authServiceProvider).watchUserProfile(user.uid);
});

final selectedDateProvider = StateProvider<DateTime>((ref) {
  final now = DateTime.now();
  return DateTime(now.year, now.month, now.day);
});

String formatDateKey(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}

List<DateTime> buildSevenDayWindow() {
  final now = DateTime.now();
  final today = DateTime(now.year, now.month, now.day);
  return List.generate(7, (i) => today.add(Duration(days: i)));
}

List<(DateTime start, DateTime end)> buildDaySlots(DateTime day) {
  // 9:00 AM to 9:00 PM = 12 hours = 24 slots of 30 minutes
  final startOfDay = DateTime(day.year, day.month, day.day, 9, 0);
  return List.generate(24, (i) {
    final s = startOfDay.add(Duration(minutes: i * 30));
    final e = s.add(const Duration(minutes: 30));
    return (s, e);
  });
}

final roomsStreamProvider = StreamProvider<List<RoomModel>>((ref) {
  return ref.watch(bookingRepositoryProvider).watchRooms();
});

typedef RoomDateKey = ({String roomId, String date});

final roomBookingsStreamProvider =
    StreamProvider.family<List<BookingModel>, RoomDateKey>((ref, key) {
  return ref.watch(bookingRepositoryProvider).watchRoomBookingsForDate(
        roomId: key.roomId,
        date: key.date,
      );
});

final dateAllBookingsStreamProvider =
    StreamProvider.family<List<BookingModel>, String>((ref, date) {
  return ref.watch(bookingRepositoryProvider).watchBookingsForDate(date);
});

final myBookingsStreamProvider = StreamProvider<List<BookingModel>>((ref) {
  final user = ref.watch(authStateProvider).value;
  if (user == null) return Stream.value([]);
  return ref.watch(bookingRepositoryProvider).watchUserBookings(user.uid);
});

class BookingActionController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<void> bookSlot({
    required String roomId,
    required DateTime day,
    required DateTime slotStart,
    required DateTime slotEnd,
  }) async {
    final authUser = ref.read(authStateProvider).value;
    final profile = ref.read(currentUserProfileProvider).value;

    if (authUser == null) {
      state = AsyncError(
        StateError('Please sign in first.'),
        StackTrace.current,
      );
      return;
    }

    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(bookingRepositoryProvider).bookSlotAtomic(
            roomId: roomId,
            date: formatDateKey(day),
            slotStart: slotStart,
            slotEnd: slotEnd,
            userId: authUser.uid,
            userName: profile?.name.isNotEmpty == true
                ? profile!.name
                : (authUser.email ?? 'IBA Student'),
          );
    });
  }

  Future<void> cancelBooking(String bookingId) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(bookingRepositoryProvider).cancelBooking(bookingId);
    });
  }
}

final bookingActionProvider =
    AsyncNotifierProvider<BookingActionController, void>(
  BookingActionController.new,
);