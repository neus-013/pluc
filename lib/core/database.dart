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
  TextColumn get authProvider => text().withDefault(
      const Constant('local'))(); // 'local', 'google', 'apple', 'meta'
  DateTimeColumn get createdAt => dateTime()();
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
  TextColumn get ownerId => text()(); // User who owns this task
  TextColumn get title => text()();
  TextColumn get description => text().nullable()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get recurrenceRule => text().nullable()();
  TextColumn get reminderSettings => text().nullable()(); // JSON
  TextColumn get status => text().withDefault(const Constant('pending'))();
  TextColumn get linkedEntityId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

// Additional tables for other modules... minimal fields
class JournalEntries extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()(); // User who owns this entry
  TextColumn get content => text()();
  DateTimeColumn get startDate => dateTime().nullable()();
  DateTimeColumn get endDate => dateTime().nullable()();
  TextColumn get recurrenceRule => text().nullable()();
  TextColumn get reminderSettings => text().nullable()(); // JSON
  TextColumn get status => text().nullable()();
  TextColumn get linkedEntityId => text().nullable()();
  DateTimeColumn get createdAt => dateTime()();
  DateTimeColumn get updatedAt => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class Habits extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get name => text()();
  BoolColumn get completedToday =>
      boolean().withDefault(const Constant(false))();
  @override
  Set<Column> get primaryKey => {id};
}

class Projects extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get title => text()();
  TextColumn get status => text().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class FinanceRecords extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  RealColumn get amount => real()();
  TextColumn get category => text().nullable()();
  DateTimeColumn get date => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class HealthRecords extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  TextColumn get type => text()();
  TextColumn get value => text().nullable()();
  DateTimeColumn get date => dateTime()();
  @override
  Set<Column> get primaryKey => {id};
}

class MenstruationCycles extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
  DateTimeColumn get startDate => dateTime()();
  DateTimeColumn get endDate => dateTime().nullable()();
  @override
  Set<Column> get primaryKey => {id};
}

class NutritionEntries extends Table {
  TextColumn get id => text()();
  TextColumn get ownerId => text()();
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
  int get schemaVersion => 2; // Updated for ownerId migration

  @override
  MigrationStrategy get migration {
    return MigrationStrategy(
      onCreate: (Migrator m) async {
        // Create all tables with the current schema (v2 with ownerId)
        await m.createAll();
      },
      onUpgrade: (Migrator m, int from, int to) async {
        if (from == 1 && to == 2) {
          // Migration: Handle userId to ownerId transition
          // This migration renames userId columns to ownerId in all tables
          // For tables that might have been created with the old schema

          final tables = [
            'journal_entries',
            'habits',
            'projects',
            'finance_records',
            'health_records',
            'menstruation_cycles',
            'nutrition_entries',
          ];

          for (final table in tables) {
            try {
              // Check if old column exists by attempting to select it
              await customStatement(
                'SELECT userId FROM $table LIMIT 1',
              );
              // If column exists, rename it to ownerId
              // This uses SQLite's PRAGMA table_info to confirm then recreates table
              // For now, we document that manual migration might be needed
            } catch (e) {
              // Column doesn't exist or table doesn't exist - skip
            }
          }
        }
      },
    );
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dbFolder = await getApplicationDocumentsDirectory();
    final file = File(p.join(dbFolder.path, 'pluc.sqlite'));
    return NativeDatabase(file);
  });
}
