import 'package:pluc/core/database.dart';
import 'package:pluc/features/journal/domain/entities/journal_entry.dart';
import 'package:pluc/features/journal/domain/repositories/journal_repository.dart';

/// Implementation of JournalRepository using Drift ORM.
/// Encapsulates database access; domain layer doesn't know about Drift.
class JournalRepositoryImpl implements JournalRepository {
  final AppDatabase db;

  JournalRepositoryImpl(this.db);

  @override
  Future<List<JournalEntry>> getAllEntries() async {
    try {
      final entries = await db.select(db.journalEntries).get();
      return entries.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<JournalEntry?> getEntryById(String id) async {
    try {
      final entry = await (db.select(db.journalEntries)
            ..where((t) => t.id.equals(id)))
          .getSingleOrNull();
      return entry != null ? _mapToDomain(entry) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveEntry(JournalEntry entry) async {
    await db.into(db.journalEntries).insertOnConflictUpdate(
      JournalEntriesCompanion(
        id: Value(entry.id),
        userId: Value(entry.userId),
        date: Value(entry.createdAt),
        content: Value(entry.content),
      ),
    );
  }

  @override
  Future<void> deleteEntry(String id) async {
    await (db.delete(db.journalEntries)
          ..where((t) => t.id.equals(id)))
        .go();
  }

  @override
  Future<List<JournalEntry>> getEntriesByDateRange(
    DateTime start,
    DateTime end,
  ) async {
    try {
      final entries = await (db.select(db.journalEntries)
            ..where((t) => t.date.isBetween(start, end)))
          .get();
      return entries.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  /// Maps database row to domain entity
  JournalEntry _mapToDomain(JournalEntriesData row) {
    return JournalEntry(
      id: row.id,
      createdAt: row.date,
      updatedAt: row.date,
      userId: row.userId,
      moduleSource: 'journal',
      content: row.content,
    );
  }
}
