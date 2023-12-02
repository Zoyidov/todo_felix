
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import '../model/db_model.dart';

class LocalDatabase {
  static final LocalDatabase getInstance = LocalDatabase._();

  LocalDatabase._();

  factory LocalDatabase() {
    return getInstance;
  }

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    } else {
      _database = await _initDB("defaultDatabase.db");
      return _database!;
    }
  }

  Future<Database> _initDB(String dbName) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, dbName);
    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = "INTEGER PRIMARY KEY AUTOINCREMENT";
    const textType = "TEXT NOT NULL";

    await db.execute('''
    CREATE TABLE ${EventModelFields.eventTable}(
    ${EventModelFields.id} $idType,
    ${EventModelFields.name} $textType,
    ${EventModelFields.description} $textType,
    ${EventModelFields.location} $textType,
    ${EventModelFields.time} $textType,
    ${EventModelFields.priorityColor} $textType,
    ${EventModelFields.dateCreated} DATETIME DEFAULT CURRENT_TIMESTAMP
    )
    ''');
  }




  static Future<TodoModel> insert(TodoModel eventModel) async {
    final db = await getInstance.database;
    final int id = await db.insert(EventModelFields.eventTable, eventModel.toJson());
    return eventModel.copyWith(id: id);
  }


  static Future<List<TodoModel>> getAll() async {
    List<TodoModel> allInfo = [];
    final db = await getInstance.database;
    allInfo = (await db.query(EventModelFields.eventTable))
        .map((e) => TodoModel.fromJson(e))
        .toList();

    return allInfo;
  }

  static update({required TodoModel eventModel}) async {
    final db = await getInstance.database;
    db.update(
      EventModelFields.eventTable,
      eventModel.toJson(),
      where: "${EventModelFields.id} = ?",
      whereArgs: [eventModel.id],
    );
  }

  static delete(int id) async {
    final db = await getInstance.database;
    db.delete(
      EventModelFields.eventTable,
      where: "${EventModelFields.id} = ?",
      whereArgs: [id],
    );
  }

  static deleteAll() async {
    final db = await getInstance.database;
    db.delete(
      EventModelFields.eventTable,
    );
  }
  Future<List<DateTime>> getAllSavedDates() async {
    final db = await database;
    final List<Map<String, dynamic>> results = await db.query(
      EventModelFields.eventTable,
      columns: [EventModelFields.dateCreated],
    );

    final List<DateTime> savedDates = results
        .map((map) => DateTime.parse(map[EventModelFields.dateCreated]))
        .toList();

    return savedDates;
  }
}
