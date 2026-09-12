import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:flutter/material.dart';
import 'package:favorites_app/models/favorites.dart';
import 'package:favorites_app/screens/favorites.dart';

Widget createFavoritesScreen([Favorites? favorites]) =>
    ChangeNotifierProvider<Favorites>(
      create: (context) => favorites ?? Favorites(),
      child: const MaterialApp(
        home: FavoritesPage(),
      ),
    );

void main() {
  group('Favorites Page Widget Tests', () {
    testWidgets('Favorites page should display correct title and empty list', (tester) async {
      await tester.pumpWidget(createFavoritesScreen());
      expect(find.text('Favorites'), findsOneWidget);
      expect(find.byType(FavoriteItemTile), findsNothing);
    });

    testWidgets('Favorites page should display added favorite items', (tester) async {
      final favorites = Favorites();
      favorites.add(10);
      favorites.add(20);

      await tester.pumpWidget(createFavoritesScreen(favorites));

      expect(find.byType(FavoriteItemTile), findsNWidgets(2));
      expect(find.text('Item 10'), findsOneWidget);
      expect(find.text('Item 20'), findsOneWidget);
    });

    testWidgets('Favorites page should remove an item from favorites', (tester) async {
      final favorites = Favorites();
      favorites.add(10);

      await tester.pumpWidget(createFavoritesScreen(favorites));

      expect(find.text('Item 10'), findsOneWidget);
      await tester.tap(find.byKey(const Key('remove_icon_10')));
      await tester.pumpAndSettle();
      expect(find.text('Item 10'), findsNothing);
      });

    testWidgets('Favorites page should show SnackBar when item is removed', (tester) async {
      final favorites = Favorites();
      favorites.add(10);

      await tester.pumpWidget(createFavoritesScreen(favorites));

      await tester.tap(find.byKey(const Key('remove_icon_10')));
      await tester.pumpAndSettle();
      expect(find.text('Removed from favorites.'), findsOneWidget);
    });

    testWidgets('Each favorite item should have a remove button', (tester) async {
      final favorites = Favorites();
      favorites.add(10);
      favorites.add(20);

      await tester.pumpWidget(createFavoritesScreen(favorites));

      expect(find.byKey(const Key('remove_icon_10')), findsOneWidget);
      expect(find.byKey(const Key('remove_icon_20')), findsOneWidget);
    });

    testWidgets('Removing one item should not remove other items from favorites list', (tester) async {
      final favorites = Favorites();
      favorites.add(10);
      favorites.add(20);

      await tester.pumpWidget(createFavoritesScreen(favorites));   
      
      await tester.tap(find.byKey(const Key('remove_icon_10')));
      await tester.pumpAndSettle();
      expect(find.text('Item 10'), findsNothing);
      expect(find.text('Item 20'), findsOneWidget);
      expect(find.byKey(const Key('remove_icon_20')), findsOneWidget);
      });
  });
}