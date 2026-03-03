import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/theme/app_theme_config.dart';
import 'providers/app_providers.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({Key? key}) : super(key: key);

  String _themeKey(AppThemeConfig theme) {
    if (theme is CozyIllustratedTheme) {
      return 'cozy';
    }
    return 'modern';
  }

  String _getModuleName(String moduleId, AppLocalizations strings) {
    switch (moduleId) {
      case 'tasks':
        return strings.tasks;
      case 'journal':
        return strings.journal;
      case 'calendar':
        return strings.calendar;
      case 'habits':
        return strings.habits;
      case 'health':
        return strings.health;
      case 'finance':
        return strings.finance;
      case 'nutrition':
        return strings.nutrition;
      case 'menstruation':
        return strings.menstruation;
      default:
        return moduleId[0].toUpperCase() + moduleId.substring(1);
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final strings = AppLocalizations.of(context)!;
    final enabledModules = ref.watch(enabledModulesProvider);
    final selectedPresets = ref.watch(modulePresetsProvider);
    final currentUser = ref.watch(currentUserProvider);
    final passwordLength = ref.watch(passwordLengthProvider);
    final currentLocale = ref.watch(localeProvider);
    final currentTheme = ref.watch(currentThemeProvider);
    final theme = currentTheme; // Convenience alias

    // Extract username from User entity
    final username = currentUser?.username ?? 'User';

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

    final languages = {
      'en': 'English',
      'es': 'Español',
      'ca': 'Català',
    };

    return Scaffold(
      appBar: theme.buildAppBar(title: strings.settings),
      body: ListView(
        children: [
          theme.buildSettingSection(title: strings.profile, context: context),
          theme.buildSettingCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${strings.username}:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  username,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  '${strings.password}:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  '•' * passwordLength,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 20),
                Text(
                  '${strings.language}:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                theme.buildLanguageSelector(
                  languages: languages,
                  currentLanguage: currentLocale.languageCode,
                  onLanguageChanged: (lang) {
                    final newLocale = Locale(lang);
                    ref.read(localeProvider.notifier).state = newLocale;
                  },
                ),
                const SizedBox(height: 20),
                Text(
                  'Theme:',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey[600],
                      ),
                ),
                const SizedBox(height: 8),
                theme.buildThemeSelector(
                  currentThemeKey: _themeKey(currentTheme),
                  onThemeChanged: (value) {
                    if (value == 'cozy') {
                      ref.read(currentThemeProvider.notifier).state =
                          CozyIllustratedTheme();
                      return;
                    }
                    ref.read(currentThemeProvider.notifier).state =
                        ModernMinimalTheme();
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: ElevatedButton.icon(
              key: const Key('logout_button'),
              onPressed: () async {
                final shouldLogout = await showDialog<bool>(
                  context: context,
                  builder: (ctx) => theme.buildConfirmDialog(
                    context: ctx,
                    title: strings.logout,
                    content: strings.logoutConfirm,
                    confirmLabel: strings.logout,
                    cancelLabel: strings.cancel,
                    onConfirm: () {},
                  ),
                );

                if (shouldLogout == true && context.mounted) {
                  // Clear user session (set to null)
                  ref.read(currentUserProvider.notifier).state = null;
                  ref.read(passwordLengthProvider.notifier).state = 0;
                  // Navigate back to login
                  Navigator.pushNamedAndRemoveUntil(
                    context,
                    '/',
                    (route) => false,
                  );
                }
              },
              icon: const Icon(Icons.logout),
              label: Text(strings.logout),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade400,
                foregroundColor: Colors.white,
              ),
            ),
          ),
          const SizedBox(height: 24),
          theme.buildSettingSection(title: strings.modules, context: context),
          ...moduleList.map((moduleId) {
            final isEnabled = enabledModules[moduleId] ?? false;
            final selectedPreset = selectedPresets[moduleId] ?? 'flexible';

            return Card(
              key: Key('module_card_$moduleId'),
              margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              child: ExpansionTile(
                key: Key('expansion_tile_$moduleId'),
                leading: Switch(
                  key: Key('switch_$moduleId'),
                  value: isEnabled,
                  onChanged: (val) {
                    ref.read(enabledModulesProvider.notifier).state = {
                      ...enabledModules,
                      moduleId: val,
                    };
                  },
                ),
                title: Text(_getModuleName(moduleId, strings)),
                children: [
                  if (isEnabled) ...[
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${strings.presetMode}:',
                            style: Theme.of(context).textTheme.titleSmall,
                          ),
                          const SizedBox(height: 8),
                          SegmentedButton<String>(
                            segments: [
                              ButtonSegment(
                                value: 'structured',
                                label: Text(strings.structuredMode),
                              ),
                              ButtonSegment(
                                value: 'flexible',
                                label: Text(strings.flexibleMode),
                              ),
                              ButtonSegment(
                                value: 'minimal',
                                label: Text(strings.minimalMode),
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
