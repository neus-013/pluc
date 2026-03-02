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
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  DateTime? _selectedDate;
  bool _saving = false;
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
    final modulePresets = ref.watch(modulePresetsProvider);
    final selectedPreset = modulePresets['tasks'] ?? 'flexible';
    final featureToggles = ref.watch(featureTogglesProvider);
    final taskToggles = featureToggles['tasks'] ?? [];

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          // Task List Section
          Expanded(
            flex: 3,
            child: Card(
              margin: EdgeInsets.only(bottom: 16),
              child: Column(
                children: [
                  Padding(
                    padding: EdgeInsets.all(12),
                    child: Row(
                      children: [
                        Icon(Icons.list, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          strings.tasks,
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Spacer(),
                        IconButton(
                          icon: Icon(Icons.refresh),
                          onPressed: _refreshTasks,
                          tooltip: 'Refresh',
                        ),
                      ],
                    ),
                  ),
                  Divider(height: 1),
                  Expanded(
                    child: FutureBuilder<List<Task>>(
                      key: ValueKey(_refreshKey),
                      future: taskRepo.getTasksForUser(userId),
                      builder: (context, snapshot) {
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Center(child: CircularProgressIndicator());
                        }

                        if (snapshot.hasError) {
                          return Center(
                            child: Text('Error: ${snapshot.error}'),
                          );
                        }

                        final tasks = snapshot.data ?? [];

                        if (tasks.isEmpty) {
                          return Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.task_alt,
                                  size: 64,
                                  color: Colors.grey.shade300,
                                ),
                                SizedBox(height: 16),
                                Text(
                                  'No tasks yet',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          );
                        }

                        return ListView.builder(
                          itemCount: tasks.length,
                          itemBuilder: (context, index) {
                            final task = tasks[index];
                            return ListTile(
                              leading: Icon(
                                task.status == 'completed'
                                    ? Icons.check_circle
                                    : Icons.radio_button_unchecked,
                                color: task.status == 'completed'
                                    ? Colors.green
                                    : Colors.grey,
                              ),
                              title: Text(
                                task.title,
                                style: TextStyle(
                                  decoration: task.status == 'completed'
                                      ? TextDecoration.lineThrough
                                      : null,
                                ),
                              ),
                              subtitle: task.description != null
                                  ? Text(
                                      task.description!,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                    )
                                  : (task.startDate != null
                                      ? Text(
                                          '📅 ${task.startDate!.toString().split(' ')[0]}',
                                        )
                                      : null),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (task.startDate != null &&
                                      task.description != null)
                                    Text(
                                      task.startDate!.toString().split(' ')[0],
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  IconButton(
                                    icon: Icon(Icons.delete, color: Colors.red),
                                    onPressed: () async {
                                      final confirmed = await showDialog<bool>(
                                        context: context,
                                        builder: (context) => AlertDialog(
                                          title: Text('Delete Task'),
                                          content: Text(
                                              'Are you sure you want to delete "${task.title}"?'),
                                          actions: [
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, false),
                                              child: Text('Cancel'),
                                            ),
                                            TextButton(
                                              onPressed: () =>
                                                  Navigator.pop(context, true),
                                              child: Text('Delete',
                                                  style: TextStyle(
                                                      color: Colors.red)),
                                            ),
                                          ],
                                        ),
                                      );

                                      if (confirmed == true) {
                                        try {
                                          await taskRepo.deleteTask(
                                              task.id, userId);
                                          _refreshTasks();
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content:
                                                    Text('Task deleted'),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }
                                        } catch (e) {
                                          if (mounted) {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                    'Error deleting task: $e'),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                      }
                                    },
                                  ),
                                ],
                              ),
                            );
                          },
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Create Task Form Section
          Expanded(
            flex: 2,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Card(
                    margin: EdgeInsets.only(bottom: 12),
                    child: Padding(
                      padding: EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Icon(Icons.add_task, color: Colors.green),
                              SizedBox(width: 8),
                              Text(
                                strings.create,
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Row(
                            children: [
                              Icon(Icons.info, color: Colors.blue, size: 20),
                              SizedBox(width: 8),
                              Text(
                                '${strings.preset}: ${_capitalize(selectedPreset)}',
                                style:
                                    TextStyle(fontSize: 12, color: Colors.grey),
                              ),
                            ],
                          ),
                          SizedBox(height: 8),
                          Wrap(
                            spacing: 8,
                            children: taskToggles
                                .where((t) => t.enabled)
                                .map((toggle) => Chip(
                                      label: Text(toggle.name),
                                      backgroundColor: Colors.blue.shade100,
                                    ))
                                .toList(),
                          ),
                        ],
                      ),
                    ),
                  ),
                  TextField(
                    controller: _titleController,
                    decoration: InputDecoration(
                      labelText: strings.taskTitle,
                      border: OutlineInputBorder(),
                    ),
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _descController,
                    decoration: InputDecoration(
                      labelText: strings.description,
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 3,
                  ),
                  SizedBox(height: 12),
                  if (taskToggles
                      .any((t) => t.name == 'scheduling' && t.enabled))
                    Row(
                      children: [
                        Icon(Icons.calendar_today, size: 20),
                        SizedBox(width: 8),
                        Text(
                          _selectedDate != null
                              ? '${_selectedDate!.toString().split(' ')[0]}'
                              : strings.selectDueDate,
                        ),
                        Spacer(),
                        ElevatedButton(
                          onPressed: () async {
                            final date = await showDatePicker(
                              context: context,
                              initialDate: DateTime.now(),
                              firstDate: DateTime.now(),
                              lastDate: DateTime.now().add(Duration(days: 365)),
                            );
                            if (date != null) {
                              setState(() {
                                _selectedDate = date;
                              });
                            }
                          },
                          child: Text(strings.pick),
                        ),
                      ],
                    ),
                  SizedBox(height: 24),
                  if (_saving)
                    CircularProgressIndicator()
                  else
                    ElevatedButton.icon(
                      onPressed: () async {
                        // Validate required fields
                        if (_titleController.text.trim().isEmpty) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text(strings.enterTaskTitle)),
                          );
                          return;
                        }

                        // Get userId and validate
                        final userId = ref.read(currentUserIdProvider);
                        if (userId.isEmpty || userId == 'user_default') {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error: No user logged in')),
                          );
                          return;
                        }

                        setState(() {
                          _saving = true;
                        });

                        try {
                          final now = DateTime.now();
                          final taskId = 'task_${now.millisecondsSinceEpoch}';

                          // Create task with proper null handling
                          final task = Task(
                            id: taskId,
                            createdAt: now,
                            updatedAt: now,
                            ownerId: userId,
                            moduleSource: 'tasks',
                            title: _titleController.text.trim(),
                            description: _descController.text.trim().isEmpty
                                ? null
                                : _descController.text.trim(),
                            startDate: _selectedDate,
                            status: 'pending',
                          );

                          print('DEBUG: Attempting to save task: $taskId');
                          print('DEBUG: Task ownerId: ${task.ownerId}');
                          print('DEBUG: Task title: ${task.title}');

                          // Save via repository
                          await taskRepo.saveTask(task);

                          print('DEBUG: Task saved successfully');

                          // Emit event
                          await eventBus.emit(
                            TaskCreatedEvent(
                              taskId: taskId,
                              title: _titleController.text,
                              userId: userId,
                            ),
                          );

                          print('DEBUG: Event emitted');

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text(strings.taskCreated),
                                backgroundColor: Colors.green,
                              ),
                            );

                            // Clear the form for next entry
                            _titleController.clear();
                            _descController.clear();
                            setState(() {
                              _selectedDate = null;
                            });

                            // Refresh the task list
                            _refreshTasks();
                          }
                        } catch (e, stackTrace) {
                          print('ERROR creating task: $e');
                          print('STACK TRACE: $stackTrace');

                          if (mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('${strings.error}: $e'),
                                duration: Duration(seconds: 5),
                                backgroundColor: Colors.red,
                              ),
                            );
                          }
                        } finally {
                          if (mounted) {
                            setState(() {
                              _saving = false;
                            });
                          }
                        }
                      },
                      icon: Icon(Icons.check),
                      label: Text(strings.create),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);

  @override
  void dispose() {
    _titleController.dispose();
    _descController.dispose();
    super.dispose();
  }
}
