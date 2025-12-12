import 'dart:math';

import 'drift_notes_data_source.dart';
import 'notes_database.dart';

class NotesUseCase {
  final DriftNotesDataSource _ds;

  NotesUseCase(this._ds);

  Future<List<Note>> loadNotes() => _ds.getAll();

  Stream<List<Note>> observeNotes() => _ds.watchAll();

  Future<void> createDemoNote() async {
    final id = '${DateTime.now().millisecondsSinceEpoch}_${Random().nextInt(999)}';
    await _ds.save(
      id: id,
      title: 'Демо-заметка',
      content: 'Создано через DriftDataSource',
    );
  }

  Future<void> remove(String id) => _ds.delete(id);
}
