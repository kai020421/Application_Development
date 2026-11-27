import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:offline_storage/favorites_cubit.dart';
import 'package:offline_storage/product_bloc.dart';
import 'package:offline_storage/product_state.dart';
import 'package:offline_storage/products_detail_screen.dart';

class FavoritesScreen extends StatelessWidget {
 const FavoritesScreen({super.key});
 @override
 Widget build(BuildContext context) {
 return Scaffold(
appBar: AppBar(title: const Text('Favorites')),
 body: BlocBuilder<ProductBloc, ProductState>(
 builder: (context, productState) {
 return BlocBuilder<FavoritesCubit, Set<int>>(
 builder: (context, favIds) {
 final favs = productState.allProducts
 .where((p) => favIds.contains(p.id))
 .toList();
 if (favs.isEmpty) {
 return const Center(child: Text('No favorites yet'));
 }
 return ListView.builder(
 itemCount: favs.length,
 itemBuilder: (context, i) {
 final product = favs[i];
 return ListTile(
 leading: Image.network(product.image, width: 40),
 title: Text(product.title,
 maxLines: 1, overflow: TextOverflow.ellipsis),
 subtitle: Text('\$${product.price}'),
 onTap: () => Navigator.push(
 context,
 MaterialPageRoute(
 builder: (_) =>
 ProductDetailScreen(product: product))),
 );
 },
 );
 });
 }),
 );
 }
}
