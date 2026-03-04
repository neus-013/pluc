import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/domain/entities/task.dart';
import 'package:pluc/core/events/app_events.dart';
import 'package:pluc/core/providers.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/providers/app_providers.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';

/// MINIMAL tasks view — ultra-simple, fast interaction.
///
/// Flat list, checkbox + title, optional due date, no projects,
/// no subtasks, very fast add interaction, large tappable rows.
class MinimalTasksView extends ConsumerStatefulWidget {
  const MinimalTasksView({super.key});

  @override
  ConsumerState<MinimalTasksView> createState() => _MinimalTasksViewState();
}

class _MinimalTasksViewState extends ConsumerState<MinimalTasksView> {
  final _quickAddController = TextEditingController();
  int _refreshKey = 0;

  void _refreshTasks() => setState(() => _refreshKey++);

  @override
  void dispose() {
    _quickAddController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final taskRepo = ref.read(taskRepositoryProvider);
    final eventBus = ref.read(eventBusProvider);
    final userId = ref.read(currentUserIdProvider);
    final theme = ref.watch(currentThemeProvider);

    return Padding(
      padding: EdgeInsets.all(theme.spacingMd),
      child: Column(
        children: [
          // Quick-add field at top — the primary creation method
          _QuickAddRow(
            theme: theme,
            controller: _quickAddController,
            hintText: strings.addTask,
            onSubmit: () =>
                _quickAdd(taskRepo, eventBus, userId, theme, strings),
          ),
          SizedBox(height: theme.spacingSm),
          Divider(height: 1, color: theme.colorScheme.outlineVariant),
          // Flat task list with large tappable rows
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

                final tasks = snapshot.data ?? [];
                if (tasks.isEmpty) {
                  return theme.buildEmptyState(
                    icon: Icons.check_circle_outline,
                    label: strings.noTasksYet,
                    color: theme.colorScheme.outline,
                  );
                }

                // Sort: pending first, then by creation date
                tasks.sort((a, b) {
                  if (a.status == 'completed' && b.status != 'completed') {
                    return 1;
                  }
                  if (a.status != 'completed' && b.status == 'completed') {
                    return -1;
                  }
                  return b.createdAt.compareTo(a.createdAt);
                });

                return ListView.builder(
                  itemCount: tasks.length,
                  itemBuilder: (context, index) {
                    final task = tasks[index];
                    return _MinimalTaskRow(
                      theme: theme,
                      task: task,
                      onToggle: () =>
                          _toggleComplete(task, taskRepo, userId, theme),
                      onTap: () => _editTask(task, taskRepo, theme),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _quickAdd(dynamic taskRepo, dynamic eventBus, String userId,
      AppThemeConfig theme, AppLocalizations strings) async {
    final title = _quickAddController.text.trim();
    if (title.isEmpty) return;

    try {
      final now = DateTime.now();
      final taskId = 'task_${now.millisecondsSinceEpoch}';
      final task = Task(
        id: taskId,
        createdAt: now,
        updatedAt: now,
        ownerId: userId,
        moduleSource: 'tasks',
        title: title,
        description: '',
        status: 'pending',
      );
      await taskRepo.saveTask(task);
      await eventBus.emit(TaskCreatedEvent(
        taskId: taskId,
        title: title,
        userId: userId,
      ));
      _quickAddController.clear();
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

  Future<void> _toggleComplete(
      Task task, dynamic taskRepo, String userId, AppThemeConfig theme) async {
    try {
      final newStatus = task.status == 'completed' ? 'pending' : 'completed';
      await taskRepo.saveTask(
          task.copyWith(status: newStatus, updatedAt: DateTime.now()));
      _refreshTasks();
      ref.read(calendarRefreshKeyProvider.notifier).state++;
    } catch (e) {
      if (mounted) {
        theme.showErrorSnackbar(context, '$e');
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
}

/// Quick-add input field with submit button — inline task creation.
class _QuickAddRow extends StatelessWidget {
  final AppThemeConfig theme;
  final TextEditingController controller;
  final String hintText;
  final VoidCallback onSubmit;

  const _QuickAddRow({
    required this.theme,
    required this.controller,
    required this.hintText,
    required this.onSubmit,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            style: theme.textTheme.bodyMedium,
            decoration: InputDecoration(
              hintText: hintText,
              hintStyle: theme.textTheme.bodySmall,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(theme.borderRadiusSm),
              ),
              contentPadding: EdgeInsets.symmetric(
                horizontal: theme.spacingSm + 4,
                vertical: theme.spacingSm + 2,
              ),
              isDense: true,
            ),
            onSubmitted: (_) => onSubmit(),
          ),
        ),
        SizedBox(width: theme.spacingSm),
        IconButton.filled(
          icon: const Icon(Icons.add),
          onPressed: onSubmit,
          style: IconButton.styleFrom(
            backgroundColor: theme.colorScheme.primary,
            foregroundColor: theme.colorScheme.onPrimary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(theme.borderRadiusSm),
            ),
          ),
        ),
      ],
    );
  }
}

/// Large tappable row with checkbox + title — minimal task display.
class _MinimalTaskRow extends StatelessWidget {
  final AppThemeConfig theme;
  final Task task;
  final VoidCallback onToggle;
  final VoidCallback onTap;

  const _MinimalTaskRow({
    required this.theme,
    required this.task,
    required this.onToggle,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isCompleted = task.status == 'completed';

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(theme.borderRadiusSm),
      child: Container(
        padding: EdgeInsets.symmetric(
          horizontal: theme.spacingSm,
          vertical: theme.spacingMd,
        ),
        decoration: BoxDecoration(
          border: Border(
            bottom: BorderSide(
              color: theme.colorScheme.outlineVariant.withValues(alpha: 0.3),
            ),
          ),
        ),
        child: Row(
          children: [
            // Large checkbox
            SizedBox(
              width: 32,
              height: 32,
              child: Checkbox(
                value: isCompleted,
                onChanged: (_) => onToggle(),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(theme.spacingXs),
                ),
                activeColor: theme.colorScheme.primary,
              ),
            ),
            SizedBox(width: theme.spacingSm + 4),
            // Title
            Expanded(
              child: Text(
                task.title,
                style: theme.textTheme.bodyMedium?.copyWith(
                  decoration: isCompleted ? TextDecoration.lineThrough : null,
                  color: isCompleted
                      ? theme.colorScheme.outline
                      : theme.colorScheme.onSurface,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            // Optional due date indicator
            if (task.startDate != null)
              Padding(
                padding: EdgeInsets.only(left: theme.spacingSm),
                child: Text(
                  '${task.startDate!.day.toString().padLeft(2, '0')}/${task.startDate!.month.toString().padLeft(2, '0')}',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
