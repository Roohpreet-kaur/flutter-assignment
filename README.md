# Favorites App

A Flutter application demonstrating automated testing at unit, widget, and integration levels.

## Testing

The project includes automated tests covering the Favorites functionality and user flows.

### Unit Tests

Unit tests cover the `Favorites` model and its core behavior:

- Verify the favorites list is empty initially
- Add a favorite item
- Remove a favorite item
- Add multiple favorite items
- Remove one item while keeping other favorites
- Safely handle removal of a non-existent item

### Widget Tests

Widget tests cover the Home and Favorites screens, including:

- Verify HomePage UI elements
- Verify favorite items are displayed
- Scroll through the item list
- Add and remove favorites
- Verify favorite and unfavorite icon states
- Verify SnackBar messages
- Navigate from HomePage to FavoritesPage
- Verify the empty Favorites state
- Remove favorite items
- Verify removing one item does not remove other items

### Integration Tests

Integration tests cover complete user flows across the application.

The integration test suite includes:

- Add an item and view it in Favorites
- Add multiple items and view them in Favorites
- Add and remove a favorite item
- Favorite and unfavorite an item from the HomePage
- Remove one favorite while keeping other favorites
- Scroll to the last item, add it to Favorites, and verify it
- Verify the Favorites page is empty when no items are favorited

These scenarios go beyond the basic integration flow from the Flutter testing codelab and cover additional user journeys and edge cases.

## Test Structure

```text
test/
├── models/
│   └── favorites_test.dart
└── widgets/
    ├── home_test.dart
    └── favorites_test.dart

integration_test/
└── app_test.dart