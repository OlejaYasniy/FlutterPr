import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'notes_schema.dart';
part 'notes_database.g.dart';

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File(p.join(dir.path, 'notes.sqlite'));
    return NativeDatabase.createInBackground(file);
  });
}

@DriftDatabase(tables: [Notes])
class NotesDatabase extends _$NotesDatabase {
  NotesDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  Future<List<Note>> getAllNotes() => select(notes).get();
  Stream<List<Note>> watchAllNotes() => select(notes).watch();

  Future<void> upsertNote(NotesCompanion entry) async {
    await into(notes).insertOnConflictUpdate(entry);
  }

  Future<int> deleteNoteById(String id) {
    return (delete(notes)..where((t) => t.id.equals(id))).go();
  }
}
