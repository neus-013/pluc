import 'package:pluc/core/database.dart';
import 'package:pluc/features/journal/domain/entities/journal_entry.dart'
    as domain;
import 'package:pluc/features/journal/domain/repositories/journal_repository.dart';
import 'package:drift/drift.dart';

/// Implementation of JournalRepository using Drift ORM.
/// Encapsulates database access; domain layer doesn't know about Drift.
/// All queries are filtered by ownerId for multi-user data isolation.
class JournalRepositoryImpl implements JournalRepository {
  final AppDatabase db;

  JournalRepositoryImpl(this.db);

  @override
  Future<List<domain.JournalEntry>> getEntriesForUser(String ownerId) async {
    try {
      final entries = await (db.select(db.journalEntries)
            ..where((t) => t.ownerId.equals(ownerId)))
          .get();
      return entries.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<domain.JournalEntry?> getEntryById(String id, String ownerId) async {
    try {
      final entry = await (db.select(db.journalEntries)
            ..where((t) => t.id.equals(id) & t.ownerId.equals(ownerId)))
          .getSingleOrNull();
      return entry != null ? _mapToDomain(entry) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveEntry(domain.JournalEntry entry) async {
    try {
      print('DEBUG JournalRepository: Saving entry ${entry.id}');
      print(
          'DEBUG JournalRepository: ownerId=${entry.ownerId}, content length=${entry.content.length}');

      await db.into(db.journalEntries).insertOnConflictUpdate(
            JournalEntriesCompanion(
              id: Value(entry.id),
              ownerId: Value(entry.ownerId),
              content: Value(entry.content),
              startDate: Value(entry.startDate),
              endDate: Value(entry.endDate),
              recurrenceRule: Value(entry.recurrenceRule),
              reminderSettings: Value(entry.reminderSettings != null
                  ? entry.reminderSettings.toString()
                  : null),
              status: Value(entry.status),
              linkedEntityId: Value(entry.linkedEntityId),
              createdAt: Value(entry.createdAt),
              updatedAt: Value(entry.updatedAt),
            ),
          );

      print('DEBUG JournalRepository: Entry saved successfully');
    } catch (e, stackTrace) {
      print('ERROR JournalRepository: Failed to save entry: $e');
      print('STACK TRACE: $stackTrace');
      rethrow;
    }
  }

  @override
  Future<void> deleteEntry(String id, String ownerId) async {
    await (db.delete(db.journalEntries)
          ..where((t) => t.id.equals(id) & t.ownerId.equals(ownerId)))
        .go();
  }

  @override
  Future<List<domain.JournalEntry>> getEntriesByDateRange(
    String ownerId,
    DateTime start,
    DateTime end,
  ) async {
    try {
      final entries = await (db.select(db.journalEntries)
            ..where((t) =>
                t.ownerId.equals(ownerId) &
                t.startDate.isBetween(Constant(start), Constant(end))))
          .get();
      return entries.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  @Deprecated('Use getEntriesForUser instead')
  Future<List<domain.JournalEntry>> getAllEntries() async {
    // Legacy method - returns all entries without filtering
    // This should not be used in production - only for migration
    try {
      final entries = await db.select(db.journalEntries).get();
      return entries.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  /// Maps database row to domain entity
  domain.JournalEntry _mapToDomain(JournalEntry row) {
    return domain.JournalEntry(
      id: row.id,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      ownerId: row.ownerId,
      moduleSource: 'journal',
      content: row.content,
      startDate: row.startDate,
      endDate: row.endDate,
      recurrenceRule: row.recurrenceRule,
      reminderSettings: null, // TODO: Parse JSON if needed
      status: row.status,
      linkedEntityId: row.linkedEntityId,
    );
  }
}
