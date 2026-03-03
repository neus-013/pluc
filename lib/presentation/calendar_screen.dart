import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/entities.dart';
import 'providers/app_providers.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(calendarViewModeProvider);
    final focusDate = ref.watch(calendarFocusDateProvider);
    final theme = ref.watch(currentThemeProvider);

    // Compute the date range for the current mode so the provider fetches
    // the correct window of data.
    final (start, end) = theme.dateRangeForMode(viewMode, focusDate);
    // Sync selectedDateRangeProvider (drives calendarItemsProvider).
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final current = ref.read(selectedDateRangeProvider);
      if (current.$1 != start || current.$2 != end) {
        ref.read(selectedDateRangeProvider.notifier).state = (start, end);
      }
    });

    final calendarItems = ref.watch(calendarItemsProvider);

    return Column(
      children: [
        theme.buildCalendarToolbar(
          context: context,
          currentMode: viewMode,
          focusDate: focusDate,
          onModeChanged: (mode) {
            ref.read(calendarViewModeProvider.notifier).state = mode;
          },
          onPrevious: () {
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
          },
          onNext: () {
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
          },
          onToday: () {
            final now = DateTime.now();
            ref.read(calendarFocusDateProvider.notifier).state =
                DateTime(now.year, now.month, now.day);
          },
        ),
        Expanded(
          child: () {
            // Keep showing previous data during navigation transitions
            // to avoid full widget tree replacement that breaks AXTree.
            final previousItems = calendarItems.valueOrNull;
            if (calendarItems.isLoading && previousItems == null) {
              return theme.buildLoadingIndicator();
            }
            if (calendarItems.hasError && previousItems == null) {
              return theme.buildErrorState(
                  error: calendarItems.error.toString());
            }
            final items = previousItems ?? [];
            final schedulableItems =
                items.whereType<SchedulableEntity>().toList();
            return theme.buildCalendarView(
              schedulableItems,
              viewMode: viewMode,
              focusDate: focusDate,
            );
          }(),
        ),
      ],
    );
  }
}
