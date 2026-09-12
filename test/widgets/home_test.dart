import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'package:favorites_app/models/favorites.dart';
import 'package:favorites_app/screens/favorites.dart';
import 'package:favorites_app/screens/home.dart';

Widget createHomeScreen() => ChangeNotifierProvider<Favorites>(
  create: (context) => Favorites(),
  child: MaterialApp.router(
    routerConfig: GoRouter(
      initialLocation: HomePage.routeName,
      routes: [
        GoRoute(
          path: HomePage.routeName,
          builder: (context, state) => const HomePage(),
          routes: [
            GoRoute(
              path: FavoritesPage.routeName,
              builder: (context, state) => const FavoritesPage(),
            ),
          ],
        ),
      ],
    ),
  ),
);

void main() {
  group('Home Page Widget Tests', () {
    testWidgets('Home page should display a ListView', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.byType(ListView), findsOneWidget);
    });

    testWidgets('Home page should display correct title and favorite button', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Testing Sample'), findsOneWidget);
      expect(find.text('Favorites'), findsOneWidget);

      final favoritesButton = find.byType(TextButton);

      expect(favoritesButton, findsOneWidget);

      final favoritesIcon = find.descendant(
        of: favoritesButton,
        matching: find.byIcon(Icons.favorite_border),
            );

      expect(favoritesIcon, findsOneWidget);
    });

    testWidgets('Home page should display Item 0', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      expect(find.text('Item 0'), findsOneWidget);  
    });

    testWidgets('Home page should scroll to the last item', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      await tester.fling(find.byType(ListView), const Offset(0, -5000), 5000);
      await tester.pumpAndSettle();
      expect(find.text('Item 99'), findsOneWidget);
    });

    testWidgets('Home page should add and remove an item from favorites', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      final item0FavoriteButton = find.byKey(const Key('icon_0'));
      expect(item0FavoriteButton, findsOneWidget);

      await tester.tap(item0FavoriteButton);
      await tester.pumpAndSettle();

      expect(find.byIcon(Icons.favorite), findsOneWidget);
      expect(find.text('Added to favorites.'), findsOneWidget);

      await tester.tap(item0FavoriteButton);
      await tester.pumpAndSettle();

      expect(
        find.descendant(
          of: item0FavoriteButton,
          matching: find.byIcon(Icons.favorite_border),
        ),
        findsOneWidget,
      );
      expect(find.text('Removed from favorites.'), findsOneWidget);
    });

    testWidgets('Home page should navigate to favorites page', (tester) async {
      await tester.pumpWidget(createHomeScreen());
      final favoritesButton = find.byType(TextButton);
      expect(favoritesButton, findsOneWidget);

      await tester.tap(favoritesButton);
      await tester.pumpAndSettle();

      expect(find.text('Favorites'), findsOneWidget);
      expect(find.text('Testing Sample'), findsNothing);
    });
  });
}