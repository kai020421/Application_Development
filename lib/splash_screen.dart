import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_storage/home_screen.dart';
import 'package:offline_storage/product_bloc.dart';
import 'package:offline_storage/product_state.dart';

class SplashScreen extends StatelessWidget {
 const SplashScreen({super.key});
 @override
 Widget build(BuildContext context) {
 return Scaffold(
 body: BlocListener<ProductBloc, ProductState>(
 listener: (context, state) {
 if (!state.loading && state.allProducts.isNotEmpty) {
 Navigator.pushReplacement(context,
 MaterialPageRoute(builder: (_) => const HomeScreen()));
 }
 },
 child: const Center(child: CircularProgressIndicator()),
 ),
 );
 }
}
