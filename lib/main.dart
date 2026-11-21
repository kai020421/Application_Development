import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'firebase_options.dart';
import 'assignment_4/providers/roomback_providers.dart';
import 'assignment_4/screens/auth_screen.dart';
import 'assignment_4/screens/home_show.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: IbaRoomBookApp()));
}

class IbaRoomBookApp extends ConsumerWidget {
  const IbaRoomBookApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authStateProvider);

    return MaterialApp(
      title: 'IBA RoomBook',
      debugShowCheckedModeBanner: false,
      home: authState.when(
        loading: () => const Scaffold(
          body: Center(child: CircularProgressIndicator()),
        ),
        error: (e, _) => Scaffold(
          body: Center(child: Text('Auth error: $e')),
        ),
        data: (user) => user == null ? const AuthScreen() : const HomeShell(),
      ),
    );
  }
}