import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'auth_repository.dart';
import 'auth/local_auth_repository.dart';
import 'database.dart';
import 'domain/repositories/task_repository.dart';
import 'data/repositories/task_repository_impl.dart';
import 'package:pluc/features/journal/domain/repositories/journal_repository.dart';
import 'package:pluc/features/journal/data/repositories/journal_repository_impl.dart';
import 'package:pluc/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:pluc/features/calendar/data/repositories/calendar_repository_impl.dart';
import 'package:pluc/features/calendar/domain/repositories/calendar_event_repository.dart';
import 'package:pluc/features/calendar/data/repositories/calendar_event_repository_impl.dart';
import 'events/event_bus.dart';
import 'services/preset_service.dart';

/// ============================================================================
/// DATABASE PROVIDER
/// ============================================================================
final databaseProvider = Provider<AppDatabase>((ref) {
  return AppDatabase();
});

/// ============================================================================
/// AUTH REPOSITORY PROVIDER
/// ============================================================================
final authRepositoryProvider = Provider<AuthRepository>((ref) {
  final db = ref.read(databaseProvider);
  return LocalAuthRepository(db);
});

/// ============================================================================
/// TASK REPOSITORY PROVIDER
/// ============================================================================
final taskRepositoryProvider = Provider<TaskRepository>((ref) {
  final db = ref.read(databaseProvider);
  return TaskRepositoryImpl(db);
});

/// ============================================================================
/// JOURNAL REPOSITORY PROVIDER
/// ============================================================================
final journalRepositoryProvider = Provider<JournalRepository>((ref) {
  final db = ref.read(databaseProvider);
  return JournalRepositoryImpl(db);
});

/// ============================================================================
/// CALENDAR EVENT REPOSITORY PROVIDER
/// ============================================================================
final calendarEventRepositoryProvider =
    Provider<CalendarEventRepository>((ref) {
  final db = ref.read(databaseProvider);
  return CalendarEventRepositoryImpl(db);
});

/// ============================================================================
/// CALENDAR REPOSITORY PROVIDER
/// Depends on other repositories; never accesses DB directly
/// ============================================================================
final calendarRepositoryProvider = Provider<CalendarRepository>((ref) {
  final taskRepo = ref.read(taskRepositoryProvider);
  final journalRepo = ref.read(journalRepositoryProvider);
  final eventRepo = ref.read(calendarEventRepositoryProvider);
  return CalendarRepositoryImpl(
    taskRepository: taskRepo,
    journalRepository: journalRepo,
    calendarEventRepository: eventRepo,
  );
});

/// ============================================================================
/// EVENT BUS PROVIDER
/// Strongly typed, broadcast-safe event system.
/// New instance per widget tree (not a static singleton).
/// ============================================================================
final eventBusProvider = Provider<EventBus>((ref) {
  return EventBus();
});

/// ============================================================================
/// PRESET SERVICE PROVIDER
/// Handles applying preset configurations to features.
/// ============================================================================
final presetServiceProvider = Provider<PresetService>((ref) {
  final eventBus = ref.read(eventBusProvider);
  return PresetService(eventBus: eventBus);
});
