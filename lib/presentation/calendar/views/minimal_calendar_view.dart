import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/providers/app_providers.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';
import '../calendar_helpers.dart';

/// MINIMAL calendar view — ultra-clean, focused.
///
/// Single month overview, tap-to-add simple event, no recurrence,
/// no filters, no categories, very clean layout, small event modal.
class MinimalCalendarView extends ConsumerWidget {
  const MinimalCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final focusDate = ref.watch(calendarFocusDateProvider);
    final theme = ref.watch(currentThemeProvider);
    final calendarItems = ref.watch(calendarItemsProvider);
    final strings = AppLocalizations.of(context)!;

    // Force month mode for minimal preset.
    const viewMode = CalendarViewMode.month;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (ref.read(calendarViewModeProvider) != CalendarViewMode.month) {
        ref.read(calendarViewModeProvider.notifier).state =
            CalendarViewMode.month;
      }
    });

    // Sync date range.
    CalendarInteractionHelper.syncDateRange(ref, theme, viewMode, focusDate);

    return Stack(
      children: [
        Column(
          children: [
            // Minimal navigation — just arrows + month title
            _MinimalToolbar(
              theme: theme,
              focusDate: focusDate,
              strings: strings,
              onPrevious: () =>
                  CalendarInteractionHelper.navigatePrevious(ref, viewMode),
              onNext: () =>
                  CalendarInteractionHelper.navigateNext(ref, viewMode),
              onToday: () => CalendarInteractionHelper.navigateToday(ref),
            ),
            // Hint text
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: theme.spacingMd,
                vertical: theme.spacingXs,
              ),
              child: Text(
                strings.tapToAddEvent,
                style: theme.textTheme.bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            // Month-only calendar view
            Expanded(
              child: _buildCalendarBody(
                  context, ref, theme, calendarItems, focusDate),
            ),
          ],
        ),
        // Clean FAB
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
    AppThemeConfig theme,
    AsyncValue<List<dynamic>> calendarItems,
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
      viewMode: CalendarViewMode.month,
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

/// Ultra-minimal toolbar — navigation arrows + month/year title only.
class _MinimalToolbar extends StatelessWidget {
  final AppThemeConfig theme;
  final DateTime focusDate;
  final AppLocalizations strings;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const _MinimalToolbar({
    required this.theme,
    required this.focusDate,
    required this.strings,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacingSm,
        vertical: theme.spacingSm,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          Expanded(
            child: GestureDetector(
              onTap: onToday,
              child: Text(
                _monthName(focusDate.month, focusDate.year),
                style: theme.textTheme.titleMedium,
                textAlign: TextAlign.center,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
        ],
      ),
    );
  }

  static String _monthName(int month, int year) {
    const months = [
      '',
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December',
    ];
    return '${months[month]} $year';
  }
}
