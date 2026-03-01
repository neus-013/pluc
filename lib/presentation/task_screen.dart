import 'package:flutter/material.dart';
// import 'package:flutter_gen/gen_l10n/app_localizations.dart';
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

  @override
  Widget build(BuildContext context) {
    // final strings = AppLocalizations.of(context)!;
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
          Card(
            margin: EdgeInsets.only(bottom: 16),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(Icons.info, color: Colors.blue, size: 20),
                      SizedBox(width: 8),
                      Text(
                        'Preset: ${_capitalize(selectedPreset)}',
                        style: TextStyle(fontSize: 12, color: Colors.grey),
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
              labelText: 'Task Title',
              border: OutlineInputBorder(),
            ),
          ),
          SizedBox(height: 12),
          TextField(
            controller: _descController,
            decoration: InputDecoration(
              labelText: 'Description',
              border: OutlineInputBorder(),
            ),
            maxLines: 3,
          ),
          SizedBox(height: 12),
          if (taskToggles.any((t) => t.name == 'scheduling' && t.enabled))
            Row(
              children: [
                Icon(Icons.calendar_today, size: 20),
                SizedBox(width: 8),
                Text(
                  _selectedDate != null
                      ? '${_selectedDate!.toString().split(' ')[0]}'
                      : 'Select due date',
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
                  child: Text('Pick'),
                ),
              ],
            ),
          SizedBox(height: 24),
          if (_saving)
            CircularProgressIndicator()
          else
            ElevatedButton.icon(
              onPressed: () async {
                if (_titleController.text.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Please enter a task title')),
                  );
                  return;
                }

                setState(() {
                  _saving = true;
                });

                try {
                  final now = DateTime.now();
                  final taskId = 'task_${now.millisecondsSinceEpoch}';

                  // Create task
                  final task = Task(
                    id: taskId,
                    createdAt: now,
                    updatedAt: now,
                    userId: userId,
                    moduleSource: 'tasks',
                    title: _titleController.text,
                    description: _descController.text,
                    startDate: _selectedDate,
                    status: 'pending',
                  );

                  // Save via repository
                  await taskRepo.saveTask(task);

                  // Emit event
                  await eventBus.emit(
                    TaskCreatedEvent(
                      taskId: taskId,
                      title: _titleController.text,
                      userId: userId,
                    ),
                  );

                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Task created!')),
                    );
                    Navigator.pop(context);
                  }
                } catch (e) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Error: $e')),
                    );
                  }
                } finally {
                  setState(() {
                    _saving = false;
                  });
                }
              },
              icon: Icon(Icons.check),
              label: const Text('Create'),
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
