import 'package:flutter/material.dart';
import 'package:shoppy/dbhelper.dart';
import 'package:shoppy/models/shopping_list.dart';
import 'package:shoppy/ui/items_screen.dart';

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
        backgroundColor: Colors.black87,
        title: const Text(
          'Shoppy',
          style: TextStyle(color: Colors.white),
        ),
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
  List<ShoppingList> shoppingList = List.empty();
  Dbhelper helper = Dbhelper();

  @override
  Widget build(BuildContext context) {
    showData();

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: shoppingList.length,
      itemBuilder: (context, position) {
        return ListTile(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => ItemsScreen(shoppingList[position])));
          },
          trailing: const IconButton(onPressed: null, icon: Icon(Icons.edit)),
          leading: CircleAvatar(
            child: Text(shoppingList[position].priority.toString()),
          ),
          title: Text(shoppingList[position].name),
        );
      },
    );
  }

  Future showData() async {
    await helper.openDb();

    shoppingList = await helper.getLists();

    setState(() {
      shoppingList = shoppingList;
    });
  }
}
