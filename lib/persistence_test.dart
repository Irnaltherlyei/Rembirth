import 'dart:async';

import 'package:flutter/widgets.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

import 'birthday_entry.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final database = openDatabase(
    join(await getDatabasesPath(), 'birthday_entry_database.db'),
    onCreate: (db, version) {
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

  Future<void> insertEntry(BirthdayEntry entry) async {
    final db = await database;

    await db.insert(
      'birthday_entry',
      entry.toMap(),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> deleteEntry(BirthdayEntry entry) async {
    final db = await database;

    await db.delete(
      'birthday_entry',
      where: 'name = ? AND date = ?',
      whereArgs: [entry.name, entry.date],
    );
  }

  Future<void> updateEntry(BirthdayEntry entry) async {
    final db = await database;

    await db.update(
      'birthday_entry',
      entry.toMap(),
      where: 'name = ? AND date = ?',
      whereArgs: [entry.name, entry.date],
    );
  }

  //final db = await database;
  //await db.execute('DROP TABLE birthday_entry');

  var fido = BirthdayEntry(
    name: 'Adrian',
    date: DateTime(2000).toString(),
  );

  var fido2 = BirthdayEntry(
    name: 'Ann-Kathrin',
    date: DateTime(3000).toString(),
  );

  await insertEntry(fido);
  await insertEntry(fido2);

  // Now, use the method above to retrieve all the dogs.
  print(await getAllEntries()); // Prints a list that include Fido.

  await deleteEntry(fido);

  // Print the list of dogs (empty).
  print(await getAllEntries());
}

