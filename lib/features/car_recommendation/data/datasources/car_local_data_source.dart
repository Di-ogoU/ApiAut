import 'package:sqflite/sqflite.dart';

import '../../../../core/database/app_database.dart';
import '../models/car_model.dart';

class CarLocalDataSource {
  CarLocalDataSource(this._database);

  final AppDatabase _database;

  Future<void> saveHistory(CarModel car) async {
    final db = await _database.database;
    await db.insert('history', car.withCreatedNow().toJson()..remove('id'));
  }

  Future<List<CarModel>> getHistory() async {
    final db = await _database.database;
    final rows = await db.query('history', orderBy: 'created_at DESC');
    return rows.map((row) => CarModel.fromJson(row)).toList();
  }

  Future<void> deleteHistory(int id) async {
    final db = await _database.database;
    await db.delete('history', where: 'id = ?', whereArgs: [id]);
  }

  Future<void> saveFavorite(CarModel car) async {
    final db = await _database.database;
    final payload = car.withCreatedNow().toJson()..remove('id');
    await db.insert(
      'favorites',
      payload,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<CarModel>> getFavorites() async {
    final db = await _database.database;
    final rows = await db.query('favorites', orderBy: 'created_at DESC');
    return rows.map((row) => CarModel.fromJson(row)).toList();
  }

  Future<void> deleteFavorite(int id) async {
    final db = await _database.database;
    await db.delete('favorites', where: 'id = ?', whereArgs: [id]);
  }
}
