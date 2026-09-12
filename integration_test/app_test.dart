import 'package:favorites_app/screens/favorites.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:favorites_app/main.dart';

Future<void> resetToHome(WidgetTester tester) async {
  await tester.pumpWidget(const FavoritesApp());
  await tester.pump();

  if (find.text('Testing Sample').evaluate().isEmpty) {
    await tester.pageBack();
    await tester.pumpAndSettle();
  }
}

Future<void> openFavorites(WidgetTester tester) async {
  await tester.tap(find.text('Favorites'));
  await tester.pumpAndSettle();
}

void main() {
  group('Favorites App Integration Tests', () {
    testWidgets('User can add an item and view it in favorites', (tester) async {
      await resetToHome(tester);

      expect(find.text('Testing Sample'), findsOneWidget);

      await tester.tap(find.byKey(const Key('icon_0')));
      await tester.pumpAndSettle();
      
      expect(find.text('Added to favorites.'), findsOneWidget);

      await openFavorites(tester);

      expect(find.text('Testing Sample'), findsNothing);
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.byKey(const Key('favorites_text_0')),findsOneWidget);
    });

    testWidgets('User can add multiple items and view them in favorites', (tester) async {
      await resetToHome(tester);

      await tester.tap(find.byKey(const Key('icon_2')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('icon_5')));
      await tester.pumpAndSettle();

      await openFavorites(tester);

      expect(find.byKey(const Key('favorites_text_2')), findsOneWidget);
      expect(find.byKey(const Key('favorites_text_5')), findsOneWidget);
    });

    testWidgets('User can remove a favorite item after adding', (tester) async {
      await resetToHome(tester);

      await tester.tap(find.byKey(const Key('icon_1')));
      await tester.pumpAndSettle();

      await openFavorites(tester);

      expect(find.byKey(const Key('favorites_text_1')), findsOneWidget);

      await tester.tap(find.byKey(ValueKey('remove_icon_1')));
      await tester.pumpAndSettle(const Duration(seconds: 1));

      expect(find.text('Removed from favorites.'), findsOneWidget);
      expect(find.byKey(const Key('favorites_text_1')), findsNothing);
    });

    testWidgets('User can favorite and unfavorite an item from homepage', (tester) async {
      await resetToHome(tester);

      final favoriteButton = find.byKey(const Key('icon_1'));

      expect(find.descendant(of: favoriteButton, matching: find.byIcon(Icons.favorite_border),), findsOneWidget);

      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      expect(find.descendant(of: favoriteButton, matching: find.byIcon(Icons.favorite),), findsOneWidget);

      await tester.tap(favoriteButton);
      await tester.pumpAndSettle();

      expect(find.descendant(of: favoriteButton, matching: find.byIcon(Icons.favorite_border),), findsOneWidget);
      
      await openFavorites(tester);

      expect(find.byKey(const Key('favorites_text_1')), findsNothing);
    });

    testWidgets('Removing one favorite should not remove other favorites', (tester) async {
      await resetToHome(tester);

      await tester.tap(find.byKey(const Key('icon_1')));
      await tester.pumpAndSettle();

      await tester.tap(find.byKey(const Key('icon_2')));
      await tester.pumpAndSettle();

      await openFavorites(tester);

      expect(find.byKey(const Key('favorites_text_1')), findsOneWidget);
      expect(find.byKey(const Key('favorites_text_2')), findsOneWidget);

      await tester.tap(find.byKey(ValueKey('remove_icon_1')));
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('favorites_text_1')), findsNothing);
      expect(find.byKey(const Key('favorites_text_2')), findsOneWidget);
    });

    testWidgets('User can scroll to the last item, add and view it in favorites', (tester) async {
      await resetToHome(tester);

      await tester.fling(find.byType(ListView), const Offset(0, -5000), 8000);
      await tester.pumpAndSettle();

      expect(find.byKey(const Key('icon_99')), findsOneWidget);
      await tester.tap(find.byKey(const Key('icon_99')));
      await tester.pumpAndSettle();

      expect(find.descendant(
        of: find.byKey(const Key('icon_99')), 
        matching: find.byIcon(Icons.favorite),),
        findsOneWidget,
      );

      await openFavorites(tester);

      expect(find.byKey(const Key('favorites_text_99')), findsOneWidget);
    });

    testWidgets('Favorites page should be empty when no item favorited', (tester) async{
      await resetToHome(tester);

      await openFavorites(tester);

      expect(find.text('Favorites'), findsOneWidget);
      expect(find.byType(FavoriteItemTile), findsNothing);
    });
  });
}