// ignore_for_file: non_constant_identifier_names, prefer_conditional_assignment

import 'package:path/path.dart';
import 'package:shoppy/models/list_items.dart';
import 'package:shoppy/models/shopping_list.dart';
import 'package:sqflite/sqflite.dart';

class Dbhelper {
  final int version = 1;
  Database? db;

  // Create a private constructor named _internal
  static final Dbhelper _dbhelper = Dbhelper._internal();

  Dbhelper._internal();

  // Return _dbhelper to the outside caller
  factory Dbhelper() {
    return _dbhelper;
  }

  final String LISTS_SCHEMA = '''
        CREATE TABLE lists (
          id INTEGER PRIMARY KEY,
          name TEXT,
          priority INTEGER)
      ''';

  final String ITEMS_SCHEMA = '''
        CREATE TABLE items (
        id INTEGER PRIMARY KEY,
        idList INTEGER,
        name TEXT,
        quantity TEXT,
        note TEXT,
        FOREIGN KEY(idList) REFERENCES lists(id))
      ''';

  Future<Database?> openDb() async {
    final String path = join(await getDatabasesPath(), 'shopping.db');

    if (db == null) {
      db = await openDatabase(
        path,
        version: version,
        onCreate: (db, version) {
          db.execute(LISTS_SCHEMA);
          db.execute(ITEMS_SCHEMA);
        },
      );
    }

    return db;
  }

  Future<int> insertList(ShoppingList list) async {
    // the conflictAlgorithm specifies the behavior that should
    // be followed when you try to insert a record with the same ID twice. In
    // this case, if the same list is inserted multiple times, it will replace the
    // previous data with the new list that was passed to the function.
    int id = await db!.insert('lists', list.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int> deleteList(ShoppingList list) async {
    int result =
        await db!.delete('items', where: 'idList = ?', whereArgs: [list.id]);

    result = await db!.delete('lists', where: 'id = ?', whereArgs: [list.id]);

    return result;
  }

  Future<int> insertItem(ListItems item) async {
    // the conflictAlgorithm specifies the behavior that should
    // be followed when you try to insert a record with the same ID twice. In
    // this case, if the same list is inserted multiple times, it will replace the
    // previous data with the new list that was passed to the function.
    int id = await db!.insert('items', item.toMap(),
        conflictAlgorithm: ConflictAlgorithm.replace);

    return id;
  }

  Future<int> deleteItem(ListItems item) async {
    int result =
        await db!.delete('items', where: 'id = ?', whereArgs: [item.id]);

    return result;
  }

  Future<List<ShoppingList>> getLists() async {
    List maps = await db!.query('lists');

    // Convert List<dynamic> to ShoppingList values to match the returned data of the Future
    return List.generate(
        maps.length,
        (index) => ShoppingList(
            maps[index]['id'], maps[index]['name'], maps[index]['priority']));
  }

  Future<List<ListItems>> getItems(int idList) async {
    List maps =
        await db!.query('items', where: 'idList = ?', whereArgs: [idList]);

    // Convert List<dynamic> to ShoppingList values to match the returned data of the Future
    return List.generate(
        maps.length,
        (index) => ListItems(maps[index]['id'], maps[index]['idList'],
            maps[index]['name'], maps[index]['note'], maps[index]['quantity']));
  }
}
