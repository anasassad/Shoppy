// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:shoppy/dbhelper.dart';
import 'package:shoppy/models/list_items.dart';
import 'package:shoppy/models/shopping_list.dart';
import 'package:shoppy/ui/list_item_dialog.dart';

class ItemsScreen extends StatefulWidget {
  final ShoppingList shoppingList;

  const ItemsScreen(this.shoppingList, {super.key});

  @override
  State<ItemsScreen> createState() => _ItemsScreenState(shoppingList);
}

class _ItemsScreenState extends State<ItemsScreen> {
  late Dbhelper helper;
  ShoppingList shoppingList;
  List<ListItems> items = List.empty();

  _ItemsScreenState(this.shoppingList);

  late ListItemDialog dialog;

  @override
  void initState() {
    dialog = ListItemDialog();
    helper = Dbhelper();
    super.initState();
    showData(shoppingList.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black87,
          title: Text(shoppingList.name),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.greenAccent,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => dialog.buildDialog(
                      context,
                      ListItems(0, shoppingList.id, '', '', ''),
                      true)).then((_) => showData(shoppingList.id));
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return Dismissible(
                key: Key(items[position].id.toString()),
                onDismissed: (direction) {
                  String itemName = items[position].name;
                  helper.deleteItem(items[position]);

                  setState(() {
                    items.removeAt(position);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$itemName deleted')));
                },
                child: ListTile(
                    onTap: () {},
                    subtitle: Text(
                        'Quantity: ${items[position].quantity} - Note: ${items[position].note}'),
                    title: Text(items[position].name),
                    trailing: IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () {
                          showDialog(
                                  context: context,
                                  builder: (BuildContext context) =>
                                      dialog.buildDialog(
                                          context, items[position], false))
                              .then((_) => showData(shoppingList.id));
                        })));
          },
        ));
  }

  Future showData(int idList) async {
    await helper.openDb();

    items = await helper.getItems(idList);

    setState(() {
      items = items;
    });
  }
}
