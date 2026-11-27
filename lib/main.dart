import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_storage/api_service.dart';
import 'package:offline_storage/favorites_cubit.dart';
import 'package:offline_storage/product_bloc.dart';
import 'package:offline_storage/product_event.dart';
import 'package:offline_storage/splash_screen.dart';

void main() => runApp(const MyApp());
class MyApp extends StatelessWidget {
 const MyApp({super.key});
 @override
Widget build(BuildContext context) {
 return MultiBlocProvider(
 providers: [
 BlocProvider(
 create: (_) => ProductBloc(ApiService())..add(LoadProducts()),
 ),
 BlocProvider(create: (_) => FavoritesCubit()),
 ],
 child: const MaterialApp(home: SplashScreen()),
 );
 }
}