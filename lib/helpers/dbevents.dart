import 'package:sqflite/sqflite.dart' as sql;
import 'package:path/path.dart' as path;

class DBEvents {
  static Future<sql.Database> database() async {
    final dbPath = await sql.getDatabasesPath();
    return sql.openDatabase(path.join(dbPath, 'events.db'),
        onCreate: (db, version) {
      return db.execute('CREATE TABLE events(id TEXT PRIMARY KEY)');
    }, version: 1);
  }

  static Future<void> insert(String table, Map<String, Object> data) async {
    final db = await DBEvents.database();
    db.insert(
      table,
      data,
      conflictAlgorithm: sql.ConflictAlgorithm.replace,
    );
    print(db);
  }

  static Future<List<Map<String, dynamic>>> getData(String table) async {
    final db = await DBEvents.database();
    return db.query(table);
  }

  static Future<void> delete(String table, String id) async {
    final db = await DBEvents.database();
    db.delete(table, where: "id = ?", whereArgs: [id]);
  }
}
