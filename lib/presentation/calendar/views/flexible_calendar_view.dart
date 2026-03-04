import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/providers/app_providers.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';
import '../calendar_helpers.dart';

/// FLEXIBLE calendar view — balanced, commonly-used features.
///
/// Month + simple day view, basic event creation, optional color tag,
/// medium density, simple editing. No week view.
class FlexibleCalendarView extends ConsumerWidget {
  const FlexibleCalendarView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewMode = ref.watch(calendarViewModeProvider);
    final focusDate = ref.watch(calendarFocusDateProvider);
    final theme = ref.watch(currentThemeProvider);
    final calendarItems = ref.watch(calendarItemsProvider);
    final strings = AppLocalizations.of(context)!;

    // Ensure view mode is month or day (no week in flexible).
    final effectiveMode =
        viewMode == CalendarViewMode.week ? CalendarViewMode.month : viewMode;

    // Auto-correct if we're in week mode.
    if (viewMode == CalendarViewMode.week) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        ref.read(calendarViewModeProvider.notifier).state =
            CalendarViewMode.month;
      });
    }

    // Sync date range.
    CalendarInteractionHelper.syncDateRange(
        ref, theme, effectiveMode, focusDate);

    return Stack(
      children: [
        Column(
          children: [
            // Simplified toolbar with month / day only
            _FlexibleToolbar(
              theme: theme,
              currentMode: effectiveMode,
              focusDate: focusDate,
              strings: strings,
              onModeChanged: (mode) {
                ref.read(calendarViewModeProvider.notifier).state = mode;
              },
              onPrevious: () => CalendarInteractionHelper.navigatePrevious(
                  ref, effectiveMode),
              onNext: () =>
                  CalendarInteractionHelper.navigateNext(ref, effectiveMode),
              onToday: () => CalendarInteractionHelper.navigateToday(ref),
            ),
            // Calendar view (month or day)
            Expanded(
              child: _buildCalendarBody(
                  context, ref, theme, calendarItems, effectiveMode, focusDate),
            ),
          ],
        ),
        // FAB — standard event dialog
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

/// Simplified toolbar showing only Month / Day segments.
class _FlexibleToolbar extends StatelessWidget {
  final AppThemeConfig theme;
  final CalendarViewMode currentMode;
  final DateTime focusDate;
  final AppLocalizations strings;
  final ValueChanged<CalendarViewMode> onModeChanged;
  final VoidCallback onPrevious;
  final VoidCallback onNext;
  final VoidCallback onToday;

  const _FlexibleToolbar({
    required this.theme,
    required this.currentMode,
    required this.focusDate,
    required this.strings,
    required this.onModeChanged,
    required this.onPrevious,
    required this.onNext,
    required this.onToday,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: theme.spacingSm,
        vertical: theme.spacingXs + 2,
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: onToday,
            tooltip: strings.today,
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
          ),
          SizedBox(width: theme.spacingXs),
          Expanded(
            child: Text(
              _toolbarTitle(),
              style: theme.textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(width: theme.spacingXs),
          SegmentedButton<CalendarViewMode>(
            segments: [
              ButtonSegment(
                value: CalendarViewMode.month,
                label: Text(strings.month),
              ),
              ButtonSegment(
                value: CalendarViewMode.day,
                label: Text(strings.day),
              ),
            ],
            selected: {currentMode},
            onSelectionChanged: (s) => onModeChanged(s.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: WidgetStatePropertyAll(theme.textTheme.bodySmall),
            ),
          ),
        ],
      ),
    );
  }

  String _toolbarTitle() {
    if (currentMode == CalendarViewMode.day) {
      return '${focusDate.day.toString().padLeft(2, '0')}/${focusDate.month.toString().padLeft(2, '0')}/${focusDate.year}';
    }
    return _monthName(focusDate.month, focusDate.year);
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
