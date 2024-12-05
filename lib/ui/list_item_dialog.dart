import 'package:flutter/material.dart';
import 'package:shoppy/dbhelper.dart';
import 'package:shoppy/models/list_items.dart';

class ListItemDialog {
  final txtName = TextEditingController();
  final txtQuantity = TextEditingController();
  final txtNote = TextEditingController();

  Widget buildDialog(BuildContext context, ListItems listItems, bool isNew) {
    Dbhelper helper = Dbhelper();

    if (!isNew) {
      txtName.text = listItems.name;
      txtQuantity.text = listItems.quantity;
      txtNote.text = listItems.note;
    }

    return AlertDialog(
      title: Text(isNew ? 'New List Item' : 'Edit List Item'),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30.0)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            TextField(
              controller: txtName,
              decoration: const InputDecoration(hintText: 'Name'),
            ),
            TextField(
              controller: txtQuantity,
              decoration: const InputDecoration(hintText: 'Quantity'),
            ),
            TextField(
              controller: txtNote,
              decoration: const InputDecoration(hintText: 'Note'),
            ),
            TextButton(
                onPressed: () {
                  listItems.name = txtName.text;
                  listItems.quantity = txtQuantity.text;
                  listItems.note = txtNote.text;

                  print(listItems.toMap());

                  helper.insertItem(listItems);
                  Navigator.pop(context);
                },
                child: const Text('Save'))
          ],
        ),
      ),
    );
  }
}
