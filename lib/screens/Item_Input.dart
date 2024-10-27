import 'package:flutter/material.dart';
import 'package:itemtracker/custom_methods/reusable_methods.dart';
import 'package:itemtracker/models/item_model.dart';
import 'package:itemtracker/providers/item_provider.dart';
import 'package:provider/provider.dart';

class ItemInput extends StatefulWidget {
  const ItemInput({super.key, this.im, this.index});

  final ItemModel? im;
  final int? index;

  @override
  State<ItemInput> createState() => _ItemInputState();
}

class _ItemInputState extends State<ItemInput> {
  ReusableMethods rm = ReusableMethods();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  TextEditingController name = TextEditingController();

  TextEditingController descript = TextEditingController();

  @override
  void initState() {
    super.initState();
    if (widget.im != null) {
      name.text = widget.im!.name!;
      descript.text = widget.im!.description!;
      print('update item button pressed');
    } else {
      print('add item button pressed');
    }
  }

  void submitAction(BuildContext context) {
    if (formkey.currentState!.validate()) {
      formkey.currentState!.save();
      if (widget.im == null) {
        Provider.of<ItemProvider>(context, listen: false)
            .addItem(ItemModel(name: name.text, description: descript.text));
        rm.displaySnackbar(context, 'Item added successfully');
      } else {
        Provider.of<ItemProvider>(context, listen: false).updateitem(
            widget.index!,
            ItemModel(name: name.text, description: descript.text));
        rm.displaySnackbar(context, 'Item Updated Successfully');
      }
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Form(
        key: formkey,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(30.0),
              child: TextFormField(
                  controller: name,
                  decoration: const InputDecoration(hintText: 'Name'),
                  onSaved: (newValue) {
                    name.text = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid name';
                    }
                    return null;
                  }),
            ),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: TextFormField(
                  controller: descript,
                  decoration: const InputDecoration(hintText: 'Description'),
                  onSaved: (newValue) {
                    descript.text = newValue!;
                  },
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a valid description';
                    }
                    return null;
                  }),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                    onPressed: () {
                      submitAction(context);
                    },
                    child: widget.im != null
                        ? const Text('Update')
                        : const Text('submit')),
                const SizedBox(
                  width: 10,
                ),
                ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('cancel')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
