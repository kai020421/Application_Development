import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:project/riverpod/home_screen.dart';
import 'package:project/riverpod/providers.dart';

class SplashScreen extends ConsumerWidget {
 const SplashScreen({super.key});
 
 @override
 Widget build(
 BuildContext context, WidgetRef ref) {
 ref.listen(productsProvider, (prev, next) {
 if (next.hasValue || next.hasError) {
 Navigator.pushReplacement(
 context,
 MaterialPageRoute(
 builder: (_) => const HomeScreen(),
 ),
 );
 }
 });
 ref.watch(productsProvider);
 return const Scaffold(
  body: Center(
 child: CircularProgressIndicator(),
 ),
 );
 }
}