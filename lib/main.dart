import 'package:flutter/material.dart';
import 'package:shoppy/dbhelper.dart';
import 'package:shoppy/models/list_items.dart';
import 'package:shoppy/models/shopping_list.dart';

void main() {
  runApp(const Shoppy());
}

class Shoppy extends StatelessWidget {
  const Shoppy({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home: Scaffold(
      appBar: AppBar(
        title: const Text('Shoppy'),
      ),
      body: const ShopList(),
    ));
  }
}

class ShopList extends StatefulWidget {
  const ShopList({super.key});

  @override
  State<ShopList> createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  Dbhelper helper = Dbhelper();

  @override
  Widget build(BuildContext context) {
    showData();

    return Container();
  }

  Future showData() async {
    await helper.openDb();

    ShoppingList list = ShoppingList(0, 'Kitchen', 3);
    int listId = await helper.insertList(list);

    ListItems item = ListItems(0, listId, 'Chicken', 'Cooking item', '35 kg');
    int itemId = await helper.insertItem(item);

    print('List Id: ' + listId.toString());
    print('Item Id: ' + itemId.toString());
  }
}
