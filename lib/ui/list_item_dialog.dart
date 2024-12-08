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
    } else {
      txtName.text = '';
      txtQuantity.text = '';
      txtNote.text = '';
    }

    return AlertDialog(
      title: Text(
        isNew ? 'New Item' : 'Edit Item',
        textAlign: TextAlign.center,
        style: TextStyle(
            color: Colors.blueGrey[700],
            fontWeight: FontWeight.bold,
            fontSize: 20),
      ),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      content: SingleChildScrollView(
        child: Column(
          children: [
            CustomTextField('Name', Icons.short_text_rounded, txtName),
            const SizedBox(
              height: 15,
            ),
            CustomTextField('Quantity', Icons.numbers_rounded, txtQuantity),
            const SizedBox(
              height: 15,
            ),
            CustomTextField('Note', Icons.text_snippet_rounded, txtNote),
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    listItems.name = txtName.text;
                    listItems.quantity = txtQuantity.text;
                    listItems.note = txtNote.text;

                    helper.insertItem(listItems);
                    Navigator.pop(context);
                  },
                  style: TextButton.styleFrom(
                    backgroundColor:
                        Colors.blueGrey[700], // Blue-grey background
                    padding: const EdgeInsets.symmetric(
                        vertical: 15), // Vertical padding for height
                    shape: RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(10), // Rounded corners
                    ),
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  )),
            )
          ],
        ),
      ),
    );
  }

  TextField CustomTextField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      cursorColor: Colors.blueGrey,
      cursorHeight: 20,
      cursorRadius: const Radius.circular(10),
      textAlign: TextAlign.center,
      decoration: InputDecoration(
        hintText: label,
        suffixIcon: Icon(
          icon,
          size: 16,
        ),
        suffixIconColor: Colors.blueGrey,
      ),
    );
  }
}
