import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:project/bloc/favourites_cubit.dart';
import 'package:project/bloc/home_screen.dart';
import 'package:project/bloc/product_bloc.dart';
import 'package:project/bloc/product_event.dart';

import 'mocks.dart';
void main() {
  testWidgets('shows mocked products; search and favorite work',
      (tester) async {
    await (() async {
      final mockApi = MockApiService();
      stubApi(mockApi);

      final productBloc = ProductBloc(mockApi)..add(LoadProducts());
      final favoritesCubit = FavouritesCubit();

      tester.view.physicalSize = const Size(400, 900);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        MultiBlocProvider(
          providers: [
            BlocProvider.value(value: productBloc),
            BlocProvider.value(value: favoritesCubit),
          ],
          child: const MaterialApp(home: HomeScreen()),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Mock Shirt'), findsOneWidget);
      expect(find.text('Mock Watch'), findsOneWidget);

      await tester.enterText(find.byType(TextField), 'watch');
      await tester.pumpAndSettle();
      expect(find.text('Mock Watch'), findsOneWidget);
      expect(find.text('Mock Shirt'), findsNothing);

      await tester.enterText(find.byType(TextField), '');
      await tester.pumpAndSettle();

      await tester.tap(find.byIcon(Icons.favorite_border).first);
      await tester.pump();
      expect(find.byIcon(Icons.favorite), findsNWidgets(2));
    })();
  });
}