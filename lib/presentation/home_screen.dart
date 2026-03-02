import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pluc/l10n/app_localizations.dart';
import 'package:pluc/presentation/calendar_screen.dart';
import 'package:pluc/presentation/task_screen.dart';
import 'package:pluc/presentation/journal_entry_screen.dart';
import 'package:pluc/presentation/settings_screen.dart';
import 'providers/app_providers.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  String _currentView = 'calendar';

  @override
  Widget build(BuildContext context) {
    final strings = AppLocalizations.of(context)!;
    final enabledModules = ref.watch(enabledModulesProvider);

    return Scaffold(
      key: const Key('home_scaffold'),
      appBar: AppBar(
        title: Text(_getTitle(_currentView, strings)),
      ),
      drawer: Drawer(
        key: const Key('home_drawer'),
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              key: const Key('drawer_header'),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    'Pluc',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    strings.appTitle,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onPrimaryContainer,
                        ),
                  ),
                ],
              ),
            ),
            // Calendar is always visible (aggregates all modules)
            ListTile(
              key: const Key('drawer_calendar'),
              leading: const Icon(Icons.calendar_today),
              title: Text(strings.calendar),
              selected: _currentView == 'calendar',
              onTap: () {
                setState(() {
                  _currentView = 'calendar';
                });
                Navigator.pop(context);
              },
            ),
            const Divider(),
            // Show only enabled modules
            if (enabledModules['tasks'] == true)
              ListTile(
                key: const Key('drawer_tasks'),
                leading: const Icon(Icons.check_box),
                title: Text(strings.tasks),
                selected: _currentView == 'tasks',
                onTap: () {
                  setState(() {
                    _currentView = 'tasks';
                  });
                  Navigator.pop(context);
                },
              ),
            if (enabledModules['journal'] == true)
              ListTile(
                key: const Key('drawer_journal'),
                leading: const Icon(Icons.book),
                title: Text(strings.journal),
                selected: _currentView == 'journal',
                onTap: () {
                  setState(() {
                    _currentView = 'journal';
                  });
                  Navigator.pop(context);
                },
              ),
            if (enabledModules['habits'] == true)
              ListTile(
                key: const Key('drawer_habits'),
                leading: const Icon(Icons.repeat),
                title: Text(strings.habits),
                selected: _currentView == 'habits',
                onTap: () {
                  setState(() {
                    _currentView = 'habits';
                  });
                  Navigator.pop(context);
                },
              ),
            if (enabledModules['health'] == true)
              ListTile(
                key: const Key('drawer_health'),
                leading: const Icon(Icons.fitness_center),
                title: Text(strings.health),
                selected: _currentView == 'health',
                onTap: () {
                  setState(() {
                    _currentView = 'health';
                  });
                  Navigator.pop(context);
                },
              ),
            if (enabledModules['finance'] == true)
              ListTile(
                key: const Key('drawer_finance'),
                leading: const Icon(Icons.attach_money),
                title: Text(strings.finance),
                selected: _currentView == 'finance',
                onTap: () {
                  setState(() {
                    _currentView = 'finance';
                  });
                  Navigator.pop(context);
                },
              ),
            if (enabledModules['nutrition'] == true)
              ListTile(
                key: const Key('drawer_nutrition'),
                leading: const Icon(Icons.restaurant),
                title: Text(strings.nutrition),
                selected: _currentView == 'nutrition',
                onTap: () {
                  setState(() {
                    _currentView = 'nutrition';
                  });
                  Navigator.pop(context);
                },
              ),
            if (enabledModules['menstruation'] == true)
              ListTile(
                key: const Key('drawer_menstruation'),
                leading: const Icon(Icons.favorite),
                title: Text(strings.menstruation),
                selected: _currentView == 'menstruation',
                onTap: () {
                  setState(() {
                    _currentView = 'menstruation';
                  });
                  Navigator.pop(context);
                },
              ),
            const Divider(),
            ListTile(
              key: const Key('drawer_settings'),
              leading: const Icon(Icons.settings),
              title: Text(strings.settings),
              selected: _currentView == 'settings',
              onTap: () {
                setState(() {
                  _currentView = 'settings';
                });
                Navigator.pop(context);
              },
            ),
          ],
        ),
      ),
      body: _buildCurrentView(),
    );
  }

  Widget _buildCurrentView() {
    switch (_currentView) {
      case 'calendar':
        return const CalendarScreen();
      case 'tasks':
        return const TaskScreen();
      case 'journal':
        return const JournalEntryScreen();
      case 'settings':
        return const SettingsScreen();
      case 'habits':
      case 'health':
      case 'finance':
      case 'nutrition':
      case 'menstruation':
        return _buildPlaceholder(_currentView);
      default:
        return const CalendarScreen();
    }
  }

  Widget _buildPlaceholder(String moduleName) {
    final strings = AppLocalizations.of(context)!;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: Theme.of(context).colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            '$moduleName module',
            style: Theme.of(context).textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(strings.comingSoon),
        ],
      ),
    );
  }

  String _getTitle(String view, AppLocalizations strings) {
    switch (view) {
      case 'calendar':
        return strings.calendar;
      case 'tasks':
        return strings.tasks;
      case 'journal':
        return strings.journal;
      case 'settings':
        return strings.settings;
      default:
        return view[0].toUpperCase() + view.substring(1);
    }
  }
}
