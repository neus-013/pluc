import 'package:flutter/material.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/domain/entities/task.dart';
import 'package:pluc/core/events/app_events.dart';
import 'package:pluc/core/providers.dart';
import 'providers/app_providers.dart';

class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  int _refreshKey = 0;

  void _refreshTasks() {
    setState(() {
      _refreshKey++;
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final taskRepo = ref.read(taskRepositoryProvider);
    final eventBus = ref.read(eventBusProvider);
    final userId = ref.read(currentUserIdProvider);
    final theme = ref.watch(currentThemeProvider);

    return Stack(
      children: [
        // Task list
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              theme.buildSectionHeader(
                icon: Icons.list,
                title: strings.tasks,
                iconColor: Colors.blue,
                onRefresh: _refreshTasks,
              ),
              const Divider(height: 1),
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
                        label: strings.tasks,
                        color: Colors.grey,
                      );
                    }

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
                              final updated = task.copyWith(
                                status: newStatus,
                                updatedAt: DateTime.now(),
                              );
                              await taskRepo.saveTask(updated);
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
                                if (mounted) {
                                  theme.showSuccessSnackbar(
                                      context, strings.delete);
                                }
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
        // FAB – create new task via dialog
        Positioned(
          right: 16,
          bottom: 16,
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

                  await eventBus.emit(
                    TaskCreatedEvent(
                      taskId: taskId,
                      title: task.title,
                      userId: userId,
                    ),
                  );

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
