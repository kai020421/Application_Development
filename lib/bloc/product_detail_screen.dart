import 'package:flutter/material.dart';
import 'package:project/bloc/product.dart';

class ProductDetailScreen extends StatelessWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(product.title)),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
          Center(
              child: Image.network(product.image, height: 220)),
          const SizedBox(height: 16),
          Text(product.title,
              style: Theme.of(context).textTheme.titleLarge),
          Text('\$${product.price}',
              style: const TextStyle(
                  fontSize: 20, color: Colors.green)),
          Row(children: [
            const Icon(Icons.star, color: Colors.amber, size: 18),
            Text(' ${product.rating}'),
          ]),
          const SizedBox(height: 12),
          Text(product.description),
        ]),
      ),
    );
  }
}