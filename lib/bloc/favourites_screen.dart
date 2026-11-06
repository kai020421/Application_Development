import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/favourites_cubit.dart';
import 'package:project/bloc/product_bloc.dart';
import 'package:project/bloc/product_detail_screen.dart';
import 'package:project/bloc/product_state.dart';

class FavouritesScreen extends StatelessWidget {
  const FavouritesScreen({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Favorites')),
      body: BlocBuilder<ProductBloc, ProductState>(
          builder: (context, productState) {
        return BlocBuilder<FavouritesCubit, Set<int>>(
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