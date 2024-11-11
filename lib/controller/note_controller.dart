import 'package:flutter/material.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path/path.dart';
import 'package:coursework1_mad/model/note_model.dart';

class noteDatabaseController {
  static final noteDatabaseController instance = noteDatabaseController._init();
  static Database? _db;
  noteDatabaseController._init();

  Future<Database> get database async {
    if (_db != null) return _db!;
    _db = await _createDb();
    return _db!;
  }

  Future<Database> _createDb() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbPath = join(dir.path, 'notes_database.db');
    return await openDatabase(dbPath, version: 1, onCreate: _setDb);
  }

  Future<void> _setDb(Database db, int version) async {
    await db.execute(
      'CREATE TABLE Notes (id INTEGER PRIMARY KEY AUTOINCREMENT, title TEXT NOT NULL, description TEXT, userId INTEGER, FOREIGN KEY(userId) REFERENCES Auth(id))',
    );
  }

  Future<List<NoteModel>> getAllNotes(int userId) async {
    final db = await database;
    final result = await db.query(
      'Notes',
      where: 'userId = ?',
      whereArgs: [userId],
      orderBy: 'id ASC',
    );
    return result.map((json) => NoteModel.fromJson(json)).toList();
  }

  Future<NoteModel> getNote(int userId, int noteId) async {
    final db = await database;
    final maps = await db.query(
      'Notes',
      where: 'userId = ? AND id = ?',
      whereArgs: [userId, noteId],
      orderBy: 'id ASC',
    );
    if (maps.isNotEmpty) {
      return NoteModel.fromJson(maps.first);
    } else {
      throw Exception('Note ID $userId not found');
    }
  }

  Future<void> addNote(NoteModel note) async {
    final db = await database;
    await db.insert('Notes', note.toJson(),
        conflictAlgorithm: ConflictAlgorithm.replace);
  }

  Future<int> updateNote(NoteModel note) async {
    final db = await database;
    return await db.update('Notes', note.toJson(),
        where: 'id = ?', whereArgs: [note.id]);
  }

  Future<void> deleteNote(int id) async {
    final db = await database;
    try {
      await db.delete('Notes', where: "id = ?", whereArgs: [id]);
    } catch (e) {
      debugPrint("Error deleting note: $e");
    }
  }

  Future<void> closeDb() async {
    final db = await database;
    await db.close();
  }
}
