import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final enabledModules = ref.watch(enabledModulesProvider);
    final selectedPresets = ref.watch(modulePresetsProvider);
    final modules = ref.watch(moduleDefinitionsProvider);

    final moduleList = [
      'tasks',
      'journal',
      'calendar',
      'habits',
      'health',
      'finance',
      'nutrition',
      'menstruation',
    ];

    final currentLocale = Localizations.localeOf(context);
    final languages = {
      'en': 'English',
      'es': 'Español',
      'ca': 'Català',
    };

    return Scaffold(
      appBar: AppBar(title: Text(strings.settings)),
      body: ListView(
        children: [
          // Profile Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              'Profile',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          Card(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Username:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'User',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Language:',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                        ),
                  ),
                  const SizedBox(height: 8),
                  SegmentedButton<String>(
                    segments: languages.entries
                        .map(
                          (e) => ButtonSegment(
                            value: e.key,
                            label: Text(e.value),
                          ),
                        )
                        .toList(),
                    selected: {currentLocale.languageCode},
                    onSelectionChanged: (Set<String> selection) {
                      final locale = selection.first;
                      // TODO: Implement language switching with provider
                    },
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 24),

          // Modules Section
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              strings.modules,
              style: Theme.of(context).textTheme.headlineSmall,
            ),
          ),
          ...moduleList.map((moduleId) {
            final module = modules[moduleId];
            final isEnabled = enabledModules[moduleId] ?? false;
            final selectedPreset = selectedPresets[moduleId] ?? 'flexible';

            return Card(
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpansionTile(
                leading: Switch(
                  value: isEnabled,
                  onChanged: (val) {
                    ref.read(enabledModulesProvider.notifier).state = {
                      ...enabledModules,
                      moduleId: val,
                    };
                  },
                ),
                title: Text(module?.name ?? moduleId),
                children: [
                  if (isEnabled) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Preset Mode:',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: const [
                              ButtonSegment(
                                value: 'structured',
                                label: Text('Structured'),
                              ),
                              ButtonSegment(
                                value: 'flexible',
                                label: Text('Flexible'),
                              ),
                              ButtonSegment(
                                value: 'minimal',
                                label: Text('Minimal'),
                              ),
                            ],
                            selected: {selectedPreset},
                            onSelectionChanged: (Set<String> selection) {
                              final preset = selection.first;
                              ref.read(modulePresetsProvider.notifier).state = {
                                ...selectedPresets,
                                moduleId: preset,
                              };
                              // Apply preset
                              ref.read(applyPresetProvider((moduleId, preset)));
                            },
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
