import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart';

class AppDatabase {
  Database? _database;

  Future<Database> get database async {
    if (_database != null) {
      return _database!;
    }

    final databasesPath = await getDatabasesPath();
    final path = p.join(databasesPath, 'car_recommender.db');
    _database = await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE history (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            buying TEXT NOT NULL,
            maint TEXT NOT NULL,
            doors TEXT NOT NULL,
            persons TEXT NOT NULL,
            lug_boot TEXT NOT NULL,
            safety TEXT NOT NULL,
            class_name TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
        await db.execute('''
          CREATE TABLE favorites (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            buying TEXT NOT NULL,
            maint TEXT NOT NULL,
            doors TEXT NOT NULL,
            persons TEXT NOT NULL,
            lug_boot TEXT NOT NULL,
            safety TEXT NOT NULL,
            class_name TEXT NOT NULL,
            created_at TEXT NOT NULL
          )
        ''');
      },
    );
    return _database!;
  }
}
