import 'package:flutter/material.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/entities.dart';
import 'providers/app_providers.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final (start, end) = ref.watch(selectedDateRangeProvider);
    final calendarItems = ref.watch(calendarItemsProvider);
    final theme = ref.watch(currentThemeProvider);

    return Column(
      children: [
        // Date navigation controls
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                icon: const Icon(Icons.arrow_back),
                onPressed: () {
                  final newStart = start.subtract(const Duration(days: 7));
                  final newEnd = end.subtract(const Duration(days: 7));
                  ref.read(selectedDateRangeProvider.notifier).state =
                      (newStart, newEnd);
                },
              ),
              Text(
                '${start.toString().split(' ')[0]} - ${end.toString().split(' ')[0]}',
                style: Theme.of(context).textTheme.titleMedium,
              ),
              IconButton(
                icon: const Icon(Icons.arrow_forward),
                onPressed: () {
                  final newStart = start.add(const Duration(days: 7));
                  final newEnd = end.add(const Duration(days: 7));
                  ref.read(selectedDateRangeProvider.notifier).state =
                      (newStart, newEnd);
                },
              ),
            ],
          ),
        ),
        // Calendar view delegated to theme configuration
        // This allows themes to control calendar presentation:
        // - Grid calendar vs timeline vs list view
        // - Visual density and spacing
        // - Item display format
        Expanded(
          child: calendarItems.when(
            data: (items) {
              // Filter to only SchedulableEntity items
              final schedulableItems = items
                  .whereType<SchedulableEntity>()
                  .toList();
              
              // Delegate rendering to theme
              return theme.buildCalendarView(schedulableItems);
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(
              child: Text('${strings.error}: $error'),
            ),
          ),
        ),
      ],
    );
  }
}
