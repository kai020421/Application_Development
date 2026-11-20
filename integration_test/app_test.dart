import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:project/bloc/product_card.dart';
import 'package:project/bloc/product_detail_screen.dart';
import 'package:project/main.dart' as app;
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('search, filter, favorite, and find it again', (tester) async {
    app.main();
    await tester.pumpAndSettle(); // Splash -> Home

    await tester.enterText(find.byType(TextField), 'shirt');
    await tester.pumpAndSettle();
    expect(find.byType(ProductCard), findsWidgets);

    await tester.enterText(find.byType(TextField), '');
    await tester.pumpAndSettle();

    await tester.tap(find.text('electronics'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(ProductCard).first);
    await tester.pumpAndSettle();
    expect(find.byType(ProductDetailScreen), findsOneWidget);

    await tester.pageBack();
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.favorite_border).first);
    await tester.pumpAndSettle();

    
    await tester.tap(find.byIcon(Icons.favorite).first);
    await tester.pumpAndSettle();
    expect(find.byType(ListTile), findsWidgets);
  });
}