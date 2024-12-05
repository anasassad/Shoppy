import 'package:flutter/material.dart';
import 'package:shoppy/dbhelper.dart';
import 'package:shoppy/models/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  final txtPriority = TextEditingController();

  Widget buildDialog(
      BuildContext context, ShoppingList shoppingList, bool isNew) {
    Dbhelper helper = Dbhelper();

    if (!isNew) {
      txtName.text = shoppingList.name;
      txtPriority.text = shoppingList.priority.toString();
    }

    return AlertDialog(
      title: Text(isNew ? 'New Shopping List' : 'Edit Shopping List'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: txtPriority,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(hintText: 'Priority (1 - 3)'),
            ),
            TextButton(
                onPressed: () {
                  shoppingList.name = txtName.text;
                  shoppingList.priority = int.parse(txtPriority.text);
                  print(shoppingList.toMap());
                  helper.insertList(shoppingList);
                  Navigator.pop(context);
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
