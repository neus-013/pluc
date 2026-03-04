import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/domain/enums/preset_type.dart';
import 'package:pluc/core/presets/calendar_preset_config.dart';
import 'package:pluc/core/presets/tasks_preset_config.dart';
import 'package:pluc/core/presets/journal_preset_config.dart';
import 'app_providers.dart';

// ============================================================================
// PRESET CONFIG PROVIDERS
// ============================================================================
// These providers derive the concrete preset config for each module from
// the modulePresetsProvider (which stores string keys like 'flexible').
// They are reactive — changing the preset in settings immediately rebuilds
// all widgets that depend on the config.
// ============================================================================

/// Current [CalendarPresetConfig] derived from user's preset selection.
final calendarPresetConfigProvider = Provider<CalendarPresetConfig>((ref) {
  final presets = ref.watch(modulePresetsProvider);
  final type = presetTypeFromString(presets['calendar'] ?? 'flexible');
  return CalendarPresetConfig.fromType(type);
});

/// Current [TasksPresetConfig] derived from user's preset selection.
final tasksPresetConfigProvider = Provider<TasksPresetConfig>((ref) {
  final presets = ref.watch(modulePresetsProvider);
  final type = presetTypeFromString(presets['tasks'] ?? 'flexible');
  return TasksPresetConfig.fromType(type);
});

/// Current [JournalPresetConfig] derived from user's preset selection.
final journalPresetConfigProvider = Provider<JournalPresetConfig>((ref) {
  final presets = ref.watch(modulePresetsProvider);
  final type = presetTypeFromString(presets['journal'] ?? 'flexible');
  return JournalPresetConfig.fromType(type);
});
