import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'package:path_provider/path_provider.dart';
class DatabaseHelper {



  static final DatabaseHelper _instance = DatabaseHelper.internal();

  factory DatabaseHelper() => _instance;
  final String dbName = "buttonTime.db";

  static Database? _db;

  Future<Database> get db async {
    if (_db != null) {
      return _db!;
    }
    _db = await initDb();
    return _db!;
  }

  DatabaseHelper.internal();

  Future<Database> getDb(){
    return db;
  }


  Future<Database> initDb() async {
    Directory dic = await  getApplicationDocumentsDirectory();
    String path = join(dic.path, dbName);
    print("数据库文件地址$path");



    var ourDb = await openDatabase(path, version: 1, onCreate: _onCreate);
    _db = ourDb;
    return ourDb;
  }

  void _onCreate(Database db, int version) async {
    await db.execute('''
   CREATE TABLE "task_history" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "task_name" TEXT,
  "task_code" TEXT,
  "start_time" INTEGER,
  "end_time" INTEGER,
  "task_id" INTEGER
); ''');
    await db.execute('''
   CREATE TABLE "task" (
  "id" INTEGER NOT NULL PRIMARY KEY AUTOINCREMENT,
  "task_name" TEXT,
  "status" INTEGER,
  "create_time" INTEGER
); ''');

  }
}
