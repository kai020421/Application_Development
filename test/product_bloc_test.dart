import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:project/bloc/product_bloc.dart';
import 'package:project/bloc/product_event.dart';
import 'package:project/bloc/product_state.dart';
import 'mocks.dart';

void main() {
  group('ProductBloc', () {
    late MockApiService mockApi;
    setUp(() {
      mockApi = MockApiService();
      stubApi(mockApi);
    });

    test('LoadProductsEvent loads 2 mocked products', () async {
      final bloc = ProductBloc(mockApi);
      bloc.add(LoadProducts());
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<ProductState>(
            (s) => !s.loading && s.allProducts.length == 2)),
      );
      verify(() => mockApi.fetchAllProducts()).called(1);
      await bloc.close();
    });

    test('FilterByCategoryEvent narrows visibleProducts', () async {
      final bloc = ProductBloc(mockApi);
      bloc.add(LoadProducts());
      await expectLater(bloc.stream,
          emitsThrough(predicate<ProductState>((s) => !s.loading)));

      bloc.add(FilterByCategory('electronics'));
      await expectLater(
        bloc.stream,
        emitsThrough(predicate<ProductState>((s) =>
            s.visibleProducts.length == 1 &&
            s.visibleProducts.every((p) => p.category == 'electronics'))),
      );
      await bloc.close();
    });
  });
}