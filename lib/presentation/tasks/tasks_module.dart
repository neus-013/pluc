import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/domain/enums/preset_type.dart';
import 'package:pluc/presentation/providers/preset_providers.dart';
import 'views/structured_tasks_view.dart';
import 'views/flexible_tasks_view.dart';
import 'views/minimal_tasks_view.dart';

/// Tasks module root widget.
///
/// Reads the current tasks preset and delegates to the appropriate
/// preset-specific view. Business logic (repos, providers) is shared —
/// only the layout structure, feature exposure, and interaction complexity
/// differ between presets.
class TasksModule extends ConsumerWidget {
  const TasksModule({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final config = ref.watch(tasksPresetConfigProvider);

    return switch (config.type) {
      PresetType.structured => const StructuredTasksView(),
      PresetType.flexible => const FlexibleTasksView(),
      PresetType.minimal => const MinimalTasksView(),
    };
  }
}
