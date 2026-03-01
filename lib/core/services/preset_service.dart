import '../entities.dart';
import '../events/app_events.dart';
import '../events/event_bus.dart';

/// Service responsible for managing preset application.
/// Handles enabling/disabling features according to preset definitions.
class PresetService {
  final EventBus eventBus;

  PresetService({required this.eventBus});

  /// Apply a preset to a set of feature toggles.
  /// Returns the updated list of feature toggles.
  Future<List<FeatureToggle>> applyPreset(
    PresetDefinition preset,
    List<FeatureToggle> currentToggles,
  ) async {
    final updated = <FeatureToggle>[];

    for (final toggle in currentToggles) {
      final isEnabled = preset.enabledFeatures.contains(toggle.name);
      final isDisabled = preset.disabledFeatures.contains(toggle.name);

      // If feature is explicitly enabled, enable it
      if (isEnabled) {
        updated.add(toggle.copyWith(enabled: true));
      }
      // If feature is explicitly disabled, disable it
      else if (isDisabled) {
        updated.add(toggle.copyWith(enabled: false));
      }
      // Otherwise, keep current state
      else {
        updated.add(toggle);
      }
    }

    // Emit event about preset application
    await eventBus.emit(
      PresetAppliedEvent(
        moduleId: preset.moduleId,
        presetId: preset.id,
        enabledFeatures: preset.enabledFeatures,
        disabledFeatures: preset.disabledFeatures,
      ),
    );

    return updated;
  }

  /// Create preset definitions for common modes.
  /// Can be extended to load from database.
  static Map<String, PresetDefinition> createDefaultPresets(String moduleId) {
    return {
      'structured': PresetDefinition(
        id: 'structured',
        moduleId: moduleId,
        enabledFeatures: [
          'reminders',
          'recurring',
          'scheduling',
          'notifications',
          'collaboration',
        ],
        disabledFeatures: [],
      ),
      'flexible': PresetDefinition(
        id: 'flexible',
        moduleId: moduleId,
        enabledFeatures: [
          'reminders',
          'recurring',
          'scheduling',
        ],
        disabledFeatures: [
          'collaboration',
        ],
      ),
      'minimal': PresetDefinition(
        id: 'minimal',
        moduleId: moduleId,
        enabledFeatures: [],
        disabledFeatures: [
          'reminders',
          'recurring',
          'scheduling',
          'notifications',
          'collaboration',
        ],
      ),
    };
  }

  /// Get an individual preset by name.
  static PresetDefinition? getPreset(
    String presetName,
    String moduleId,
  ) {
    return createDefaultPresets(moduleId)[presetName];
  }

  /// Validate that a preset exists and is valid.
  static bool isValidPreset(String presetName) {
    return ['structured', 'flexible', 'minimal'].contains(presetName);
  }
}
