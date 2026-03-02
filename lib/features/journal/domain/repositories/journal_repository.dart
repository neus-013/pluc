import '../entities/journal_entry.dart';

/// Repository abstraction for Journal module.
/// Domain layer exposes this interface; data layer implements it.
/// All methods are scoped to a specific user (ownerId) for data isolation.
abstract class JournalRepository {
  /// Fetch all journal entries for a specific user
  Future<List<JournalEntry>> getEntriesForUser(String ownerId);

  /// Fetch a specific journal entry by ID (verifies ownership)
  Future<JournalEntry?> getEntryById(String id, String ownerId);

  /// Create or update a journal entry - ownerId is assigned from the entry entity
  Future<void> saveEntry(JournalEntry entry);

  /// Delete a journal entry (verifies ownership)
  Future<void> deleteEntry(String id, String ownerId);

  /// Query entries within a date range for a specific user (for calendar aggregation)
  Future<List<JournalEntry>> getEntriesByDateRange(
      String ownerId, DateTime start, DateTime end);

  // Legacy method for backward compatibility
  @Deprecated('Use getEntriesForUser instead')
  Future<List<JournalEntry>> getAllEntries();
}
