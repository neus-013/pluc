import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'providers/app_providers.dart';

class ModulesScreen extends ConsumerWidget {
  const ModulesScreen({Key? key}) : super(key: key);

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

    return Scaffold(
      appBar: AppBar(title: Text(strings.modules)),
      body: ListView.builder(
        itemCount: moduleList.length,
        itemBuilder: (context, index) {
          final moduleId = moduleList[index];
          final module = modules[moduleId];
          final isEnabled = enabledModules[moduleId] ?? false;
          final selectedPreset = selectedPresets[moduleId] ?? 'flexible';

          return Card(
            margin: EdgeInsets.all(8),
            child: Padding(
              padding: EdgeInsets.all(12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          module?.name ?? moduleId,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                      ),
                      Switch(
                        value: isEnabled,
                        onChanged: (value) {
                          ref.read(enabledModulesProvider.notifier).state = {
                            ...enabledModules,
                            moduleId: value,
                          };
                        },
                      ),
                    ],
                  ),
                  if (isEnabled) ...[
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Preset:',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        DropdownButton<String>(
                          value: selectedPreset,
                          items: ['structured', 'flexible', 'minimal']
                              .map((preset) => DropdownMenuItem(
                                    value: preset,
                                    child: Text(_capitalize(preset)),
                                  ))
                              .toList(),
                          onChanged: (newPreset) async {
                            if (newPreset != null) {
                              ref
                                  .read(modulePresetsProvider.notifier)
                                  .state = {
                                ...selectedPresets,
                                moduleId: newPreset,
                              };
                              
                              // Apply preset
                              await ref
                                  .read(applyPresetProvider(
                                      (moduleId, newPreset)).future);
                            }
                          },
                        ),
                      ],
                    ),
                  ],
                  SizedBox(height: 4),
                  if (module?.devOnly == true)
                    Chip(
                      label: Text('Dev Only'),
                      backgroundColor: Colors.orange.shade200,
                    ),
                ],
              ),
            ),
          );
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.grid_3x3),
            label: 'Modules',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: 'Calendar',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        onTap: (index) {
          switch (index) {
            case 0:
              break;
            case 1:
              Navigator.pushNamed(context, '/calendar');
              break;
            case 2:
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Settings coming soon')),
              );
              break;
          }
        },
      ),
    );
  }

  String _capitalize(String s) => s[0].toUpperCase() + s.substring(1);
}

