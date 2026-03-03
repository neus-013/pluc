import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/core/entities.dart';
import 'package:pluc/core/domain/entities/user.dart';
import 'package:pluc/core/services/preset_service.dart';
import 'package:pluc/core/providers.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';

// ============================================================================
// THEME CONFIGURATION
// ============================================================================

/// Controls the entire UI structure and visual presentation.
///
/// This provider allows switching between different theme implementations
/// that control not just colors/fonts, but the actual widget structure,
/// layout patterns, and visual hierarchy throughout the app.
///
/// Example: Change from DefaultThemeConfig to a hypothetical CompactTheme
/// to instantly restructure all screens with denser layouts and different
/// card styles without modifying individual screen code.
final currentThemeProvider = StateProvider<AppThemeConfig>((ref) {
  return ModernMinimalTheme(); // Default theme
});

// ============================================================================
// USER STATE
// ============================================================================

/// Tracks the currently authenticated user
/// Null when no user is logged in
final currentUserProvider = StateProvider<User?>((ref) => null);

/// Tracks the current user's password length (for UI display only)
final passwordLengthProvider = StateProvider<int>((ref) => 0);

/// Tracks the current app locale
final localeProvider = StateProvider<Locale>((ref) => const Locale('en'));

// ============================================================================
// MODULE STATE
// ============================================================================

/// Tracks enabled/disabled modules
final enabledModulesProvider = StateProvider<Map<String, bool>>((ref) {
  return {
    'tasks': true,
    'journal': true,
    'calendar': true,
    'habits': false,
    'health': false,
    'finance': false,
    'nutrition': false,
    'menstruation': false,
  };
});

/// Tracks selected preset for each module
final modulePresetsProvider = StateProvider<Map<String, String>>((ref) {
  return {
    'tasks': 'flexible',
    'journal': 'flexible',
    'calendar': 'flexible',
  };
});

/// Feature toggles per module
final featureTogglesProvider =
    StateProvider<Map<String, List<FeatureToggle>>>((ref) {
  return {
    'tasks': [
      FeatureToggle(
          id: '1', moduleId: 'tasks', name: 'reminders', enabled: true),
      FeatureToggle(
          id: '2', moduleId: 'tasks', name: 'recurring', enabled: true),
      FeatureToggle(
          id: '3', moduleId: 'tasks', name: 'scheduling', enabled: true),
      FeatureToggle(
          id: '4', moduleId: 'tasks', name: 'notifications', enabled: true),
    ],
    'journal': [
      FeatureToggle(
          id: '5', moduleId: 'journal', name: 'attachments', enabled: true),
      FeatureToggle(id: '6', moduleId: 'journal', name: 'tags', enabled: true),
    ],
  };
});

/// Apply preset to a module's features
final applyPresetProvider = FutureProvider.family<List<FeatureToggle>,
    (String moduleId, String presetName)>((ref, params) async {
  final presetService = ref.read(presetServiceProvider);
  final toggles = ref.read(featureTogglesProvider);
  final currentToggles = toggles[params.$1] ?? [];

  final preset = PresetService.getPreset(params.$2, params.$1);
  if (preset == null) return currentToggles;

  final updated = await presetService.applyPreset(preset, currentToggles);

  // Update the state
  ref.read(featureTogglesProvider.notifier).state = {
    ...toggles,
    params.$1: updated,
  };

  return updated;
});

/// Module definitions
final moduleDefinitionsProvider =
    Provider<Map<String, ModuleDefinition>>((ref) {
  return {
    'tasks': ModuleDefinition(
      id: 'tasks',
      name: 'Tasks',
      enabled: true,
      configurableFeatures: {'reminders': true, 'recurring': true},
    ),
    'journal': ModuleDefinition(
      id: 'journal',
      name: 'Journal',
      enabled: true,
      configurableFeatures: {'attachments': true, 'tags': true},
    ),
    'calendar': ModuleDefinition(
      id: 'calendar',
      name: 'Calendar',
      enabled: true,
      configurableFeatures: {},
    ),
    'habits': ModuleDefinition(
      id: 'habits',
      name: 'Habits',
      enabled: false,
      devOnly: false,
    ),
  };
});

// ============================================================================
// CALENDAR STATE
// ============================================================================

final selectedDateRangeProvider = StateProvider<(DateTime, DateTime)>((ref) {
  final now = DateTime.now();
  return (
    DateTime(now.year, now.month, 1),
    DateTime(now.year, now.month + 1, 1).subtract(Duration(days: 1)),
  );
});

/// Fetch schedulable items for selected date range
final calendarItemsProvider = FutureProvider<List<dynamic>>((ref) async {
  final calendarRepo = ref.read(calendarRepositoryProvider);
  final (start, end) = ref.watch(selectedDateRangeProvider);
  final enabledModules = ref.watch(enabledModulesProvider);
  final userId = ref.watch(currentUserIdProvider);

  try {
    final items = await calendarRepo.getSchedulableItems(userId, start, end);

    // Filter by enabled modules
    return items
        .where((item) => enabledModules[item.moduleSource] ?? false)
        .toList();
  } catch (e) {
    print('Error fetching calendar items: $e');
    return [];
  }
});

// ============================================================================
// CREATE ENTRY STATE
// ============================================================================

/// Provides the current user ID for entity creation
/// Returns the authenticated user's ID or a default value if not logged in
final currentUserIdProvider = Provider<String>((ref) {
  final user = ref.watch(currentUserProvider);
  return user?.id ?? 'user_default';
});

final dummyTasksProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});

final dummyJournalEntriesProvider = StateProvider<List<dynamic>>((ref) {
  return [];
});
