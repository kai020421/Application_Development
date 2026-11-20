import 'package:mocktail/mocktail.dart';
import 'package:project/bloc/api_service.dart';
import 'package:project/bloc/product.dart';

class MockApiService extends Mock implements ApiService {}

final fakeProducts = [
  Product(id: 1, title: 'Mock Shirt', description: '', price: 9.99,
      category: 'clothing', image: '', rating: 4.0),
  Product(id: 2, title: 'Mock Watch', description: '', price: 49.99,
      category: 'electronics', image: '', rating: 4.5),
];

void stubApi(MockApiService m) {
  when(() => m.fetchAllProducts()).thenAnswer((_) async => fakeProducts);
  when(() => m.fetchCategories())
      .thenAnswer((_) async => ['clothing', 'electronics']);
}