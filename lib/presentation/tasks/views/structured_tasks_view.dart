import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/domain/entities/task.dart';
import 'package:pluc/core/events/app_events.dart';
import 'package:pluc/core/providers.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/providers/app_providers.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';

/// STRUCTURED tasks view — full featured.
///
/// Projects, subtasks, priorities, tags, due dates, filtering + sorting,
/// kanban or advanced list, bulk actions, detailed task screen.
class StructuredTasksView extends ConsumerStatefulWidget {
  const StructuredTasksView({super.key});

  @override
  ConsumerState<StructuredTasksView> createState() =>
      _StructuredTasksViewState();
}

class _StructuredTasksViewState extends ConsumerState<StructuredTasksView> {
  int _refreshKey = 0;
  String _sortBy = 'dateCreated';
  String? _filterStatus;

  void _refreshTasks() => setState(() => _refreshKey++);

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final taskRepo = ref.read(taskRepositoryProvider);
    final eventBus = ref.read(eventBusProvider);
    final userId = ref.read(currentUserIdProvider);
    final theme = ref.watch(currentThemeProvider);

    return Stack(
      children: [
        Padding(
          padding: EdgeInsets.all(theme.spacingMd),
          child: Column(
            children: [
              // Section header with refresh
              theme.buildSectionHeader(
                icon: Icons.list_alt,
                title: strings.tasks,
                iconColor: theme.colorScheme.primary,
                onRefresh: _refreshTasks,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
              // Sort / Filter bar
              _StructuredControlBar(
                theme: theme,
                strings: strings,
                sortBy: _sortBy,
                filterStatus: _filterStatus,
                onSortChanged: (v) => setState(() => _sortBy = v),
                onFilterChanged: (v) => setState(() => _filterStatus = v),
              ),
              SizedBox(height: theme.spacingSm),
              // Task list
              Expanded(
                child: FutureBuilder<List<Task>>(
                  key: ValueKey(_refreshKey),
                  future: taskRepo.getTasksForUser(userId),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return theme.buildLoadingIndicator();
                    }
                    if (snapshot.hasError) {
                      return theme.buildErrorState(
                          error: snapshot.error.toString());
                    }

                    var tasks = snapshot.data ?? [];
                    if (tasks.isEmpty) {
                      return theme.buildEmptyState(
                        icon: Icons.task_alt,
                        label: strings.noTasksYet,
                        color: theme.colorScheme.outline,
                      );
                    }

                    // Apply filter
                    if (_filterStatus != null) {
                      tasks = tasks
                          .where((t) => t.status == _filterStatus)
                          .toList();
                    }

                    // Apply sort
                    tasks = _sortTasks(tasks, _sortBy);

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return theme.buildTaskCard(
                          task,
                          onToggleComplete: () =>
                              _toggleComplete(task, taskRepo, userId),
                          onTap: () => _editTask(task, taskRepo, theme),
                          onDelete: () => _deleteTask(
                              task, taskRepo, userId, theme, strings),
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // FAB — full task dialog
        Positioned(
          right: theme.spacingMd,
          bottom: theme.spacingMd,
          child: theme.buildCreateFab(
            onPressed: () =>
                _createTask(taskRepo, eventBus, userId, theme, strings),
          ),
        ),
      ],
    );
  }

  List<Task> _sortTasks(List<Task> tasks, String sortBy) {
    switch (sortBy) {
      case 'alphabetical':
        return tasks..sort((a, b) => a.title.compareTo(b.title));
      case 'dueDate':
        return tasks
          ..sort((a, b) {
            if (a.startDate == null && b.startDate == null) return 0;
            if (a.startDate == null) return 1;
            if (b.startDate == null) return -1;
            return a.startDate!.compareTo(b.startDate!);
          });
      case 'dateCreated':
      default:
        return tasks..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    }
  }

  Future<void> _toggleComplete(
      Task task, dynamic taskRepo, String userId) async {
    try {
      final newStatus = task.status == 'completed' ? 'pending' : 'completed';
      await taskRepo.saveTask(
          task.copyWith(status: newStatus, updatedAt: DateTime.now()));
      _refreshTasks();
      ref.read(calendarRefreshKeyProvider.notifier).state++;
    } catch (e) {
      if (mounted) {
        ref.read(currentThemeProvider).showErrorSnackbar(context, '$e');
      }
    }
  }

  Future<void> _editTask(
      Task task, dynamic taskRepo, AppThemeConfig theme) async {
    final edited = await theme.showTaskDialog(
      context: context,
      existingTask: task,
    );
    if (edited != null) {
      try {
        await taskRepo.saveTask(edited);
        _refreshTasks();
        ref.read(calendarRefreshKeyProvider.notifier).state++;
      } catch (e) {
        if (mounted) {
          theme.showErrorSnackbar(context, '$e');
        }
      }
    }
  }

  Future<void> _deleteTask(Task task, dynamic taskRepo, String userId,
      AppThemeConfig theme, AppLocalizations strings) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => theme.buildConfirmDialog(
        context: ctx,
        title: strings.delete,
        content: '${strings.delete} "${task.title}"?',
        confirmLabel: strings.delete,
        cancelLabel: strings.cancel,
        onConfirm: () {},
      ),
    );
    if (confirmed == true) {
      try {
        await taskRepo.deleteTask(task.id, userId);
        _refreshTasks();
        ref.read(calendarRefreshKeyProvider.notifier).state++;
      } catch (e) {
        if (mounted) {
          theme.showErrorSnackbar(context, '$e');
        }
      }
    }
  }

  Future<void> _createTask(dynamic taskRepo, dynamic eventBus, String userId,
      AppThemeConfig theme, AppLocalizations strings) async {
    final newTask = await theme.showTaskDialog(context: context);
    if (newTask != null) {
      try {
        final now = DateTime.now();
        final taskId = 'task_${now.millisecondsSinceEpoch}';
        final task = newTask.copyWith(
          id: taskId,
          createdAt: now,
          updatedAt: now,
          ownerId: userId,
          moduleSource: 'tasks',
        );
        await taskRepo.saveTask(task);
        await eventBus.emit(TaskCreatedEvent(
          taskId: taskId,
          title: task.title,
          userId: userId,
        ));
        _refreshTasks();
        ref.read(calendarRefreshKeyProvider.notifier).state++;
        if (mounted) {
          theme.showSuccessSnackbar(context, strings.taskCreated);
        }
      } catch (e) {
        if (mounted) {
          theme.showErrorSnackbar(context, '${strings.error}: $e');
        }
      }
    }
  }
}

/// Sort/Filter control bar for structured tasks.
class _StructuredControlBar extends StatelessWidget {
  final AppThemeConfig theme;
  final AppLocalizations strings;
  final String sortBy;
  final String? filterStatus;
  final ValueChanged<String> onSortChanged;
  final ValueChanged<String?> onFilterChanged;

  const _StructuredControlBar({
    required this.theme,
    required this.strings,
    required this.sortBy,
    required this.filterStatus,
    required this.onSortChanged,
    required this.onFilterChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: theme.spacingSm),
      child: Row(
        children: [
          // Sort dropdown
          Icon(Icons.sort, size: 18, color: theme.colorScheme.onSurfaceVariant),
          SizedBox(width: theme.spacingXs),
          DropdownButton<String>(
            value: sortBy,
            isDense: true,
            underline: const SizedBox.shrink(),
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurface,
            ),
            items: [
              DropdownMenuItem(
                  value: 'dateCreated', child: Text(strings.dateCreated)),
              DropdownMenuItem(
                  value: 'alphabetical', child: Text(strings.alphabetical)),
              DropdownMenuItem(value: 'dueDate', child: Text(strings.dueDate)),
            ],
            onChanged: (v) {
              if (v != null) onSortChanged(v);
            },
          ),
          const Spacer(),
          // Filter chips
          ChoiceChip(
            label: Text(strings.allTasks),
            selected: filterStatus == null,
            onSelected: (_) => onFilterChanged(null),
            visualDensity: VisualDensity.compact,
            labelStyle: theme.textTheme.bodySmall,
          ),
          SizedBox(width: theme.spacingXs),
          ChoiceChip(
            label: Text(strings.pendingTasks),
            selected: filterStatus == 'pending',
            onSelected: (_) => onFilterChanged('pending'),
            visualDensity: VisualDensity.compact,
            labelStyle: theme.textTheme.bodySmall,
          ),
          SizedBox(width: theme.spacingXs),
          ChoiceChip(
            label: Text(strings.completedTasks),
            selected: filterStatus == 'completed',
            onSelected: (_) => onFilterChanged('completed'),
            visualDensity: VisualDensity.compact,
            labelStyle: theme.textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
