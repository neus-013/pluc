import 'package:pluc/core/database.dart';
import 'package:pluc/features/calendar/domain/entities/calendar_event.dart'
    as domain;
import 'package:pluc/features/calendar/domain/repositories/calendar_event_repository.dart';
import 'package:drift/drift.dart';

/// Implementation of CalendarEventRepository using Drift ORM.
/// All queries are filtered by ownerId for multi-user data isolation.
class CalendarEventRepositoryImpl implements CalendarEventRepository {
  final AppDatabase db;

  CalendarEventRepositoryImpl(this.db);

  @override
  Future<List<domain.CalendarEvent>> getEventsForUser(String ownerId) async {
    try {
      final events = await (db.select(db.calendarEvents)
            ..where((e) => e.ownerId.equals(ownerId)))
          .get();
      return events.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<domain.CalendarEvent?> getEventById(String id, String ownerId) async {
    try {
      final event = await (db.select(db.calendarEvents)
            ..where((e) => e.id.equals(id) & e.ownerId.equals(ownerId)))
          .getSingleOrNull();
      return event != null ? _mapToDomain(event) : null;
    } catch (e) {
      return null;
    }
  }

  @override
  Future<void> saveEvent(domain.CalendarEvent event) async {
    try {
      await db.into(db.calendarEvents).insertOnConflictUpdate(
            CalendarEventsCompanion(
              id: Value(event.id),
              ownerId: Value(event.ownerId),
              title: Value(event.title),
              description: Value(event.description),
              startDate: Value(event.startDate),
              endDate: Value(event.endDate),
              recurrenceRule: Value(event.recurrenceRule),
              reminderSettings: Value(event.reminderSettings?.toString()),
              status: Value(event.status ?? 'active'),
              linkedEntityId: Value(event.linkedEntityId),
              createdAt: Value(event.createdAt),
              updatedAt: Value(event.updatedAt),
            ),
          );
    } catch (e) {
      rethrow;
    }
  }

  @override
  Future<void> deleteEvent(String id, String ownerId) async {
    await (db.delete(db.calendarEvents)
          ..where((e) => e.id.equals(id) & e.ownerId.equals(ownerId)))
        .go();
  }

  @override
  Future<List<domain.CalendarEvent>> getEventsByDateRange(
      String ownerId, DateTime start, DateTime end) async {
    try {
      final events = await (db.select(db.calendarEvents)
            ..where((e) =>
                e.ownerId.equals(ownerId) &
                (
                    // Events whose start–end range overlaps the query window
                    (e.startDate.isSmallerOrEqualValue(end) &
                            e.endDate.isBiggerOrEqualValue(start)) |
                        // Events with no endDate — startDate in range
                        (e.endDate.isNull() &
                            e.startDate.isBetweenValues(start, end)) |
                        // Events with no startDate — fall back to createdAt
                        (e.startDate.isNull() &
                            e.createdAt.isBetweenValues(start, end)))))
          .get();
      return events.map(_mapToDomain).toList();
    } catch (e) {
      return [];
    }
  }

  domain.CalendarEvent _mapToDomain(CalendarEvent row) {
    return domain.CalendarEvent(
      id: row.id,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      ownerId: row.ownerId,
      moduleSource: 'events',
      title: row.title,
      description: row.description,
      startDate: row.startDate,
      endDate: row.endDate,
      recurrenceRule: row.recurrenceRule,
      reminderSettings: null,
      status: row.status,
      linkedEntityId: row.linkedEntityId,
    );
  }
}
