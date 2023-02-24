import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'birthday_entry.dart';

/// Persistence manager. Enabling to save birthday entries permanently.
class Persistence{
  late final Future<Database> database;

  /// Initializing database.
  void init() async{
    WidgetsFlutterBinding.ensureInitialized();
    database = openDatabase(
        join(await getDatabasesPath(), 'birthday_entry_database.db'),
        onCreate: (db, version) {
          //sampleData();
          return db.execute(
            'CREATE TABLE birthday_entry('
            'name TEXT,'
            'date TEXT,'
            'PRIMARY KEY (name, date)'
            ')',
          );
    },
    version: 1,
    );
  }

  /// Custom call to retrieve all birthday entries.
  Future<List<BirthdayEntry>> getAllEntries() async {
    final db = await database;

    final List<Map<String, dynamic>> maps = await db.query('birthday_entry');

    return List.generate(maps.length, (i) {
      return BirthdayEntry(
        name: maps[i]['name'],
        date: maps[i]['date'],
      );
    });
  }

  /// Insert birthday entry.
  Future<void> insertEntry(BirthdayEntry entry) async {
    final db = await database;

    await db.insert(
      'birthday_entry',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.ignore,
    );
  }

  /// Delete birthday entry.
  Future<void> deleteEntry(BirthdayEntry entry) async {
    final db = await database;

    await db.delete(
      'birthday_entry',
      where: 'name = ? AND date = ?',
      whereArgs: [entry.name, entry.date],
    );
  }

  /// Update birthday entry.
  Future<void> updateEntry(BirthdayEntry oldEntry, BirthdayEntry newEntry) async {
    final db = await database;

    await db.update(
      'birthday_entry',
      newEntry.toMap(),
      where: 'name = ? AND date = ?',
      whereArgs: [oldEntry.name, oldEntry.date],
    );
  }

  /// Filling the database with sample data.
  Future<void> sampleData() async{
    var data = BirthdayEntry(name: 'Adrian', date: DateTime(2000,8,6).toString());
    await insertEntry(data);
    data = BirthdayEntry(name: 'Ann-Kathrin', date: DateTime(1999,3,5).toString());
    await insertEntry(data);
  }
}