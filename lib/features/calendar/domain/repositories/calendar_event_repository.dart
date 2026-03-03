import '../entities/calendar_event.dart';

/// Repository abstraction for Calendar Events.
/// Domain layer exposes this interface; data layer implements it.
/// All methods are scoped to a specific user (ownerId) for data isolation.
abstract class CalendarEventRepository {
  /// Get all events for a specific user
  Future<List<CalendarEvent>> getEventsForUser(String ownerId);

  /// Get an event by ID (verifies ownership)
  Future<CalendarEvent?> getEventById(String id, String ownerId);

  /// Save an event (create or update) - ownerId is assigned from the entity
  Future<void> saveEvent(CalendarEvent event);

  /// Delete an event (verifies ownership)
  Future<void> deleteEvent(String id, String ownerId);

  /// Get events within a date range for a specific user (for calendar aggregation)
  Future<List<CalendarEvent>> getEventsByDateRange(
      String ownerId, DateTime start, DateTime end);
}
