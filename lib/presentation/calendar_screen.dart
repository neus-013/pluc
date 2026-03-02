import 'package:flutter/material.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_providers.dart';

class CalendarScreen extends ConsumerWidget {
  const CalendarScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final (start, end) = ref.watch(selectedDateRangeProvider);
    final calendarItems = ref.watch(calendarItemsProvider);
    final dummyTasks = ref.watch(dummyTasksProvider);
    final dummyEntries = ref.watch(dummyJournalEntriesProvider);

    return Column(
      children: [
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
        Expanded(
          child: calendarItems.when(
            data: (items) {
              // Mix real items with dummy data for MVP
              final allItems = [
                ...dummyTasks.where((t) {
                  final date = t['dueDate'] as DateTime;
                  return date.isAfter(start) && date.isBefore(end);
                }),
                ...dummyEntries.where((e) {
                  final date = e['date'] as DateTime;
                  return date.isAfter(start) && date.isBefore(end);
                }),
                ...items,
              ];

              if (allItems.isEmpty) {
                return Center(
                  child: Text(strings.noEventsThisWeek),
                );
              }

              return ListView.builder(
                itemCount: allItems.length,
                itemBuilder: (context, index) {
                  final item = allItems[index];

                  if (item is Map<String, dynamic>) {
                    final isTask = item.containsKey('completed');
                    return Card(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 8, vertical: 4),
                      child: ListTile(
                        leading: Icon(
                          isTask ? Icons.check_circle : Icons.edit_note,
                          color: isTask
                              ? (item['completed'] ?? false
                                  ? Colors.green
                                  : Colors.orange)
                              : Colors.blue,
                        ),
                        title: Text(
                          isTask
                              ? item['title']
                              : 'Journal: ${item['content']?.substring(0, 30)}...',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                        subtitle: Text(
                          isTask
                              ? 'Due: ${item['dueDate']}'
                              : 'Date: ${item['date']}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        onTap: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text(isTask
                                  ? 'Task: ${item['title']}'
                                  : 'Entry details'),
                            ),
                          );
                        },
                      ),
                    );
                  }

                  // Handle SchedulableItem from repository
                  return Card(
                    margin:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    child: ListTile(
                      leading: const Icon(Icons.event),
                      title: Text('${item.title} (${item.moduleSource})'),
                      subtitle: Text(
                        item.startDate?.toString() ?? 'No date',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                  );
                },
              );
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
