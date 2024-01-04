import 'package:sqflite/sqflite.dart';
import '../models/task.dart';

class DBHelper {
  static const int _version = 1;
  static const String _tableName = "tasks";
  static const String _TABLE_CREATION_SQL = '''CREATE TABLE $_tableName (
id INTEGER PRIMARY KEY AUTOINCREMENT, 
title STRING, 
note TEXT, 
date STRING, 
startTime STRING, 
endTime STRING, 
remind INTEGER, 
repeat STRING, 
color INTEGER, 
isCompleted INTEGER)''';

  static Future<Database> get database async {
    Database? database = await initDB();
    return database;
  }

  static Future<Database> initDB() async {
    try {
      return await openDatabase(
        'tasks.db',
        version: _version,
        onCreate: (database, version) async {
          await database.execute(_TABLE_CREATION_SQL);
          print("Local Database has been created");
        },
        onOpen: (database) {
          print("database opened");
        },
      );
    } catch (e) {
      print('Error occurred while opening the database: $e');
      rethrow;
    }
  }

  static Future<int> insert(Task? task) async {
    print('insert function called');
    try {
      final db = await database;
      return await db.insert(_tableName, task!.toJson());
    } catch (e) {
      print(e);
      print("\n=================================================================================");
      return 9000;
    }
  }


  static Future<int> delete(Task task) async {
    print('delete');
    final db = await database;
    return await db.delete(
      _tableName,
      where: 'id = ?',
      whereArgs: [task.id],
    );
  }
  static Future<int> deleteAll() async {
    print('deleteAll');
    final db = await database;
    return await db.delete(_tableName);
  }

  static Future<List<Map<String, dynamic>>> query() async {
    print('Query Called');
    final db = await database;
    return await db.query(_tableName);
  }


  static Future<int> update(int id) async {
    print('update');
    final db = await database;
    return await db.rawUpdate('''
    UPDATE tasks
    SET isCompleted = ?
    WHERE id = ?
    ''', [1, id]);
  }

}
