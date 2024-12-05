// ignore_for_file: no_logic_in_create_state

import 'package:flutter/material.dart';
import 'package:shoppy/dbhelper.dart';
import 'package:shoppy/models/list_items.dart';
import 'package:shoppy/models/shopping_list.dart';

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

  @override
  Widget build(BuildContext context) {
    helper = Dbhelper();
    showData(shoppingList.id);

    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.white,
          backgroundColor: Colors.black87,
          title: Text(shoppingList.name),
        ),
        body: ListView.builder(
          itemCount: items.length,
          itemBuilder: (context, position) {
            return ListTile(
                onTap: () {},
                subtitle: Text(
                    'Quantity: ${items[position].quantity} - Note: ${items[position].note}'),
                title: Text(items[position].name),
                trailing: const IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: null,
                ));
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
