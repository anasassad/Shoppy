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
      title: Text(
        isNew ? 'New Shopping List' : 'Edit Shopping List',
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
            DropdownButtonFormField(
              value: txtPriority,
              decoration: const InputDecoration(
                hintText: 'Priority',
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
            const SizedBox(
              height: 15,
            ),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                  onPressed: () {
                    shoppingList.name = txtName.text;
                    shoppingList.priority = txtPriority!;
                    helper.insertList(shoppingList);
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
