import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/presentation/providers/app_providers.dart';
import '../calendar_helpers.dart';

/// STRUCTURED calendar view — full featured.
///
/// All view modes (day/week/month), time-blocking, recurring events,
/// filters, categories, dense layout, advanced event form.
/// This is the maximum-capability calendar layout.
class StructuredCalendarView extends ConsumerWidget {
  const StructuredCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(calendarViewModeProvider);
    final focusDate = ref.watch(calendarFocusDateProvider);
    final theme = ref.watch(currentThemeProvider);
    final calendarItems = ref.watch(calendarItemsProvider);

    // Sync date range for the current view.
    CalendarInteractionHelper.syncDateRange(ref, theme, viewMode, focusDate);

    return Stack(
      children: [
        Column(
          children: [
            // Full toolbar with all view modes (day / week / month)
            theme.buildCalendarToolbar(
              context: context,
              currentMode: viewMode,
              focusDate: focusDate,
              onModeChanged: (mode) {
                ref.read(calendarViewModeProvider.notifier).state = mode;
              },
              onPrevious: () =>
                  CalendarInteractionHelper.navigatePrevious(ref, viewMode),
              onNext: () =>
                  CalendarInteractionHelper.navigateNext(ref, viewMode),
              onToday: () => CalendarInteractionHelper.navigateToday(ref),
            ),
            // Calendar view
            Expanded(
              child: _buildCalendarBody(
                  context, ref, theme, calendarItems, viewMode, focusDate),
            ),
          ],
        ),
        // FAB — full event dialog
        Positioned(
          right: theme.spacingMd,
          bottom: theme.spacingMd,
          child: theme.buildCreateFab(
            onPressed: () => CalendarInteractionHelper.handleCreateEvent(
              context: context,
              ref: ref,
              theme: theme,
              focusDate: focusDate,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCalendarBody(
    BuildContext context,
    WidgetRef ref,
    dynamic theme,
    AsyncValue<List<dynamic>> calendarItems,
    CalendarViewMode viewMode,
    DateTime focusDate,
  ) {
    final items = CalendarInteractionHelper.extractItems(calendarItems);
    if (items == null) {
      if (calendarItems.hasError) {
        return theme.buildErrorState(error: calendarItems.error.toString());
      }
      return theme.buildLoadingIndicator();
    }
    return theme.buildCalendarView(
      items,
      viewMode: viewMode,
      focusDate: focusDate,
      onItemTap: (entity) => CalendarInteractionHelper.handleItemTap(
        context: context,
        ref: ref,
        entity: entity,
        theme: theme,
      ),
      onToggleComplete: (entity) =>
          CalendarInteractionHelper.handleToggleComplete(
        ref: ref,
        entity: entity,
      ),
    );
  }
}
