import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:itemtracker/custom_methods/reusable_methods.dart';
import 'package:itemtracker/models/item_model.dart';
import 'package:itemtracker/providers/item_provider.dart';
import 'package:itemtracker/screens/Item_Input.dart';
import 'package:provider/provider.dart';

class ItemList extends StatefulWidget {
  const ItemList({super.key});

  @override
  State<ItemList> createState() => _ItemListState();
}

class _ItemListState extends State<ItemList> {
  ReusableMethods rm = ReusableMethods();
  @override
  Widget build(BuildContext context) {
    return Consumer<ItemProvider>(
      builder: (context, itemprovider, child) {
        return Scaffold(
          appBar: AppBar(
            title: const Text('Item_Tracker'),
            actions: [
              IconButton(
                  onPressed: () {
                    itemprovider.toggletheme();
                  },
                  icon: const Icon(Icons.brightness_6)),
              const SizedBox(
                width: 40,
              )
            ],
          ),
          body: itemprovider.items.isNotEmpty
              ? ListView.builder(
                  itemCount: itemprovider.items.length,
                  itemBuilder: (context, index) {
                    ItemModel im = itemprovider.items[index];
                    return Padding(
                      padding: const EdgeInsets.all(22.0),
                      child: Builder(builder: (context) {
                        return InkWell(
                          onTap: () {
                            // Get the RenderBox of the current card
                            RenderBox box =
                                context.findRenderObject() as RenderBox;
                            final size = box.size;
                            final position = box.localToGlobal(Offset.zero);
                            print(
                                'Tapped Item Position: $position, Size: $size');
                            rm.dipalyAlertdialog(
                                context,
                                'Calculated  position and size of the card',
                                'Tapped Item Position: $position, Size: $size');
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => ItemInput(
                                      im: im,
                                      index: index,
                                    )));
                          },
                          child: Card(
                              elevation: 3,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    im.name!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    im.description!,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16,
                                    ),
                                  ),
                                  IconButton(
                                      onPressed: () {
                                        itemprovider.removeitem(index);
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(SnackBar(
                                          content: Row(
                                            children: [
                                              const Text(
                                                  'Item deleted Successfully'),
                                              const SizedBox(
                                                width: 50,
                                              ),
                                              ElevatedButton(
                                                  onPressed: () {
                                                    itemprovider.addItem(im);
                                                  },
                                                  child: const Text('undo'))
                                            ],
                                          ),
                                        ));
                                      },
                                      icon: const Icon(Icons.delete))
                                ],
                              )),
                        );
                      }),
                    );
                  },
                )
              : const Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'You Dont have any items..please add some',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              showModalBottomSheet(
                  useSafeArea: true,
                  context: context,
                  isScrollControlled: true,
                  builder: (context) {
                    return const ItemInput();
                  });
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }
}
