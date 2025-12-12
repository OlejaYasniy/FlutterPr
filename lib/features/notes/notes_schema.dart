import 'package:drift/drift.dart';

class Notes extends Table {
  TextColumn get id => text()();

  TextColumn get title => text()();

  TextColumn get content => text().withDefault(const Constant(''))();

  DateTimeColumn get createdAt =>
      dateTime().withDefault(currentDateAndTime)();

  @override
  Set<Column> get primaryKey => {id};
}
