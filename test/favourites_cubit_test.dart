import 'package:flutter_test/flutter_test.dart';
import '../lib/bloc/favourites_cubit.dart';

void main() {
  group('FavoritesCubit', () {
    late FavouritesCubit cubit;
    setUp(() => cubit = FavouritesCubit());
    tearDown(() => cubit.close());

    test('toggle adds then removes an id', () {
      cubit.toggle(1);
      expect(cubit.state, {1});
      cubit.toggle(1);
      expect(cubit.state, <int>{});
    });
  });
}