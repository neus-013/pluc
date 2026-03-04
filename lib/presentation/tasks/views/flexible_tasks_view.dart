import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/domain/entities/task.dart';
import 'package:pluc/core/events/app_events.dart';
import 'package:pluc/core/providers.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/providers/app_providers.dart';

/// FLEXIBLE tasks view — balanced, clean list.
///
/// Tasks with optional due date, optional simple tags, basic sorting,
/// clean list UI, lightweight editor. No projects, subtasks, or bulk actions.
class FlexibleTasksView extends ConsumerStatefulWidget {
  const FlexibleTasksView({super.key});

  @override
  ConsumerState<FlexibleTasksView> createState() => _FlexibleTasksViewState();
}

class _FlexibleTasksViewState extends ConsumerState<FlexibleTasksView> {
  int _refreshKey = 0;

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
              theme.buildSectionHeader(
                icon: Icons.check_circle_outline,
                title: strings.tasks,
                iconColor: theme.colorScheme.primary,
                onRefresh: _refreshTasks,
              ),
              Divider(height: 1, color: theme.colorScheme.outlineVariant),
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
                        icon: Icons.task_alt,
                        label: strings.noTasksYet,
                        color: theme.colorScheme.outline,
                      );
                    }

                    // Simple sort: newest first by default
                    tasks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

                    return ListView.builder(
                      itemCount: tasks.length,
                      itemBuilder: (context, index) {
                        final task = tasks[index];
                        return theme.buildTaskCard(
                          task,
                          onToggleComplete: () async {
                            try {
                              final newStatus = task.status == 'completed'
                                  ? 'pending'
                                  : 'completed';
                              await taskRepo.saveTask(task.copyWith(
                                status: newStatus,
                                updatedAt: DateTime.now(),
                              ));
                              _refreshTasks();
                              ref
                                  .read(calendarRefreshKeyProvider.notifier)
                                  .state++;
                              if (mounted) {
                                theme.showSuccessSnackbar(
                                    context, strings.taskUpdated);
                              }
                            } catch (e) {
                              if (mounted) {
                                theme.showErrorSnackbar(
                                    context, '${strings.error}: $e');
                              }
                            }
                          },
                          onTap: () async {
                            final edited = await theme.showTaskDialog(
                              context: context,
                              existingTask: task,
                            );
                            if (edited != null) {
                              try {
                                await taskRepo.saveTask(edited);
                                _refreshTasks();
                                ref
                                    .read(calendarRefreshKeyProvider.notifier)
                                    .state++;
                                if (mounted) {
                                  theme.showSuccessSnackbar(
                                      context, strings.taskUpdated);
                                }
                              } catch (e) {
                                if (mounted) {
                                  theme.showErrorSnackbar(
                                      context, '${strings.error}: $e');
                                }
                              }
                            }
                          },
                          onDelete: () async {
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
                                ref
                                    .read(calendarRefreshKeyProvider.notifier)
                                    .state++;
                              } catch (e) {
                                if (mounted) {
                                  theme.showErrorSnackbar(
                                      context, '${strings.error}: $e');
                                }
                              }
                            }
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ],
          ),
        ),
        // FAB — standard task dialog
        Positioned(
          right: theme.spacingMd,
          bottom: theme.spacingMd,
          child: theme.buildCreateFab(
            onPressed: () async {
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
            },
          ),
        ),
      ],
    );
  }
}
