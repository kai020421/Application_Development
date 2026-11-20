import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:project/bloc/favourites_cubit.dart';
import 'package:project/bloc/favourites_screen.dart';
import 'package:project/bloc/product.dart';
import 'package:project/bloc/product_bloc.dart';
import 'package:project/bloc/product_detail_screen.dart';
import 'package:project/bloc/product_event.dart';
import 'package:project/bloc/product_state.dart';
import 'package:project/bloc/product_card.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Product Explorer'),
        actions: [
          IconButton(
            icon: const Icon(Icons.favorite),
            onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => const FavouritesScreen()),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search products...',
                prefixIcon: Icon(Icons.search),
              ),
              onChanged: (q) =>
                  context.read<ProductBloc>().add(SearchProducts(q)),
            ),
          ),
          BlocBuilder<ProductBloc, ProductState>(
            builder: (context, state) {
              return SizedBox(
                height: 44,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    ChoiceChip(
                      label: const Text('All'),
                      selected: state.selectedCategory == null,
                      onSelected: (_) => context
                          .read<ProductBloc>()
                          .add(FilterByCategory('')),
                    ),
                    ...state.categories.map(
                      (c) => Padding(
                        padding: const EdgeInsets.only(left: 6),
                        child: ChoiceChip(
                          label: Text(c),
                          selected: state.selectedCategory == c,
                          onSelected: (_) => context
                              .read<ProductBloc>()
                              .add(FilterByCategory(c)),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          Expanded(
            child: BlocBuilder<ProductBloc, ProductState>(
              builder: (context, state) {
                if (state.loading) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (state.error != null) {
                  return Center(child: Text(state.error!));
                }
                return GridView.builder(
                  padding: const EdgeInsets.all(8),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 0.62,
                  ),
                  itemCount: state.visibleProducts.length,
                  itemBuilder: (context, i) =>
                      ProductCard(product: state.visibleProducts[i]),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}