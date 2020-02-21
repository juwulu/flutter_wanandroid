import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DbManager {
  static const _VERSION = 1;

  static const _NAME = "wanandroid.db";

  static Database _database;

  ///初始化
  static init() async {
    var databasesPath = await getDatabasesPath();

    String path = join(databasesPath, _NAME);

    _database = await openDatabase(path,
        version: _VERSION, onCreate: (Database db, int version) async {});
  }

  ///判断表是否存在
  static isTableExits(String tableName) async {
    await getCurrentDatabase();
    var res = await _database.rawQuery(
        "select * from Sqlite_master where type = 'table' and name = '$tableName'");
    return res != null && res.length > 0;
  }

  ///获取当前数据库对象
  static Future<Database> getCurrentDatabase() async {
    if (_database == null) {
      await init();
    }
    return _database;
  }

  ///关闭
  static close() {
    _database?.close();
    _database = null;
  }
}

abstract class BaseDbProvider {
  bool isTableExits = false;

  createTableString();

  tableName();

  ///创建表sql语句
  tableBaseString(String sql) {
    return sql;
  }

  Future<Database> getDataBase() async {
    return await open();
  }

  ///super 函数对父类进行初始化
  @mustCallSuper
  prepare(name, String createSql) async {
    isTableExits = await DbManager.isTableExits(name);
    if (!isTableExits) {
      Database db = await DbManager.getCurrentDatabase();
      return await db.execute(createSql);
    }
  }

  @mustCallSuper
  open() async {
    if (!isTableExits) {
      await prepare(tableName(), createTableString());
    }
    return await DbManager.getCurrentDatabase();
  }
}

class SearchDao extends BaseDbProvider {
  ///表名
  final String name = 'search';

  final String columnId = "id";
  final String columnRecord = "record";

  @override
  tableName() {
    return name;
  }

  @override
  createTableString() {
    return '''
        create table $name (
        $columnId integer primary key,
        $columnRecord text not null)
      ''';
  }

  Future insert(String record) async {
    Database db = await getDataBase();
    Map<String, dynamic> map = Map<String, dynamic>();
    map['record'] = record;
    query(record).then((maps) {
      if (maps is List && maps.length > 0) {
        delete(record).then((_) {
          db.insert(name, map);
        });
      } else {
        db.insert(name, map);
      }
    });
  }

  Future<List<Map<String, dynamic>>> queryAll() async {
    Database db = await getDataBase();
    List<Map<String, dynamic>> maps =
        await db.rawQuery("select * from $name order by id desc limit 5");
    return maps;
  }

  Future<List<Map<String, dynamic>>> query(String record) async {
    Database db = await getDataBase();
    return await db.query(name, where: '$columnRecord=?', whereArgs: [record]);
  }

  Future delete(String record) async {
    Database db = await getDataBase();
    return await db.delete(name, where: '$columnRecord=?', whereArgs: [record]);
  }
}
