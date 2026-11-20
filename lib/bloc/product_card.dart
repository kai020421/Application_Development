import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'product.dart';
import 'product_detail_screen.dart';
import 'favourites_cubit.dart';

class ProductCard extends StatelessWidget {
  final Product product;
  const ProductCard({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => ProductDetailScreen(product: product),
        ),
      ),
      child: Card(
        child: Column(
          children: [
            Expanded(
              child: product.image.isEmpty
                  ? const Icon(Icons.image)
                  : Image.network(
                      product.image,
                      fit: BoxFit.contain,
                      errorBuilder: (_, __, ___) => const Icon(Icons.image),
                    ),
            ),
            Text(
              product.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text('\$${product.price}'),
            BlocBuilder<FavouritesCubit, Set<int>>(
              builder: (context, favs) {
                final isFav = favs.contains(product.id);
                return IconButton(
                  icon: Icon(
                    isFav ? Icons.favorite : Icons.favorite_border,
                    color: isFav ? Colors.red : null,
                  ),
                  onPressed: () =>
                      context.read<FavouritesCubit>().toggle(product.id),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}