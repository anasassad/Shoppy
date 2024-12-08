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
    return MaterialApp(
        theme: ThemeData(
          inputDecorationTheme: const InputDecorationTheme(
            filled: true,
            fillColor: Colors.white70,
            border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(12))),
            contentPadding: EdgeInsets.all(10),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(12)),
              borderSide: BorderSide(color: Colors.blueGrey, width: 1.5),
            ),
          ),
        ),
        home: const ShopList());
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

    showData();
  }

  @override
  Widget build(BuildContext context) {
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
                          context, ShoppingList(0, '', 0), true))
                  .then((_) => showData());
            },
            child: const Icon(
              Icons.add,
              color: Colors.white,
            )),
        body: ListView.builder(
          itemCount: shoppingList.length,
          itemBuilder: (context, position) {
            return Dismissible(
                key: Key(shoppingList[position].id.toString()),
                onDismissed: (direction) {
                  String listName = shoppingList[position].name;
                  helper.deleteList(shoppingList[position]);

                  setState(() {
                    shoppingList.removeAt(position);
                  });

                  ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('$listName deleted')));
                },
                child: ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 25, vertical: 10),
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
                                builder: (BuildContext context) =>
                                    dialog.buildDialog(
                                        context, shoppingList[position], false))
                            .then((_) => showData());
                      },
                      icon: const Icon(Icons.edit)),
                  leading: CircleAvatar(
                    child: Text(shoppingList[position].priority.toString()),
                  ),
                  title: Text(shoppingList[position].name),
                ));
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
