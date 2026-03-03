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
    final theme = ref.watch(currentThemeProvider);

    final moduleLabels = {
      'calendar': strings.calendar,
      'tasks': strings.tasks,
      'journal': strings.journal,
      'habits': strings.habits,
      'health': strings.health,
      'finance': strings.finance,
      'nutrition': strings.nutrition,
      'menstruation': strings.menstruation,
      'settings': strings.settings,
    };

    return Scaffold(
      key: const Key('home_scaffold'),
      appBar: theme.buildAppBar(
        title: _getTitle(_currentView, strings),
      ),
      drawer: theme.buildDrawer(
        appTitle: 'Pluc',
        subtitle: strings.appTitle,
        username: '', // Not used in drawer
        enabledModules: enabledModules,
        currentView: _currentView,
        moduleLabels: moduleLabels,
        onNavigate: (view) {
          setState(() {
            _currentView = view;
          });
          Navigator.pop(context);
        },
      ),
      body: theme.buildHomeLayout(
        child: _buildCurrentView(),
      ),
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
    final theme = ref.watch(currentThemeProvider);
    return theme.buildModulePlaceholder(
      moduleName: moduleName,
      comingSoonLabel: strings.comingSoon,
      context: context,
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
