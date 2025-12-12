import 'package:drift/drift.dart';

import 'notes_database.dart';

class DriftNotesDataSource {
  final NotesDatabase _db;

  DriftNotesDataSource(this._db);

  Future<List<Note>> getAll() => _db.getAllNotes();

  Stream<List<Note>> watchAll() => _db.watchAllNotes();

  Future<void> save({
    required String id,
    required String title,
    required String content,
  }) {
    return _db.upsertNote(
      NotesCompanion(
        id: Value(id),
        title: Value(title),
        content: Value(content),
      ),
    );
  }

  Future<void> delete(String id) async {
    await _db.deleteNoteById(id);
  }
}
