import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/bloc/favourites_cubit.dart';
import 'package:project/bloc/product.dart';
import 'package:project/bloc/product_card.dart';

void main() {
  testWidgets('ProductCard matches its golden file', (tester) async {
    final product = Product(
      id: 1,
      title: 'Mock Shirt',
      description: '',
      price: 9.99,
      category: 'clothing',
      image: '',
      rating: 4.0,
    );

    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider(
          create: (_) => FavouritesCubit(),
          child: Scaffold(body: ProductCard(product: product)),
        ),
      ),
    );

    await expectLater(
      find.byType(ProductCard),
      matchesGoldenFile('goldens/product_card.png'),
    );
  });
}