import 'package:hive/hive.dart';
part 'item_model.g.dart';

@HiveType(typeId: 1)
class ItemModel {
  @HiveField(0)
  String? name;
  @HiveField(1)
  String? description;

  ItemModel({required this.name, required this.description});

  ItemModel fromMap(Map<String, String> map) {
    return ItemModel(
      name: map['name'],
      description: map['description'],
    );
  }

  Map toMap() {
    return {
      'name': name,
      'description': description,
    };
  }
}
