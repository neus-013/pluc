import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/entities.dart';
import 'package:pluc/core/providers.dart';
import 'package:pluc/features/calendar/domain/entities/calendar_event.dart';
import 'package:pluc/presentation/providers/app_providers.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';

/// Shared interaction helpers for all calendar preset views.
///
/// Extracts common business logic (item taps, toggle complete, event creation)
/// so that preset views only differ in structural layout.
class CalendarInteractionHelper {
  CalendarInteractionHelper._();

  /// Handle tap on a calendar item — opens the appropriate edit dialog
  /// based on module source (tasks, journal, events).
  static Future<void> handleItemTap({
    required BuildContext context,
    required WidgetRef ref,
    required dynamic entity,
    required AppThemeConfig theme,
  }) async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final eventRepo = ref.read(calendarEventRepositoryProvider);
    final journalRepo = ref.read(journalRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);

    final String moduleSource = entity.moduleSource;
    final String entityId = entity.id;

    if (moduleSource == 'tasks') {
      final task = await taskRepo.getTaskById(entityId, userId);
      if (task != null && context.mounted) {
        final edited = await theme.showTaskDialog(
          context: context,
          existingTask: task,
        );
        if (edited != null) {
          await taskRepo.saveTask(edited.copyWith(updatedAt: DateTime.now()));
          ref.read(calendarRefreshKeyProvider.notifier).state++;
        }
      }
    } else if (moduleSource == 'journal') {
      final entry = await journalRepo.getEntryById(entityId, userId);
      if (entry != null && context.mounted) {
        final edited = await theme.showJournalDialog(
          context: context,
          existingEntry: entry,
        );
        if (edited != null) {
          await journalRepo
              .saveEntry(edited.copyWith(updatedAt: DateTime.now()));
          ref.read(calendarRefreshKeyProvider.notifier).state++;
        }
      }
    } else if (moduleSource == 'events') {
      final event = await eventRepo.getEventById(entityId, userId);
      if (event != null && context.mounted) {
        final edited = await theme.showEventDialog(
          context: context,
          existingEvent: event,
        );
        if (edited != null) {
          await eventRepo.saveEvent(edited.copyWith(updatedAt: DateTime.now()));
          ref.read(calendarRefreshKeyProvider.notifier).state++;
        }
      }
    }
  }

  /// Toggle completion status for task items on the calendar.
  static Future<void> handleToggleComplete({
    required WidgetRef ref,
    required dynamic entity,
  }) async {
    final taskRepo = ref.read(taskRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);

    if (entity.moduleSource == 'tasks') {
      final task = await taskRepo.getTaskById(entity.id, userId);
      if (task != null) {
        final newStatus = task.status == 'completed' ? 'pending' : 'completed';
        final updated = task.copyWith(
          status: newStatus,
          updatedAt: DateTime.now(),
        );
        await taskRepo.saveTask(updated);
        ref.read(calendarRefreshKeyProvider.notifier).state++;
      }
    }
  }

  /// Create a new calendar event through the event dialog, then persist it.
  static Future<void> handleCreateEvent({
    required BuildContext context,
    required WidgetRef ref,
    required AppThemeConfig theme,
    required DateTime focusDate,
  }) async {
    final eventRepo = ref.read(calendarEventRepositoryProvider);
    final userId = ref.read(currentUserIdProvider);

    final created = await theme.showEventDialog(
      context: context,
      initialDate: focusDate,
    );
    if (created != null) {
      final now = DateTime.now();
      final eventToSave = CalendarEvent(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        createdAt: now,
        updatedAt: now,
        ownerId: userId,
        moduleSource: 'events',
        title: created.title,
        description: created.description,
        startDate: created.startDate,
        endDate: created.endDate,
        status: created.status,
      );
      await eventRepo.saveEvent(eventToSave);
      ref.read(calendarRefreshKeyProvider.notifier).state++;
    }
  }

  /// Navigate to previous period for the given view mode.
  static void navigatePrevious(WidgetRef ref, CalendarViewMode viewMode) {
    final current = ref.read(calendarFocusDateProvider);
    switch (viewMode) {
      case CalendarViewMode.day:
        ref.read(calendarFocusDateProvider.notifier).state =
            current.subtract(const Duration(days: 1));
        break;
      case CalendarViewMode.week:
        ref.read(calendarFocusDateProvider.notifier).state =
            current.subtract(const Duration(days: 7));
        break;
      case CalendarViewMode.month:
        ref.read(calendarFocusDateProvider.notifier).state =
            DateTime(current.year, current.month - 1, 1);
        break;
    }
  }

  /// Navigate to next period for the given view mode.
  static void navigateNext(WidgetRef ref, CalendarViewMode viewMode) {
    final current = ref.read(calendarFocusDateProvider);
    switch (viewMode) {
      case CalendarViewMode.day:
        ref.read(calendarFocusDateProvider.notifier).state =
            current.add(const Duration(days: 1));
        break;
      case CalendarViewMode.week:
        ref.read(calendarFocusDateProvider.notifier).state =
            current.add(const Duration(days: 7));
        break;
      case CalendarViewMode.month:
        ref.read(calendarFocusDateProvider.notifier).state =
            DateTime(current.year, current.month + 1, 1);
        break;
    }
  }

  /// Navigate to today.
  static void navigateToday(WidgetRef ref) {
    final now = DateTime.now();
    ref.read(calendarFocusDateProvider.notifier).state =
        DateTime(now.year, now.month, now.day);
  }

  /// Sync the date range provider to match the current view mode + focus.
  static void syncDateRange(
    WidgetRef ref,
    AppThemeConfig theme,
    CalendarViewMode viewMode,
    DateTime focusDate,
  ) {
    final (start, end) = theme.dateRangeForMode(viewMode, focusDate);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(selectedDateRangeProvider);
      if (current.$1 != start || current.$2 != end) {
        ref.read(selectedDateRangeProvider.notifier).state = (start, end);
      }
    });
  }

  /// Extract schedulable items from the async provider value.
  /// Returns null if still loading with no previous data.
  static List<SchedulableEntity>? extractItems(
    AsyncValue<List<dynamic>> calendarItems,
  ) {
    final previousItems = calendarItems.valueOrNull;
    if (calendarItems.isLoading && previousItems == null) return null;
    if (calendarItems.hasError && previousItems == null) return null;
    final items = previousItems ?? [];
    return items.whereType<SchedulableEntity>().toList();
  }
}
