import 'package:flutter/material.dart';
import 'package:shoppy/dbhelper.dart';
import 'package:shoppy/models/shopping_list.dart';

class ShoppingListDialog {
  final txtName = TextEditingController();
  int? txtPriority = 1;

  Widget buildDialog(
      BuildContext context, ShoppingList shoppingList, bool isNew) {
    Dbhelper helper = Dbhelper();

    if (!isNew) {
      txtName.text = shoppingList.name;
      txtPriority = shoppingList.priority;
    } else {
      txtName.text = '';
      txtPriority = null;
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
            DropdownButtonFormField(
              value: txtPriority,
              decoration: const InputDecoration(hintText: 'Priority'),
              items: List.generate(
                  3,
                  (index) => DropdownMenuItem(
                        value: index + 1,
                        child: Text('${index + 1}'),
                      )),
              onChanged: (value) {
                txtPriority = value!;
              },
            ),
            TextButton(
                onPressed: () {
                  shoppingList.name = txtName.text;
                  shoppingList.priority = txtPriority!;
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
