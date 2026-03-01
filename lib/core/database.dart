import 'package:drift/drift.dart';
import 'package:drift/native.dart';
import 'dart:io';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

part 'database.g.dart';

class Users extends Table {
  TextColumn get id => text()();
  TextColumn get username => text().withLength(min: 1, max: 50)();
  TextColumn get passwordHash => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class Modules extends Table {
  TextColumn get id => text()();
  TextColumn get name => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(true))();
  BoolColumn get devOnly => boolean().withDefault(const Constant(false))();
  TextColumn get configurableFeatures => text().nullable()(); // json
  @override
  Set<Column> get primaryKey => {id};
}

class FeatureToggles extends Table {
  TextColumn get id => text()();
  TextColumn get moduleId => text()();
  TextColumn get name => text()();
  BoolColumn get enabled => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class Presets extends Table {
  TextColumn get id => text()();
  TextColumn get moduleId => text()();
  TextColumn get enabledFeatures => text().nullable()(); // json
  TextColumn get disabledFeatures => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class EntityRelations extends Table {
  TextColumn get id => text()();
  TextColumn get fromEntityId => text()();
  TextColumn get toEntityId => text()();
  TextColumn get relationType => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class Tasks extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get dueDate => dateTime().nullable()();
  BoolColumn get completed => boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

// Additional tables for other modules... minimal fields
class JournalEntries extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get date => dateTime()();
  TextColumn get content => text()();
  @override
  Set<Column> get primaryKey => {id};
}

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get name => text()();
  BoolColumn get completedToday =>
      boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get title => text()();
  TextColumn get status => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class FinanceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  RealColumn get amount => real()();
  TextColumn get category => text().nullable()();
  DateTimeColumn get date => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class HealthRecords extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get type => text()();
  TextColumn get value => text().nullable()();
  DateTimeColumn get date => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class MenstruationCycles extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class NutritionEntries extends Table {
  TextColumn get id => text()();
  TextColumn get userId => text()();
  TextColumn get meal => text()();
  TextColumn get notes => text().nullable()();
  DateTimeColumn get date => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

@DriftDatabase(
  tables: [
    Users,
    Modules,
    FeatureToggles,
    Presets,
    EntityRelations,
    Tasks,
    JournalEntries,
    Habits,
    Projects,
    FinanceRecords,
    HealthRecords,
    MenstruationCycles,
    NutritionEntries,
  ],
)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pluc.sqlite'));
    return NativeDatabase(file);
  });
}
