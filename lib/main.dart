import 'package:flutter/material.dart';
import 'package:shoppy/dbhelper.dart';
import 'package:shoppy/models/shopping_list.dart';
import 'package:shoppy/ui/items_screen.dart';
import 'package:shoppy/ui/shopping_list_dialog.dart';

void main() {
  runApp(const Shoppy());
}

class Shoppy extends StatelessWidget {
  const Shoppy({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(home: ShopList());
  }
}

class ShopList extends StatefulWidget {
  const ShopList({super.key});

  @override
  State<ShopList> createState() => _ShopListState();
}

class _ShopListState extends State<ShopList> {
  List<ShoppingList> shoppingList = List.empty();
  Dbhelper helper = Dbhelper();

  late ShoppingListDialog dialog;

  @override
  void initState() {
    dialog = ShoppingListDialog();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    showData();

    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black87,
          title: const Text(
            'Shoppy',
            style: TextStyle(color: Colors.white),
          ),
        ),
        floatingActionButton: FloatingActionButton(
            backgroundColor: Colors.greenAccent,
            onPressed: () {
              showDialog(
                  context: context,
                  builder: (BuildContext context) => dialog.buildDialog(
                      context, ShoppingList(0, '', 0), true));
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: ListView.builder(
          itemCount: shoppingList.length,
          itemBuilder: (context, position) {
            return ListTile(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            ItemsScreen(shoppingList[position])));
              },
              trailing: IconButton(
                  onPressed: () {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) => dialog.buildDialog(
                            context, shoppingList[position], false));
                  },
                  icon: const Icon(Icons.edit)),
              leading: CircleAvatar(
                child: Text(shoppingList[position].priority.toString()),
              ),
              title: Text(shoppingList[position].name),
            );
          },
        ));
  }

  Future showData() async {
    await helper.openDb();

    shoppingList = await helper.getLists();

    setState(() {
      shoppingList = shoppingList;
    });
  }
}
