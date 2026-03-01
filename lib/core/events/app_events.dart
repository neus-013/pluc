/// Base class for all events in the application.
/// Provides a type-safe way to emit and listen to domain events.
abstract class AppEvent {
  final DateTime timestamp;

  AppEvent({DateTime? timestamp}) : timestamp = timestamp ?? DateTime.now();
}

// ============================================================================
// TASK EVENTS
// ============================================================================

class TaskCreatedEvent extends AppEvent {
  final String taskId;
  final String title;
  final String userId;

  TaskCreatedEvent({
    required this.taskId,
    required this.title,
    required this.userId,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

class TaskCompletedEvent extends AppEvent {
  final String taskId;
  final String userId;

  TaskCompletedEvent({
    required this.taskId,
    required this.userId,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

class TaskUpdatedEvent extends AppEvent {
  final String taskId;
  final String userId;
  final Map<String, dynamic> changes;

  TaskUpdatedEvent({
    required this.taskId,
    required this.userId,
    required this.changes,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

// ============================================================================
// JOURNAL EVENTS
// ============================================================================

class JournalEntryCreatedEvent extends AppEvent {
  final String entryId;
  final String userId;
  final DateTime date;

  JournalEntryCreatedEvent({
    required this.entryId,
    required this.userId,
    required this.date,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

class JournalEntryUpdatedEvent extends AppEvent {
  final String entryId;
  final String userId;

  JournalEntryUpdatedEvent({
    required this.entryId,
    required this.userId,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

// ============================================================================
// MODULE EVENTS
// ============================================================================

class ModuleEnabledEvent extends AppEvent {
  final String moduleId;
  final String moduleName;

  ModuleEnabledEvent({
    required this.moduleId,
    required this.moduleName,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

class ModuleDisabledEvent extends AppEvent {
  final String moduleId;
  final String moduleName;

  ModuleDisabledEvent({
    required this.moduleId,
    required this.moduleName,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

class PresetAppliedEvent extends AppEvent {
  final String moduleId;
  final String presetId;
  final List<String> enabledFeatures;
  final List<String> disabledFeatures;

  PresetAppliedEvent({
    required this.moduleId,
    required this.presetId,
    required this.enabledFeatures,
    required this.disabledFeatures,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

// ============================================================================
// AUTHENTICATION EVENTS
// ============================================================================

class UserSignedInEvent extends AppEvent {
  final String userId;
  final String username;

  UserSignedInEvent({
    required this.userId,
    required this.username,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}

class UserSignedOutEvent extends AppEvent {
  UserSignedOutEvent({DateTime? timestamp}) : super(timestamp: timestamp);
}

// ============================================================================
// CALENDAR EVENTS
// ============================================================================

class CalendarRefreshEvent extends AppEvent {
  final DateTime rangeStart;
  final DateTime rangeEnd;

  CalendarRefreshEvent({
    required this.rangeStart,
    required this.rangeEnd,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}
