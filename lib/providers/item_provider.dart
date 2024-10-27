import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itemtracker/models/item_model.dart';

class ItemProvider extends ChangeNotifier {
  var _items = [];
  ThemeMode _themeMode = ThemeMode.light;
  late Box itemsbox;

  List get items => _items;
  ThemeMode get thememode => _themeMode;

  void toggletheme() {
    if (_themeMode == ThemeMode.light) {
      _themeMode = ThemeMode.dark;
    } else {
      _themeMode = ThemeMode.light;
    }
    notifyListeners();
  }

  ItemProvider() {
    getItems();
  }

// ignore: non_constant_identifier_names
  void getItems() async {
    itemsbox = Hive.box<ItemModel>('itembox');
    _items = itemsbox.values.toList();
    print(_items.length);
    notifyListeners();
  }

  void addItem(ItemModel m) {
    itemsbox.add(m);
    _items = itemsbox.values.toList();
    print(_items.length);
    notifyListeners();
  }

  void removeitem(int index) {
    itemsbox.deleteAt(index);
    _items = itemsbox.values.toList();
    notifyListeners();
  }

  void updateitem(int i, ItemModel m) {
    itemsbox.putAt(i, m);
    _items = itemsbox.values.toList();
    notifyListeners();
  }
}
