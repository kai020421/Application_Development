import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/booking_model.dart';
import '../providers/roomback_providers.dart';

class HomeShell extends ConsumerStatefulWidget {
  const HomeShell({super.key});

  @override
  ConsumerState<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends ConsumerState<HomeShell> {
  int _tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    ref.listen<AsyncValue<void>>(bookingActionProvider, (prev, next) {
      next.whenOrNull(
        error: (err, _) {
          final msg = err is StateError ? err.message : err.toString();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg)),
          );
        },
        data: (_) {
          if (prev?.isLoading == true) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Booking updated.')),
            );
          }
        },
      );
    });

    final profile = ref.watch(currentUserProfileProvider).value;
    final isAdmin = profile?.isAdmin == true;

    final pages = [
      const _RoomGridTab(),
      const _MyBookingsTab(),
      if (isAdmin) const _AdminDashboardTab(),
    ];

    final destinations = [
      const NavigationDestination(icon: Icon(Icons.grid_view), label: 'Rooms'),
      const NavigationDestination(icon: Icon(Icons.bookmark), label: 'My Bookings'),
      if (isAdmin)
        const NavigationDestination(
          icon: Icon(Icons.admin_panel_settings),
          label: 'Admin',
        ),
    ];

    final safeIndex = _tabIndex.clamp(0, pages.length - 1);

    return Scaffold(
      appBar: AppBar(
        title: const Text('IBA RoomBook'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () => ref.read(authServiceProvider).signOut(),
          ),
        ],
      ),
      body: pages[safeIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: safeIndex,
        onDestinationSelected: (idx) => setState(() => _tabIndex = idx),
        destinations: destinations,
      ),
    );
  }
}

class _RoomGridTab extends ConsumerWidget {
  const _RoomGridTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final days = buildSevenDayWindow();
    final selectedDay = ref.watch(selectedDateProvider);
    final selectedKey = formatDateKey(selectedDay);
    final roomsAsync = ref.watch(roomsStreamProvider);
    final currentUid = ref.watch(authStateProvider).value?.uid;

    return Column(
      children: [
        SizedBox(
          height: 54,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: days.length,
            itemBuilder: (context, index) {
              final d = days[index];
              final isSelected = formatDateKey(d) == selectedKey;
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
                child: ChoiceChip(
                  label: Text('${d.month}/${d.day}'),
                  selected: isSelected,
                  onSelected: (_) =>
                      ref.read(selectedDateProvider.notifier).state = d,
                ),
              );
            },
          ),
        ),
        Expanded(
          child: roomsAsync.when(
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(child: Text('Error: $e')),
            data: (rooms) {
              final slots = buildDaySlots(selectedDay);
              return ListView.builder(
                itemCount: rooms.length,
                itemBuilder: (context, idx) {
                  final room = rooms[idx];
                  final bookingsAsync = ref.watch(
                    roomBookingsStreamProvider(
                      (roomId: room.id, date: selectedKey),
                    ),
                  );
                  final bookings = bookingsAsync.value ?? const <BookingModel>[];

                  return Card(
                    margin: const EdgeInsets.all(8),
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${room.name} • Floor ${room.floor} • Cap ${room.capacity}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 8),
                          Wrap(
                            spacing: 4,
                            runSpacing: 4,
                            children: List.generate(slots.length, (slotIdx) {
                              final (start, end) = slots[slotIdx];
                              BookingModel? activeMatch;
                              for (final b in bookings) {
                                if (b.isActiveEffective &&
                                    b.slotStart == start) {
                                  activeMatch = b;
                                  break;
                                }
                              }

                              Color cellColor = Colors.green;
                              if (activeMatch != null) {
                                cellColor = activeMatch.userId == currentUid
                                    ? Colors.blue
                                    : Colors.red;
                              }

                              return InkWell(
                                onTap: activeMatch == null
                                    ? () => ref
                                        .read(bookingActionProvider.notifier)
                                        .bookSlot(
                                          roomId: room.id,
                                          day: selectedDay,
                                          slotStart: start,
                                          slotEnd: end,
                                        )
                                    : null,
                                child: Container(
                                  width: 26,
                                  height: 26,
                                  alignment: Alignment.center,
                                  color: cellColor,
                                  child: Text(
                                    '${slotIdx + 1}',
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 10,
                                    ),
                                  ),
                                ),
                              );
                            }),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
      ],
    );
  }
}

class _MyBookingsTab extends ConsumerWidget {
  const _MyBookingsTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final bookingsAsync = ref.watch(myBookingsStreamProvider);
    final now = DateTime.now();

    return bookingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (bookings) {
        if (bookings.isEmpty) {
          return const Center(child: Text('No bookings yet.'));
        }
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final b = bookings[index];
            final canCancel =
                b.status == 'active' && now.isBefore(b.slotStart);

            return ListTile(
              title: Text('${b.roomId} (${b.date})'),
              subtitle: Text(
                '${b.slotStart.hour}:${b.slotStart.minute.toString().padLeft(2, '0')} '
                '– ${b.slotEnd.hour}:${b.slotEnd.minute.toString().padLeft(2, '0')} '
                '| Status: ${b.effectiveStatus}',
              ),
              trailing: canCancel
                  ? TextButton(
                      onPressed: () => ref
                          .read(bookingActionProvider.notifier)
                          .cancelBooking(b.id),
                      child: const Text('Cancel'),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}

class _AdminDashboardTab extends ConsumerWidget {
  const _AdminDashboardTab();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDay = ref.watch(selectedDateProvider);
    final dateKey = formatDateKey(selectedDay);
    final bookingsAsync = ref.watch(dateAllBookingsStreamProvider(dateKey));

    return bookingsAsync.when(
      loading: () => const Center(child: CircularProgressIndicator()),
      error: (e, _) => Center(child: Text('Error: $e')),
      data: (bookings) {
        return ListView.builder(
          itemCount: bookings.length,
          itemBuilder: (context, index) {
            final b = bookings[index];
            return ListTile(
              title: Text('${b.roomId} — ${b.userName}'),
              subtitle: Text('Date: ${b.date} | Status: ${b.effectiveStatus}'),
              trailing: b.status == 'active'
                  ? IconButton(
                      icon: const Icon(Icons.cancel),
                      onPressed: () => ref
                          .read(bookingActionProvider.notifier)
                          .cancelBooking(b.id),
                    )
                  : null,
            );
          },
        );
      },
    );
  }
}