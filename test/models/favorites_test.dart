import 'package:test/test.dart';
import 'package:favorites_app/models/favorites.dart';

void main() {
  group('Favorites List Unit Tests', () {

    test('Favorites list should be empty initially', () {
      var favoritesList = Favorites();
      expect(favoritesList.favorites.isEmpty, true);
    });

    test('A new item should be added to the list of favorites', () {
      var favoritesList = Favorites();
      var number = 35;
      favoritesList.add(number);
      expect(favoritesList.favorites.contains(number), true);
    });

    test('An item should be removed from the list of favorites', () {
      var favoritesList = Favorites();
      var number = 20;
      favoritesList.add(number);
      expect(favoritesList.favorites.contains(number), true);
      favoritesList.remove(number);
      expect(favoritesList.favorites.contains(number), false);
    });

    test('Multiple items should be added to the list of favorites', () {
      var favoritesList = Favorites();
      var numbers = [23,43,2,98];
      for (var number in numbers) {
        favoritesList.add(number);
      }
      expect(favoritesList.favorites, [23,43,2,98]);
    });

    test('Removing one item should not remove other items from favorites list', () {
      var favoritesList = Favorites();
      var numbers = [34,54,65,22];
      for (var number in numbers) {
        favoritesList.add(number);
      }
      favoritesList.remove(65);
      expect(favoritesList.favorites, [34,54,22]);
    });

    test('Should handle removal of non-existent item', () {
      var favoritesList = Favorites();
      var number = 50;
      favoritesList.remove(number);
      expect(favoritesList.favorites.isEmpty, true);
    });
  });
}