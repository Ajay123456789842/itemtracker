// test/item_provider_test.dart
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:hive_test/hive_test.dart';
import 'package:itemtracker/models/item_model.dart';
import 'package:itemtracker/providers/item_provider.dart';

void main() {
  // Initialize Hive
  setUpAll(() async {
    await setUpTestHive(); // Sets up temporary Hive directory for tests
    Hive.registerAdapter(ItemModelAdapter());
  });

  tearDown(() async {
    await Hive.close(); // Clean up Hive after each test
  });

  group('ItemProvider Hive Tests', () {
    test('Adding an item to Hive', () async {
      var box = await Hive.openBox<ItemModel>('itembox');
      var itemProvider = ItemProvider();

      final item = ItemModel(name: 'Sample Item', description: 'A test item');
      itemProvider.addItem(item);

      expect(box.length, 1);
      expect(box.values.first.name, 'Sample Item');
    });

    test('Editing an item in Hive', () async {
      var box = await Hive.openBox<ItemModel>('itembox');
      var itemProvider = ItemProvider();

      final item =
          ItemModel(name: 'Initial Item', description: 'First description');
      await box.add(item);

      itemProvider.updateitem(0,
          ItemModel(name: 'Updated Item', description: 'Updated description'));

      expect(box.getAt(0)?.name, 'Updated Item');
      expect(box.getAt(0)?.description, 'Updated description');
    });

    test('Removing an item from Hive', () async {
      var box = await Hive.openBox<ItemModel>('itembox');
      var itemProvider = ItemProvider();

      final item = (ItemModel(name: 'Sample Item', description: 'A test item'));
      await box.add(item);

      itemProvider.removeitem(0);

      expect(box.isNotEmpty, true);
    });
  });
}
