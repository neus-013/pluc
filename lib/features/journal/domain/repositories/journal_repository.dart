import '../entities/journal_entry.dart';

/// Repository abstraction for Journal module.
/// Domain layer exposes this interface; data layer implements it.
abstract class JournalRepository {
  /// Fetch all journal entries for the current user
  Future<List<JournalEntry>> getAllEntries();

  /// Fetch a specific journal entry by ID
  Future<JournalEntry?> getEntryById(String id);

  /// Create or update a journal entry
  Future<void> saveEntry(JournalEntry entry);

  /// Delete a journal entry
  Future<void> deleteEntry(String id);

  /// Query entries within a date range (for calendar aggregation)
  Future<List<JournalEntry>> getEntriesByDateRange(DateTime start, DateTime end);
}
