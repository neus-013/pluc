import 'package:flutter/material.dart';
import 'package:pluc/core/domain/entities/task.dart';
import 'package:pluc/features/journal/domain/entities/journal_entry.dart';
import 'package:pluc/core/entities.dart';
import 'package:pluc/features/calendar/domain/repositories/calendar_repository.dart';
import 'package:pluc/presentation/providers/app_providers.dart'
    show CalendarViewMode;

/// App-wide theme contract that controls ALL structure and styling.
///
/// Complete UI theming: every visual element is controlled by theme config.
/// Screens only handle business logic, state management, and data flow.
abstract class AppThemeConfig {
  // Base theme properties
  ColorScheme get colorScheme;
  TextTheme get textTheme;

  // Material Design component themes
  AppBarTheme get appBarTheme;
  DrawerThemeData get drawerTheme;
  InputDecorationTheme get inputDecorationTheme;
  SnackBarThemeData get snackBarTheme;
  SwitchThemeData get switchTheme;
  ButtonStyle get primaryButtonStyle;
  ButtonStyle get secondaryButtonStyle;
  ButtonStyle get deleteButtonStyle;

  // Layout builders
  Widget buildHomeLayout({required Widget child});

  // AppBar construction
  PreferredSizeWidget buildAppBar({required String title});

  // Drawer construction
  Widget buildDrawer({
    required String appTitle,
    required String subtitle,
    required String username,
    required Map<String, dynamic> enabledModules,
    required String currentView,
    required Map<String, String> moduleLabels,
    required Function(String) onNavigate,
  });

  Widget buildDrawerHeader({
    required String appTitle,
    required String subtitle,
  });

  Widget buildDrawerItem({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    Key? key,
  });

  // Card builders
  Widget buildTaskCard(
    Task task, {
    required VoidCallback onToggleComplete,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  });

  Widget buildJournalCard(
    JournalEntry entry, {
    required VoidCallback onTap,
    required VoidCallback onDelete,
  });

  // Dialog builders – themes control ALL dialog UI
  Future<Task?> showTaskDialog({
    required BuildContext context,
    Task? existingTask,
  });

  Future<JournalEntry?> showJournalDialog({
    required BuildContext context,
    JournalEntry? existingEntry,
  });

  // FAB for creating new items
  Widget buildCreateFab({
    required VoidCallback onPressed,
  });

  Widget buildCalendarView(
    List<SchedulableEntity> items, {
    required CalendarViewMode viewMode,
    required DateTime focusDate,
    Function(SchedulableEntity)? onItemTap,
    Function(SchedulableEntity)? onToggleComplete,
  });

  // Calendar toolbar with view mode switcher and navigation
  Widget buildCalendarToolbar({
    required BuildContext context,
    required CalendarViewMode currentMode,
    required DateTime focusDate,
    required ValueChanged<CalendarViewMode> onModeChanged,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
    required VoidCallback onToday,
  });

  // Calendar date-range computation for the given mode + focus
  (DateTime, DateTime) dateRangeForMode(CalendarViewMode mode, DateTime focus);

  // Section headers
  Widget buildSectionHeader({
    required IconData icon,
    required String title,
    required Color iconColor,
    VoidCallback? onRefresh,
  });

  // Form inputs
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  });

  Widget buildDatePickerButton({
    required BuildContext context,
    required String label,
    DateTime? selectedDate,
    required ValueChanged<DateTime?> onDateSelected,
  });

  Widget buildSaveButton({
    required String label,
    required VoidCallback onPressed,
    required bool isLoading,
  });

  // Dialogs
  Widget buildConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmLabel,
    required String cancelLabel,
    required VoidCallback onConfirm,
  });

  // Snackbars
  void showSuccessSnackbar(BuildContext context, String message);
  void showErrorSnackbar(BuildContext context, String message);

  // State indicators
  Widget buildEmptyState({
    required IconData icon,
    required String label,
    required Color color,
  });

  Widget buildLoadingIndicator();

  Widget buildErrorState({required String error});

  // Settings UI
  Widget buildSettingCard({required Widget child});

  Widget buildSettingSection(
      {required String title, required BuildContext context});

  Widget buildLanguageSelector({
    required Map<String, String> languages,
    required String currentLanguage,
    required Function(String) onLanguageChanged,
  });

  Widget buildThemeSelector({
    required String currentThemeKey,
    required Function(String) onThemeChanged,
  });

  // Feature/preset indicators
  Widget buildFeatureChip({required String label});

  Widget buildPresetBadge({required String preset});

  // Module list containers
  Widget buildModuleListContainer({
    required Widget header,
    required Widget content,
  });

  Widget buildFormContainer({
    required List<Widget> children,
  });

  // Placeholder screens
  Widget buildModulePlaceholder({
    required String moduleName,
    required String comingSoonLabel,
    required BuildContext context,
  });
}

abstract class _BaseThemeConfig implements AppThemeConfig {
  // Helper methods
  Map<DateTime, List<SchedulableEntity>> groupByDay(
      List<SchedulableEntity> items) {
    final grouped = <DateTime, List<SchedulableEntity>>{};

    for (final item in items) {
      final date = item.startDate;
      if (date == null) continue;
      final key = DateTime(date.year, date.month, date.day);
      grouped.putIfAbsent(key, () => <SchedulableEntity>[]).add(item);
    }

    final keys = grouped.keys.toList()..sort();
    return {
      for (final key in keys)
        key: (grouped[key]!
          ..sort((a, b) {
            final aDate = a.startDate ?? key;
            final bDate = b.startDate ?? key;
            return aDate.compareTo(bDate);
          }))
    };
  }

  String formatDate(DateTime date) =>
      '${date.day.toString().padLeft(2, '0')}/${date.month.toString().padLeft(2, '0')}/${date.year}';

  String formatTime(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  bool isTaskItem(SchedulableEntity item) {
    if (item is Task) return true;
    if (item is SchedulableItem) return item.moduleSource == 'tasks';
    return false;
  }

  bool isCompletedItem(SchedulableEntity item) {
    return item.status == 'completed';
  }

  IconData iconForItem(SchedulableEntity item) {
    if (item is Task) {
      return item.status == 'completed'
          ? Icons.check_circle
          : Icons.check_circle_outline;
    }
    if (item is JournalEntry) return Icons.menu_book_outlined;
    if (item is SchedulableItem) {
      if (item.moduleSource == 'tasks') {
        return item.status == 'completed'
            ? Icons.check_circle
            : Icons.check_circle_outline;
      }
      if (item.moduleSource == 'journal') return Icons.menu_book_outlined;
    }
    return Icons.event_note;
  }

  String titleForItem(SchedulableEntity item) {
    if (item is Task) return item.title;
    if (item is JournalEntry) return item.content;
    if (item is SchedulableItem) return item.title;
    return 'Event';
  }

  IconData iconForModule(String moduleId) {
    switch (moduleId) {
      case 'calendar':
        return Icons.calendar_today;
      case 'tasks':
        return Icons.check_box;
      case 'journal':
        return Icons.book;
      case 'habits':
        return Icons.repeat;
      case 'health':
        return Icons.fitness_center;
      case 'finance':
        return Icons.attach_money;
      case 'nutrition':
        return Icons.restaurant;
      case 'menstruation':
        return Icons.favorite;
      case 'settings':
        return Icons.settings;
      default:
        return Icons.dashboard;
    }
  }

  Widget buildCalendarItemRow(
    SchedulableEntity item, {
    required Color iconColor,
    required TextStyle titleStyle,
    required TextStyle timeStyle,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
  }) {
    // Use BaseEntity.id when available for stable accessibility node identity
    final itemKey = item is BaseEntity
        ? ValueKey((item as BaseEntity).id)
        : ValueKey(item.hashCode);
    return Container(
      key: itemKey,
      padding: padding,
      decoration: decoration,
      child: Row(
        children: [
          Icon(iconForItem(item), color: iconColor, size: 20),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              titleForItem(item),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: titleStyle,
            ),
          ),
          if (item.startDate != null)
            Text(
              formatTime(item.startDate!),
              style: timeStyle,
            ),
        ],
      ),
    );
  }

  // Default implementations of new methods
  @override
  PreferredSizeWidget buildAppBar({required String title}) {
    return AppBar(
      title: Text(title),
    );
  }

  @override
  Widget buildDrawer({
    required String appTitle,
    required String subtitle,
    required String username,
    required Map<String, dynamic> enabledModules,
    required String currentView,
    required Map<String, String> moduleLabels,
    required Function(String) onNavigate,
  }) {
    final moduleOrder = [
      'calendar',
      'tasks',
      'journal',
      'habits',
      'health',
      'finance',
      'nutrition',
      'menstruation',
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          buildDrawerHeader(appTitle: appTitle, subtitle: subtitle),
          buildDrawerItem(
            key: const Key('drawer_calendar'),
            label: moduleLabels['calendar'] ?? 'Calendar',
            icon: iconForModule('calendar'),
            selected: currentView == 'calendar',
            onTap: () => onNavigate('calendar'),
          ),
          const Divider(),
          ...moduleOrder.where((m) => m != 'calendar').map((moduleId) {
            if (enabledModules[moduleId] != true)
              return const SizedBox.shrink();
            return buildDrawerItem(
              key: Key('drawer_$moduleId'),
              label: moduleLabels[moduleId] ?? moduleId,
              icon: iconForModule(moduleId),
              selected: currentView == moduleId,
              onTap: () => onNavigate(moduleId),
            );
          }),
          const Divider(),
          buildDrawerItem(
            key: const Key('drawer_settings'),
            label: moduleLabels['settings'] ?? 'Settings',
            icon: iconForModule('settings'),
            selected: currentView == 'settings',
            onTap: () => onNavigate('settings'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDrawerHeader({
    required String appTitle,
    required String subtitle,
  }) {
    return DrawerHeader(
      decoration: BoxDecoration(
        color: colorScheme.primaryContainer,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Text(
            'Pluc',
            style: textTheme.headlineMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            subtitle,
            style: textTheme.bodyMedium?.copyWith(
              color: colorScheme.onPrimaryContainer,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDrawerItem({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    Key? key,
  }) {
    return ListTile(
      key: key,
      leading: Icon(icon),
      title: Text(label),
      selected: selected,
      onTap: onTap,
    );
  }

  @override
  Widget buildSectionHeader({
    required IconData icon,
    required String title,
    required Color iconColor,
    VoidCallback? onRefresh,
  }) {
    return Padding(
      padding: const EdgeInsets.all(12),
      child: Row(
        children: [
          Icon(icon, color: iconColor),
          const SizedBox(width: 8),
          Text(
            title,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const Spacer(),
          if (onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: onRefresh,
              tooltip: 'Refresh',
            ),
        ],
      ),
    );
  }

  @override
  Widget buildTextField({
    required TextEditingController controller,
    required String label,
    int maxLines = 1,
    TextInputType? keyboardType,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget buildDatePickerButton({
    required BuildContext context,
    required String label,
    DateTime? selectedDate,
    required ValueChanged<DateTime?> onDateSelected,
  }) {
    return OutlinedButton.icon(
      icon: const Icon(Icons.calendar_today),
      label: Text(selectedDate == null ? label : formatDate(selectedDate)),
      onPressed: () async {
        final picked = await showDatePicker(
          context: context,
          initialDate: selectedDate ?? DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2100),
        );
        if (picked != null) {
          onDateSelected(picked);
        }
      },
    );
  }

  @override
  Widget buildSaveButton({
    required String label,
    required VoidCallback onPressed,
    required bool isLoading,
  }) {
    return ElevatedButton(
      onPressed: isLoading ? null : onPressed,
      style: primaryButtonStyle,
      child: isLoading
          ? const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            )
          : Text(label),
    );
  }

  @override
  Widget buildConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    required String confirmLabel,
    required String cancelLabel,
    required VoidCallback onConfirm,
  }) {
    return AlertDialog(
      title: Text(title),
      content: Text(content),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context, false),
          child: Text(cancelLabel),
        ),
        TextButton(
          onPressed: () {
            Navigator.pop(context, true);
            onConfirm();
          },
          style: deleteButtonStyle,
          child: Text(confirmLabel),
        ),
      ],
    );
  }

  @override
  void showSuccessSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
      ),
    );
  }

  @override
  void showErrorSnackbar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  Widget buildEmptyState({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 64, color: color),
          const SizedBox(height: 16),
          Text(
            label,
            style: TextStyle(
              color: color,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildLoadingIndicator() {
    return const Center(
      child: CircularProgressIndicator(),
    );
  }

  @override
  Widget buildErrorState({required String error}) {
    return Center(
      child: Text(
        'Error: $error',
        style: TextStyle(color: colorScheme.error),
      ),
    );
  }

  @override
  Widget buildCalendarToolbar({
    required BuildContext context,
    required CalendarViewMode currentMode,
    required DateTime focusDate,
    required ValueChanged<CalendarViewMode> onModeChanged,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
    required VoidCallback onToday,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left),
            onPressed: onPrevious,
            tooltip: 'Previous',
          ),
          IconButton(
            icon: const Icon(Icons.today),
            onPressed: onToday,
            tooltip: 'Today',
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right),
            onPressed: onNext,
            tooltip: 'Next',
          ),
          const SizedBox(width: 4),
          Expanded(
            child: Text(
              _toolbarTitle(currentMode, focusDate),
              style: textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(width: 4),
          SegmentedButton<CalendarViewMode>(
            segments: const [
              ButtonSegment(
                value: CalendarViewMode.day,
                label: Text('Day'),
              ),
              ButtonSegment(
                value: CalendarViewMode.week,
                label: Text('Week'),
              ),
              ButtonSegment(
                value: CalendarViewMode.month,
                label: Text('Month'),
              ),
            ],
            selected: {currentMode},
            onSelectionChanged: (s) => onModeChanged(s.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: WidgetStatePropertyAll(
                textTheme.bodySmall,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _toolbarTitle(CalendarViewMode mode, DateTime d) {
    switch (mode) {
      case CalendarViewMode.day:
        return formatDate(d);
      case CalendarViewMode.week:
        final weekStart = d.subtract(Duration(days: d.weekday - 1));
        final weekEnd = weekStart.add(const Duration(days: 6));
        return '${formatDate(weekStart)} – ${formatDate(weekEnd)}';
      case CalendarViewMode.month:
        return _monthName(d.month, d.year);
    }
  }

  static const _months = [
    '',
    'January',
    'February',
    'March',
    'April',
    'May',
    'June',
    'July',
    'August',
    'September',
    'October',
    'November',
    'December',
  ];

  String _monthName(int month, int year) => '${_months[month]} $year';

  // Calendar date range helpers ─────────────────────────────────────────────
  (DateTime, DateTime) dateRangeForMode(CalendarViewMode mode, DateTime focus) {
    switch (mode) {
      case CalendarViewMode.day:
        return (
          DateTime(focus.year, focus.month, focus.day),
          DateTime(focus.year, focus.month, focus.day, 23, 59, 59),
        );
      case CalendarViewMode.week:
        final weekStart = focus.subtract(Duration(days: focus.weekday - 1));
        final weekEnd =
            weekStart.add(const Duration(days: 6, hours: 23, minutes: 59));
        return (weekStart, weekEnd);
      case CalendarViewMode.month:
        return (
          DateTime(focus.year, focus.month, 1),
          DateTime(focus.year, focus.month + 1, 0, 23, 59, 59),
        );
    }
  }

  // Weekday abbreviations for grid headers
  List<String> get weekdayLabels =>
      const ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget buildSettingCard({required Widget child}) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: child,
      ),
    );
  }

  @override
  Widget buildSettingSection(
      {required String title, required BuildContext context}) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Text(
        title,
        style: Theme.of(context).textTheme.headlineSmall,
      ),
    );
  }

  @override
  Widget buildLanguageSelector({
    required Map<String, String> languages,
    required String currentLanguage,
    required Function(String) onLanguageChanged,
  }) {
    return SegmentedButton<String>(
      segments: languages.entries
          .map(
            (e) => ButtonSegment(
              value: e.key,
              label: Text(e.value),
            ),
          )
          .toList(),
      selected: {currentLanguage},
      onSelectionChanged: (Set<String> selection) {
        onLanguageChanged(selection.first);
      },
    );
  }

  @override
  Widget buildThemeSelector({
    required String currentThemeKey,
    required Function(String) onThemeChanged,
  }) {
    return DropdownButtonFormField<String>(
      value: currentThemeKey,
      decoration: const InputDecoration(
        border: OutlineInputBorder(),
        isDense: true,
      ),
      items: const [
        DropdownMenuItem(
          value: 'modern',
          child: Text('Modern Minimal'),
        ),
        DropdownMenuItem(
          value: 'cozy',
          child: Text('Cozy Illustrated'),
        ),
      ],
      onChanged: (value) {
        if (value != null) {
          onThemeChanged(value);
        }
      },
    );
  }

  @override
  Widget buildFeatureChip({required String label}) {
    return Chip(
      label: Text(label),
      backgroundColor: Colors.blue.shade100,
    );
  }

  @override
  Widget buildPresetBadge({required String preset}) {
    return Row(
      children: [
        const Icon(Icons.info, color: Colors.blue, size: 20),
        const SizedBox(width: 8),
        Text(
          'Preset: ${preset[0].toUpperCase()}${preset.substring(1)}',
          style: const TextStyle(fontSize: 12, color: Colors.grey),
        ),
      ],
    );
  }

  @override
  Widget buildModuleListContainer({
    required Widget header,
    required Widget content,
  }) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          header,
          const Divider(height: 1),
          Expanded(child: content),
        ],
      ),
    );
  }

  @override
  Widget buildFormContainer({
    required List<Widget> children,
  }) {
    return Column(
      children: children,
    );
  }

  @override
  Widget buildModulePlaceholder({
    required String moduleName,
    required String comingSoonLabel,
    required BuildContext context,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.construction,
            size: 64,
            color: colorScheme.secondary,
          ),
          const SizedBox(height: 16),
          Text(
            '$moduleName module',
            style: textTheme.headlineSmall,
          ),
          const SizedBox(height: 8),
          Text(comingSoonLabel),
        ],
      ),
    );
  }
}

class ModernMinimalTheme extends _BaseThemeConfig {
  @override
  ColorScheme get colorScheme => ColorScheme.fromSeed(
        seedColor: const Color(0xFF6D7D94),
        brightness: Brightness.light,
      );

  @override
  TextTheme get textTheme => const TextTheme(
        headlineMedium: TextStyle(fontSize: 22, fontWeight: FontWeight.w700),
        titleMedium: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
        bodyMedium: TextStyle(fontSize: 13),
        bodySmall: TextStyle(fontSize: 11, color: Color(0xFF7A869A)),
      );

  @override
  AppBarTheme get appBarTheme => AppBarTheme(
        backgroundColor: colorScheme.primaryContainer,
        foregroundColor: colorScheme.onPrimaryContainer,
        elevation: 0,
      );

  @override
  DrawerThemeData get drawerTheme => DrawerThemeData(
        backgroundColor: Colors.white,
      );

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        isDense: true,
      );

  @override
  SnackBarThemeData get snackBarTheme => const SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
      );

  @override
  SwitchThemeData get switchTheme => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return colorScheme.primary;
          }
          return Colors.grey;
        }),
      );

  @override
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFF6D7D94),
        foregroundColor: Colors.white,
        elevation: 1,
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      );

  @override
  ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFF6D7D94),
      );

  @override
  ButtonStyle get deleteButtonStyle => TextButton.styleFrom(
        foregroundColor: const Color(0xFFD84315),
      );

  @override
  Widget buildHomeLayout({required Widget child}) {
    return Container(
      color: const Color(0xFFF7F8FA),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: child,
      ),
    );
  }

  @override
  Widget buildTaskCard(
    Task task, {
    required VoidCallback onToggleComplete,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE6E9EF)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x14000000),
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          leading: GestureDetector(
            onTap: onToggleComplete,
            child: Icon(
              task.status == 'completed'
                  ? Icons.check_circle
                  : Icons.radio_button_unchecked,
              color: task.status == 'completed'
                  ? const Color(0xFF4CAF50)
                  : const Color(0xFF90A4AE),
            ),
          ),
          title: Text(
            task.title,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              decoration: task.status == 'completed'
                  ? TextDecoration.lineThrough
                  : null,
            ),
          ),
          subtitle: Text(
            task.description?.isNotEmpty == true
                ? task.description!
                : (task.startDate != null ? formatDate(task.startDate!) : ''),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontSize: 12, color: Color(0xFF7A869A)),
          ),
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFD84315)),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }

  @override
  Widget buildJournalCard(
    JournalEntry entry, {
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFFE6E9EF)),
        ),
        child: ListTile(
          dense: true,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          leading: Container(
            width: 30,
            height: 30,
            decoration: BoxDecoration(
              color: const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(6),
            ),
            child:
                const Icon(Icons.edit_note, size: 18, color: Color(0xFF546E7A)),
          ),
          title: Text(
            entry.content,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 13),
          ),
          subtitle: entry.startDate != null
              ? Text(
                  '${formatDate(entry.startDate!)} • ${formatTime(entry.startDate!)}',
                  style:
                      const TextStyle(fontSize: 11, color: Color(0xFF7A869A)),
                )
              : null,
          trailing: IconButton(
            icon: const Icon(Icons.delete_outline, color: Color(0xFFD84315)),
            onPressed: onDelete,
          ),
        ),
      ),
    );
  }

  @override
  Future<Task?> showTaskDialog({
    required BuildContext context,
    Task? existingTask,
  }) {
    final titleCtrl = TextEditingController(text: existingTask?.title ?? '');
    final descCtrl =
        TextEditingController(text: existingTask?.description ?? '');
    DateTime? selectedDate = existingTask?.startDate;

    return showDialog<Task>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: Colors.white,
          title: Text(
            existingTask == null ? 'New Task' : 'Edit Task',
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today, size: 18),
                  label: Text(
                    selectedDate == null
                        ? 'Select due date'
                        : formatDate(selectedDate!),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel'),
            ),
            FilledButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                final now = DateTime.now();
                final result = existingTask != null
                    ? existingTask.copyWith(
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim().isEmpty
                            ? null
                            : descCtrl.text.trim(),
                        startDate: selectedDate,
                        updatedAt: now,
                      )
                    : Task(
                        id: '',
                        createdAt: now,
                        updatedAt: now,
                        ownerId: '',
                        moduleSource: 'tasks',
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim().isEmpty
                            ? null
                            : descCtrl.text.trim(),
                        startDate: selectedDate,
                        status: 'pending',
                      );
                Navigator.pop(ctx, result);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFF6C8EBF),
              ),
              child: Text(existingTask == null ? 'Create' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<JournalEntry?> showJournalDialog({
    required BuildContext context,
    JournalEntry? existingEntry,
  }) {
    final contentCtrl =
        TextEditingController(text: existingEntry?.content ?? '');

    return showDialog<JournalEntry>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: Colors.white,
        title: Text(
          existingEntry == null ? 'New Entry' : 'Edit Entry',
          style: const TextStyle(fontWeight: FontWeight.w700),
        ),
        content: TextField(
          controller: contentCtrl,
          maxLines: 8,
          decoration: const InputDecoration(
            labelText: 'Write something...',
            border: OutlineInputBorder(),
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel'),
          ),
          FilledButton(
            onPressed: () {
              if (contentCtrl.text.trim().isEmpty) return;
              final now = DateTime.now();
              final result = existingEntry != null
                  ? existingEntry.copyWith(
                      content: contentCtrl.text.trim(),
                      updatedAt: now,
                    )
                  : JournalEntry(
                      id: '',
                      createdAt: now,
                      updatedAt: now,
                      ownerId: '',
                      moduleSource: 'journal',
                      content: contentCtrl.text.trim(),
                      startDate: now,
                    );
              Navigator.pop(ctx, result);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFF6C8EBF),
            ),
            child: Text(existingEntry == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildCreateFab({required VoidCallback onPressed}) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFF6C8EBF),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  @override
  Widget buildCalendarView(
    List<SchedulableEntity> items, {
    required CalendarViewMode viewMode,
    required DateTime focusDate,
    Function(SchedulableEntity)? onItemTap,
    Function(SchedulableEntity)? onToggleComplete,
  }) {
    switch (viewMode) {
      case CalendarViewMode.day:
        return _buildModernDayView(items, focusDate,
            onItemTap: onItemTap, onToggleComplete: onToggleComplete);
      case CalendarViewMode.week:
        return _buildModernWeekView(items, focusDate,
            onItemTap: onItemTap, onToggleComplete: onToggleComplete);
      case CalendarViewMode.month:
        return _buildModernMonthView(items, focusDate,
            onItemTap: onItemTap, onToggleComplete: onToggleComplete);
    }
  }

  // ── Day View ──────────────────────────────────────────────────────────────
  Widget _buildModernDayView(List<SchedulableEntity> items, DateTime day,
      {Function(SchedulableEntity)? onItemTap,
      Function(SchedulableEntity)? onToggleComplete}) {
    final dayKey = DateTime(day.year, day.month, day.day);
    final dayItems = items
        .where((e) =>
            e.startDate != null &&
            DateTime(e.startDate!.year, e.startDate!.month, e.startDate!.day) ==
                dayKey)
        .toList()
      ..sort(
          (a, b) => (a.startDate ?? dayKey).compareTo(b.startDate ?? dayKey));

    if (dayItems.isEmpty) {
      return buildEmptyState(
        icon: Icons.calendar_view_day,
        label: 'No events on ${formatDate(day)}',
        color: const Color(0xFF9EADB8),
      );
    }

    // Time-slot day view: 24-hour column
    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      itemCount: 24,
      itemBuilder: (context, hour) {
        final hourItems = dayItems.where((item) {
          final h = item.startDate?.hour ?? -1;
          return h == hour;
        }).toList();

        return Container(
          key: ValueKey('hour_$hour'),
          decoration: BoxDecoration(
            border: Border(
              bottom: BorderSide(
                color: const Color(0xFFE6E9EF),
                width: 0.5,
              ),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 52,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 6, right: 8),
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 11,
                        color: Color(0xFF7A869A),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 44),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: hourItems.isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: hourItems
                                .map((item) => _modernEventChip(item,
                                    onItemTap: onItemTap,
                                    onToggleComplete: onToggleComplete))
                                .toList(),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _modernEventChip(SchedulableEntity item,
      {Function(SchedulableEntity)? onItemTap,
      Function(SchedulableEntity)? onToggleComplete}) {
    final key = item is BaseEntity
        ? ValueKey((item as BaseEntity).id)
        : ValueKey(item.hashCode);
    final completed = isCompletedItem(item);
    final isTask = isTaskItem(item);
    return GestureDetector(
      onTap: onItemTap != null ? () => onItemTap(item) : null,
      child: Container(
        key: key,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        decoration: BoxDecoration(
          color: completed ? const Color(0xFFE8F5E9) : const Color(0xFFE3F0FF),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
              color: completed
                  ? const Color(0xFFA5D6A7)
                  : const Color(0xFFB3D4F7)),
        ),
        child: Row(
          children: [
            if (isTask && onToggleComplete != null)
              GestureDetector(
                onTap: () => onToggleComplete(item),
                child: Icon(
                  completed ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 18,
                  color: completed
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFF5A8CC8),
                ),
              )
            else
              Icon(iconForItem(item), size: 14, color: const Color(0xFF5A8CC8)),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                titleForItem(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  decoration: completed ? TextDecoration.lineThrough : null,
                  color: completed ? const Color(0xFF7A869A) : null,
                ),
              ),
            ),
            if (item.startDate != null)
              Text(
                formatTime(item.startDate!),
                style: const TextStyle(fontSize: 10, color: Color(0xFF7A869A)),
              ),
          ],
        ),
      ),
    );
  }

  // ── Week View ─────────────────────────────────────────────────────────────
  Widget _buildModernWeekView(List<SchedulableEntity> items, DateTime focus,
      {Function(SchedulableEntity)? onItemTap,
      Function(SchedulableEntity)? onToggleComplete}) {
    final weekStart = focus.subtract(Duration(days: focus.weekday - 1));
    final grouped = groupByDay(items);

    return Column(
      children: [
        // Weekday header row
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
          decoration: const BoxDecoration(
            color: Color(0xFFF1F4F8),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE6E9EF)),
            ),
          ),
          child: Row(
            children: List.generate(7, (i) {
              final d = weekStart.add(Duration(days: i));
              final isToday = _isSameDay(d, DateTime.now());
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  decoration: isToday
                      ? BoxDecoration(
                          color: colorScheme.primary.withValues(alpha: 0.12),
                          borderRadius: BorderRadius.circular(8),
                        )
                      : null,
                  child: Column(
                    children: [
                      Text(
                        weekdayLabels[i],
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: isToday
                              ? colorScheme.primary
                              : const Color(0xFF7A869A),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${d.day}',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight:
                              isToday ? FontWeight.w800 : FontWeight.w500,
                          color: isToday
                              ? colorScheme.primary
                              : const Color(0xFF455A64),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        // Day columns with events
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(7, (i) {
                final d = weekStart.add(Duration(days: i));
                final dayKey = DateTime(d.year, d.month, d.day);
                final dayItems = grouped[dayKey] ?? [];

                return Expanded(
                  child: Container(
                    key: ValueKey('week_day_$i'),
                    decoration: BoxDecoration(
                      border: Border(
                        right: i < 6
                            ? const BorderSide(
                                color: Color(0xFFE6E9EF), width: 0.5)
                            : BorderSide.none,
                      ),
                    ),
                    constraints: const BoxConstraints(minHeight: 120),
                    padding: const EdgeInsets.all(2),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: dayItems.isEmpty
                          ? [const SizedBox(height: 4)]
                          : dayItems
                              .map((item) => _modernWeekEventChip(item,
                                  onItemTap: onItemTap))
                              .toList(),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _modernWeekEventChip(SchedulableEntity item,
      {Function(SchedulableEntity)? onItemTap}) {
    final key = item is BaseEntity
        ? ValueKey((item as BaseEntity).id)
        : ValueKey(item.hashCode);
    final completed = isCompletedItem(item);
    return GestureDetector(
      onTap: onItemTap != null ? () => onItemTap(item) : null,
      child: Container(
        key: key,
        margin: const EdgeInsets.symmetric(vertical: 1, horizontal: 1),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 3),
        decoration: BoxDecoration(
          color: completed ? const Color(0xFFE8F5E9) : const Color(0xFFE3F0FF),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          titleForItem(item),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w500,
            decoration: completed ? TextDecoration.lineThrough : null,
            color: completed ? const Color(0xFF7A869A) : null,
          ),
        ),
      ),
    );
  }

  // ── Month View ────────────────────────────────────────────────────────────
  Widget _buildModernMonthView(List<SchedulableEntity> items, DateTime focus,
      {Function(SchedulableEntity)? onItemTap,
      Function(SchedulableEntity)? onToggleComplete}) {
    final firstOfMonth = DateTime(focus.year, focus.month, 1);
    final lastOfMonth = DateTime(focus.year, focus.month + 1, 0);
    final startWeekday = firstOfMonth.weekday; // Mon=1
    final daysInMonth = lastOfMonth.day;
    final grouped = groupByDay(items);

    // Leading empty cells + days
    final totalCells = ((startWeekday - 1) + daysInMonth);
    final rows = (totalCells / 7).ceil();

    return Column(
      children: [
        // Weekday headers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
          decoration: const BoxDecoration(
            color: Color(0xFFF1F4F8),
            border: Border(
              bottom: BorderSide(color: Color(0xFFE6E9EF)),
            ),
          ),
          child: Row(
            children: weekdayLabels
                .map((label) => Expanded(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF7A869A),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        // Calendar grid
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellHeight =
                  (constraints.maxHeight / rows).clamp(60.0, 120.0);
              return SingleChildScrollView(
                child: Column(
                  children: List.generate(rows, (row) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(7, (col) {
                        final cellIndex = row * 7 + col;
                        final dayNum = cellIndex - (startWeekday - 1) + 1;

                        if (dayNum < 1 || dayNum > daysInMonth) {
                          return Expanded(
                            child: Container(
                              height: cellHeight,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFF0F0F0),
                                  width: 0.5,
                                ),
                              ),
                            ),
                          );
                        }

                        final cellDate =
                            DateTime(focus.year, focus.month, dayNum);
                        final isToday = _isSameDay(cellDate, DateTime.now());
                        final dayEvents = grouped[cellDate] ?? [];

                        return Expanded(
                          child: Container(
                            key: ValueKey('month_cell_$dayNum'),
                            height: cellHeight,
                            decoration: BoxDecoration(
                              color: isToday
                                  ? colorScheme.primary.withValues(alpha: 0.06)
                                  : null,
                              border: Border.all(
                                color: const Color(0xFFF0F0F0),
                                width: 0.5,
                              ),
                            ),
                            padding: const EdgeInsets.all(2),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$dayNum',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: isToday
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    color: isToday
                                        ? colorScheme.primary
                                        : const Color(0xFF455A64),
                                  ),
                                ),
                                ...dayEvents.take(3).map((item) =>
                                    _modernMonthDot(item,
                                        onItemTap: onItemTap)),
                                if (dayEvents.length > 3)
                                  Text(
                                    '+${dayEvents.length - 3}',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF7A869A),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _modernMonthDot(SchedulableEntity item,
      {Function(SchedulableEntity)? onItemTap}) {
    final completed = isCompletedItem(item);
    return GestureDetector(
      onTap: onItemTap != null ? () => onItemTap(item) : null,
      child: Container(
        margin: const EdgeInsets.only(top: 1),
        padding: const EdgeInsets.symmetric(horizontal: 3, vertical: 1),
        decoration: BoxDecoration(
          color: completed ? const Color(0xFFE8F5E9) : const Color(0xFFE3F0FF),
          borderRadius: BorderRadius.circular(3),
        ),
        child: Text(
          titleForItem(item),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w500,
            decoration: completed ? TextDecoration.lineThrough : null,
            color: completed ? const Color(0xFF7A869A) : null,
          ),
        ),
      ),
    );
  }
}

class CozyIllustratedTheme extends _BaseThemeConfig {
  @override
  ColorScheme get colorScheme => ColorScheme.fromSeed(
        seedColor: const Color(0xFFC39A7A),
        brightness: Brightness.light,
      );

  @override
  TextTheme get textTheme => const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 28,
          fontWeight: FontWeight.w800,
          color: Color(0xFF6D4C41),
        ),
        titleMedium: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          color: Color(0xFF5D4037),
        ),
        bodyMedium: TextStyle(
          fontSize: 15,
          height: 1.35,
          color: Color(0xFF5D4037),
        ),
        bodySmall: TextStyle(fontSize: 13, color: Color(0xFF8D6E63)),
      );

  @override
  AppBarTheme get appBarTheme => const AppBarTheme(
        backgroundColor: Color(0xFFF8EFE4),
        foregroundColor: Color(0xFF6D4C41),
        elevation: 0,
      );

  @override
  DrawerThemeData get drawerTheme => const DrawerThemeData(
        backgroundColor: Color(0xFFFFFCF5),
      );

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        filled: true,
        fillColor: const Color(0xFFFFF7EC),
      );

  @override
  SnackBarThemeData get snackBarTheme => SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
      );

  @override
  SwitchThemeData get switchTheme => SwitchThemeData(
        thumbColor: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const Color(0xFFC39A7A);
          }
          return const Color(0xFFBCAAA4);
        }),
      );

  @override
  ButtonStyle get primaryButtonStyle => ElevatedButton.styleFrom(
        backgroundColor: const Color(0xFFC39A7A),
        foregroundColor: Colors.white,
        elevation: 4,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      );

  @override
  ButtonStyle get secondaryButtonStyle => OutlinedButton.styleFrom(
        foregroundColor: const Color(0xFFC39A7A),
        side: const BorderSide(color: Color(0xFFC39A7A), width: 2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(18),
        ),
      );

  @override
  ButtonStyle get deleteButtonStyle => TextButton.styleFrom(
        foregroundColor: const Color(0xFFD2694F),
      );

  @override
  Widget buildSectionHeader({
    required IconData icon,
    required String title,
    required Color iconColor,
    VoidCallback? onRefresh,
  }) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF6E9), Color(0xFFFFFBF5)],
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF7D9C4),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, color: const Color(0xFFB57F50), size: 20),
          ),
          const SizedBox(width: 12),
          Text(
            title,
            style: const TextStyle(
              fontSize: 19,
              fontWeight: FontWeight.bold,
              color: Color(0xFF6D4C41),
            ),
          ),
          const Spacer(),
          if (onRefresh != null)
            IconButton(
              icon: const Icon(Icons.refresh, color: Color(0xFFC39A7A)),
              onPressed: onRefresh,
              tooltip: 'Refresh',
            ),
        ],
      ),
    );
  }

  @override
  Widget buildFeatureChip({required String label}) {
    return Chip(
      label: Text(label, style: const TextStyle(color: Color(0xFF6D4C41))),
      backgroundColor: const Color(0xFFFFF3E0),
      side: const BorderSide(color: Color(0xFFC39A7A), width: 1),
    );
  }

  @override
  Widget buildPresetBadge({required String preset}) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFFFFF7EC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFC39A7A)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.palette, color: Color(0xFFB57F50), size: 18),
          const SizedBox(width: 6),
          Text(
            'Preset: ${preset[0].toUpperCase()}${preset.substring(1)}',
            style: const TextStyle(
              fontSize: 13,
              color: Color(0xFF6D4C41),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDrawerHeader({
    required String appTitle,
    required String subtitle,
  }) {
    return Container(
      height: 160,
      padding: const EdgeInsets.all(20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFF8EFE4), Color(0xFFFFF7ED)],
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const Icon(Icons.spa, color: Color(0xFFC39A7A), size: 32),
          const SizedBox(height: 8),
          const Text(
            'Pluc',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w800,
              color: Color(0xFF6D4C41),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 14,
              color: Color(0xFF8D6E63),
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildDrawerItem({
    required String label,
    required IconData icon,
    required bool selected,
    required VoidCallback onTap,
    Key? key,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: selected ? const Color(0xFFFFF3E0) : null,
        borderRadius: BorderRadius.circular(12),
      ),
      child: ListTile(
        key: key,
        leading: Icon(
          icon,
          color: selected ? const Color(0xFFC39A7A) : const Color(0xFF8D6E63),
        ),
        title: Text(
          label,
          style: TextStyle(
            color: selected ? const Color(0xFF6D4C41) : const Color(0xFF5D4037),
            fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          ),
        ),
        selected: selected,
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  @override
  Widget buildHomeLayout({required Widget child}) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [Color(0xFFF8EFE4), Color(0xFFFFF7ED)],
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(14, 14, 14, 8),
        child: child,
      ),
    );
  }

  @override
  Widget buildTaskCard(
    Task task, {
    required VoidCallback onToggleComplete,
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFFFF8E1), Color(0xFFFFF3E0)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(22),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 12,
              offset: Offset(0, 5),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                height: 84,
                decoration: BoxDecoration(
                  color: const Color(0xFFF3E5D8),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Center(
                  child: Icon(
                    Icons.landscape_rounded,
                    size: 36,
                    color: Color(0xFFB08968),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  GestureDetector(
                    onTap: onToggleComplete,
                    child: Icon(
                      task.status == 'completed'
                          ? Icons.check_circle
                          : Icons.radio_button_unchecked,
                      color: task.status == 'completed'
                          ? const Color(0xFF6D9F71)
                          : const Color(0xFFBCAAA4),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      task.title,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF5D4037),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFFD2694F)),
                    onPressed: onDelete,
                  ),
                ],
              ),
              if (task.description?.isNotEmpty == true) ...[
                const SizedBox(height: 6),
                Text(
                  task.description!,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style:
                      const TextStyle(fontSize: 14, color: Color(0xFF6D4C41)),
                ),
              ],
              if (task.startDate != null) ...[
                const SizedBox(height: 8),
                Text(
                  '${formatDate(task.startDate!)} • ${formatTime(task.startDate!)}',
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF8D6E63)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget buildJournalCard(
    JournalEntry entry, {
    required VoidCallback onTap,
    required VoidCallback onDelete,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFFCF5),
          borderRadius: BorderRadius.circular(24),
          boxShadow: const [
            BoxShadow(
              color: Color(0x1A000000),
              blurRadius: 14,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    width: 38,
                    height: 38,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF7D9C4),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(
                      Icons.auto_stories_rounded,
                      color: Color(0xFFB57F50),
                    ),
                  ),
                  const SizedBox(width: 10),
                  const Expanded(
                    child: Text(
                      'Diary Entry',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6D4C41),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete, color: Color(0xFFD2694F)),
                    onPressed: onDelete,
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF7EC),
                  borderRadius: BorderRadius.circular(14),
                ),
                padding: const EdgeInsets.all(12),
                child: Text(
                  entry.content,
                  maxLines: 4,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 1.35,
                    color: Color(0xFF5D4037),
                  ),
                ),
              ),
              if (entry.startDate != null) ...[
                const SizedBox(height: 10),
                Text(
                  '${formatDate(entry.startDate!)} • ${formatTime(entry.startDate!)}',
                  style:
                      const TextStyle(fontSize: 13, color: Color(0xFF8D6E63)),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }

  @override
  Future<Task?> showTaskDialog({
    required BuildContext context,
    Task? existingTask,
  }) {
    final titleCtrl = TextEditingController(text: existingTask?.title ?? '');
    final descCtrl =
        TextEditingController(text: existingTask?.description ?? '');
    DateTime? selectedDate = existingTask?.startDate;

    return showDialog<Task>(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          backgroundColor: const Color(0xFFFFFCF5),
          title: Text(
            existingTask == null ? 'New Task' : 'Edit Task',
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: Color(0xFF5D4037),
            ),
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: titleCtrl,
                  decoration: InputDecoration(
                    labelText: 'Title',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFF7EC),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: descCtrl,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: 'Description',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    filled: true,
                    fillColor: const Color(0xFFFFF7EC),
                  ),
                ),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  icon: const Icon(Icons.calendar_today,
                      size: 18, color: Color(0xFFB57F50)),
                  label: Text(
                    selectedDate == null
                        ? 'Select due date'
                        : formatDate(selectedDate!),
                    style: const TextStyle(color: Color(0xFF6D4C41)),
                  ),
                  style: OutlinedButton.styleFrom(
                    side: const BorderSide(color: Color(0xFFC39A7A)),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14)),
                  ),
                  onPressed: () async {
                    final picked = await showDatePicker(
                      context: ctx,
                      initialDate: selectedDate ?? DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2100),
                    );
                    if (picked != null) {
                      setDialogState(() => selectedDate = picked);
                    }
                  },
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Cancel',
                  style: TextStyle(color: Color(0xFF8D6E63))),
            ),
            FilledButton(
              onPressed: () {
                if (titleCtrl.text.trim().isEmpty) return;
                final now = DateTime.now();
                final result = existingTask != null
                    ? existingTask.copyWith(
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim().isEmpty
                            ? null
                            : descCtrl.text.trim(),
                        startDate: selectedDate,
                        updatedAt: now,
                      )
                    : Task(
                        id: '',
                        createdAt: now,
                        updatedAt: now,
                        ownerId: '',
                        moduleSource: 'tasks',
                        title: titleCtrl.text.trim(),
                        description: descCtrl.text.trim().isEmpty
                            ? null
                            : descCtrl.text.trim(),
                        startDate: selectedDate,
                        status: 'pending',
                      );
                Navigator.pop(ctx, result);
              },
              style: FilledButton.styleFrom(
                backgroundColor: const Color(0xFFB08968),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
              ),
              child: Text(existingTask == null ? 'Create' : 'Save'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Future<JournalEntry?> showJournalDialog({
    required BuildContext context,
    JournalEntry? existingEntry,
  }) {
    final contentCtrl =
        TextEditingController(text: existingEntry?.content ?? '');

    return showDialog<JournalEntry>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        backgroundColor: const Color(0xFFFFFCF5),
        title: Text(
          existingEntry == null ? 'New Entry' : 'Edit Entry',
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF5D4037),
          ),
        ),
        content: TextField(
          controller: contentCtrl,
          maxLines: 8,
          decoration: InputDecoration(
            labelText: 'Write something...',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            filled: true,
            fillColor: const Color(0xFFFFF7EC),
            alignLabelWithHint: true,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel',
                style: TextStyle(color: Color(0xFF8D6E63))),
          ),
          FilledButton(
            onPressed: () {
              if (contentCtrl.text.trim().isEmpty) return;
              final now = DateTime.now();
              final result = existingEntry != null
                  ? existingEntry.copyWith(
                      content: contentCtrl.text.trim(),
                      updatedAt: now,
                    )
                  : JournalEntry(
                      id: '',
                      createdAt: now,
                      updatedAt: now,
                      ownerId: '',
                      moduleSource: 'journal',
                      content: contentCtrl.text.trim(),
                      startDate: now,
                    );
              Navigator.pop(ctx, result);
            },
            style: FilledButton.styleFrom(
              backgroundColor: const Color(0xFFB08968),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14)),
            ),
            child: Text(existingEntry == null ? 'Create' : 'Save'),
          ),
        ],
      ),
    );
  }

  @override
  Widget buildCreateFab({required VoidCallback onPressed}) {
    return FloatingActionButton(
      onPressed: onPressed,
      backgroundColor: const Color(0xFFB08968),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      child: const Icon(Icons.add, color: Colors.white),
    );
  }

  @override
  Widget buildCalendarView(
    List<SchedulableEntity> items, {
    required CalendarViewMode viewMode,
    required DateTime focusDate,
    Function(SchedulableEntity)? onItemTap,
    Function(SchedulableEntity)? onToggleComplete,
  }) {
    switch (viewMode) {
      case CalendarViewMode.day:
        return _buildCozyDayView(items, focusDate,
            onItemTap: onItemTap, onToggleComplete: onToggleComplete);
      case CalendarViewMode.week:
        return _buildCozyWeekView(items, focusDate,
            onItemTap: onItemTap, onToggleComplete: onToggleComplete);
      case CalendarViewMode.month:
        return _buildCozyMonthView(items, focusDate,
            onItemTap: onItemTap, onToggleComplete: onToggleComplete);
    }
  }

  @override
  Widget buildCalendarToolbar({
    required BuildContext context,
    required CalendarViewMode currentMode,
    required DateTime focusDate,
    required ValueChanged<CalendarViewMode> onModeChanged,
    required VoidCallback onPrevious,
    required VoidCallback onNext,
    required VoidCallback onToday,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          colors: [Color(0xFFFFF6E9), Color(0xFFFFFBF5)],
        ),
      ),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.chevron_left, color: Color(0xFFB57F50)),
            onPressed: onPrevious,
          ),
          IconButton(
            icon: const Icon(Icons.calendar_today, color: Color(0xFFC39A7A)),
            onPressed: onToday,
            tooltip: 'Today',
          ),
          IconButton(
            icon: const Icon(Icons.chevron_right, color: Color(0xFFB57F50)),
            onPressed: onNext,
          ),
          Expanded(
            child: Text(
              _toolbarTitle(currentMode, focusDate),
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF6D4C41),
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SegmentedButton<CalendarViewMode>(
            segments: const [
              ButtonSegment(
                value: CalendarViewMode.day,
                label: Text('Day'),
              ),
              ButtonSegment(
                value: CalendarViewMode.week,
                label: Text('Week'),
              ),
              ButtonSegment(
                value: CalendarViewMode.month,
                label: Text('Month'),
              ),
            ],
            selected: {currentMode},
            onSelectionChanged: (s) => onModeChanged(s.first),
            style: ButtonStyle(
              visualDensity: VisualDensity.compact,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              backgroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFFF7D9C4);
                }
                return const Color(0xFFFFF7EC);
              }),
              foregroundColor: WidgetStateProperty.resolveWith((states) {
                if (states.contains(WidgetState.selected)) {
                  return const Color(0xFF6D4C41);
                }
                return const Color(0xFF8D6E63);
              }),
              textStyle: const WidgetStatePropertyAll(
                TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
              shape: WidgetStatePropertyAll(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ── Day View ──────────────────────────────────────────────────────────────
  Widget _buildCozyDayView(List<SchedulableEntity> items, DateTime day,
      {Function(SchedulableEntity)? onItemTap,
      Function(SchedulableEntity)? onToggleComplete}) {
    final dayKey = DateTime(day.year, day.month, day.day);
    final dayItems = items
        .where((e) =>
            e.startDate != null &&
            DateTime(e.startDate!.year, e.startDate!.month, e.startDate!.day) ==
                dayKey)
        .toList()
      ..sort(
          (a, b) => (a.startDate ?? dayKey).compareTo(b.startDate ?? dayKey));

    if (dayItems.isEmpty) {
      return buildEmptyState(
        icon: Icons.wb_sunny_outlined,
        label: 'Nothing planned for ${formatDate(day)}',
        color: const Color(0xFFC5A58A),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      itemCount: 24,
      itemBuilder: (context, hour) {
        final hourItems = dayItems.where((item) {
          final h = item.startDate?.hour ?? -1;
          return h == hour;
        }).toList();

        return Container(
          key: ValueKey('hour_$hour'),
          decoration: const BoxDecoration(
            border: Border(
              bottom: BorderSide(color: Color(0xFFF3E5D8), width: 0.5),
            ),
          ),
          child: IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 56,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8, right: 10),
                    child: Text(
                      '${hour.toString().padLeft(2, '0')}:00',
                      textAlign: TextAlign.right,
                      style: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8D6E63),
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    constraints: const BoxConstraints(minHeight: 48),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                    child: hourItems.isEmpty
                        ? const SizedBox.shrink()
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: hourItems
                                .map((item) => _cozyEventChip(item,
                                    onItemTap: onItemTap,
                                    onToggleComplete: onToggleComplete))
                                .toList(),
                          ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _cozyEventChip(SchedulableEntity item,
      {Function(SchedulableEntity)? onItemTap,
      Function(SchedulableEntity)? onToggleComplete}) {
    final key = item is BaseEntity
        ? ValueKey((item as BaseEntity).id)
        : ValueKey(item.hashCode);
    final completed = isCompletedItem(item);
    final isTask = isTaskItem(item);
    return GestureDetector(
      onTap: onItemTap != null ? () => onItemTap(item) : null,
      child: Container(
        key: key,
        margin: const EdgeInsets.symmetric(vertical: 2),
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: completed
                ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
                : [const Color(0xFFFFF8E1), const Color(0xFFFFF3E0)],
          ),
          borderRadius: BorderRadius.circular(14),
          boxShadow: const [
            BoxShadow(
              color: Color(0x12000000),
              blurRadius: 6,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (isTask && onToggleComplete != null)
              GestureDetector(
                onTap: () => onToggleComplete(item),
                child: Icon(
                  completed ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 18,
                  color: completed
                      ? const Color(0xFF4CAF50)
                      : const Color(0xFFB57F50),
                ),
              )
            else
              Icon(iconForItem(item), size: 16, color: const Color(0xFFB57F50)),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                titleForItem(item),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF6D4C41),
                  decoration: completed ? TextDecoration.lineThrough : null,
                ),
              ),
            ),
            if (item.startDate != null)
              Text(
                formatTime(item.startDate!),
                style: const TextStyle(fontSize: 11, color: Color(0xFF8D6E63)),
              ),
          ],
        ),
      ),
    );
  }

  // ── Week View ─────────────────────────────────────────────────────────────
  Widget _buildCozyWeekView(List<SchedulableEntity> items, DateTime focus,
      {Function(SchedulableEntity)? onItemTap,
      Function(SchedulableEntity)? onToggleComplete}) {
    final weekStart = focus.subtract(Duration(days: focus.weekday - 1));
    final grouped = groupByDay(items);

    return Column(
      children: [
        // Cozy weekday header
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF6E9), Color(0xFFFFFBF5)],
            ),
            border: Border(
              bottom: BorderSide(color: Color(0xFFF3E5D8)),
            ),
          ),
          child: Row(
            children: List.generate(7, (i) {
              final d = weekStart.add(Duration(days: i));
              final isToday = _isSameDay(d, DateTime.now());
              return Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 6),
                  decoration: isToday
                      ? BoxDecoration(
                          color: const Color(0xFFF7D9C4),
                          borderRadius: BorderRadius.circular(12),
                        )
                      : null,
                  child: Column(
                    children: [
                      Text(
                        weekdayLabels[i],
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: isToday
                              ? const Color(0xFFB57F50)
                              : const Color(0xFF8D6E63),
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '${d.day}',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight:
                              isToday ? FontWeight.w800 : FontWeight.w500,
                          color: isToday
                              ? const Color(0xFF6D4C41)
                              : const Color(0xFF5D4037),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ),
        Expanded(
          child: SingleChildScrollView(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: List.generate(7, (i) {
                final d = weekStart.add(Duration(days: i));
                final dayKey = DateTime(d.year, d.month, d.day);
                final dayItems = grouped[dayKey] ?? [];

                return Expanded(
                  child: Container(
                    key: ValueKey('week_day_$i'),
                    decoration: BoxDecoration(
                      border: Border(
                        right: i < 6
                            ? const BorderSide(
                                color: Color(0xFFF3E5D8), width: 0.5)
                            : BorderSide.none,
                      ),
                    ),
                    constraints: const BoxConstraints(minHeight: 130),
                    padding: const EdgeInsets.all(3),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: dayItems.isEmpty
                          ? [const SizedBox(height: 4)]
                          : dayItems
                              .map((item) => _cozyWeekEventChip(item,
                                  onItemTap: onItemTap))
                              .toList(),
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ],
    );
  }

  Widget _cozyWeekEventChip(SchedulableEntity item,
      {Function(SchedulableEntity)? onItemTap}) {
    final key = item is BaseEntity
        ? ValueKey((item as BaseEntity).id)
        : ValueKey(item.hashCode);
    final completed = isCompletedItem(item);
    return GestureDetector(
      onTap: onItemTap != null ? () => onItemTap(item) : null,
      child: Container(
        key: key,
        margin: const EdgeInsets.symmetric(vertical: 2, horizontal: 1),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: completed
                ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
                : [const Color(0xFFFFF8E1), const Color(0xFFFFF3E0)],
          ),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Text(
          titleForItem(item),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6D4C41),
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }

  // ── Month View ────────────────────────────────────────────────────────────
  Widget _buildCozyMonthView(List<SchedulableEntity> items, DateTime focus,
      {Function(SchedulableEntity)? onItemTap,
      Function(SchedulableEntity)? onToggleComplete}) {
    final firstOfMonth = DateTime(focus.year, focus.month, 1);
    final lastOfMonth = DateTime(focus.year, focus.month + 1, 0);
    final startWeekday = firstOfMonth.weekday;
    final daysInMonth = lastOfMonth.day;
    final grouped = groupByDay(items);

    final totalCells = ((startWeekday - 1) + daysInMonth);
    final rows = (totalCells / 7).ceil();

    return Column(
      children: [
        // Weekday headers
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 8),
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFFF6E9), Color(0xFFFFFBF5)],
            ),
            border: Border(
              bottom: BorderSide(color: Color(0xFFF3E5D8)),
            ),
          ),
          child: Row(
            children: weekdayLabels
                .map((label) => Expanded(
                      child: Text(
                        label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF8D6E63),
                        ),
                      ),
                    ))
                .toList(),
          ),
        ),
        // Calendar grid
        Expanded(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final cellHeight =
                  (constraints.maxHeight / rows).clamp(64.0, 130.0);
              return SingleChildScrollView(
                child: Column(
                  children: List.generate(rows, (row) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: List.generate(7, (col) {
                        final cellIndex = row * 7 + col;
                        final dayNum = cellIndex - (startWeekday - 1) + 1;

                        if (dayNum < 1 || dayNum > daysInMonth) {
                          return Expanded(
                            child: Container(
                              height: cellHeight,
                              decoration: BoxDecoration(
                                border: Border.all(
                                  color: const Color(0xFFF3E5D8),
                                  width: 0.5,
                                ),
                              ),
                            ),
                          );
                        }

                        final cellDate =
                            DateTime(focus.year, focus.month, dayNum);
                        final isToday = _isSameDay(cellDate, DateTime.now());
                        final dayEvents = grouped[cellDate] ?? [];

                        return Expanded(
                          child: Container(
                            key: ValueKey('month_cell_$dayNum'),
                            height: cellHeight,
                            decoration: BoxDecoration(
                              gradient: isToday
                                  ? const LinearGradient(
                                      colors: [
                                        Color(0xFFFFF8E1),
                                        Color(0xFFFFF3E0)
                                      ],
                                    )
                                  : null,
                              border: Border.all(
                                color: const Color(0xFFF3E5D8),
                                width: 0.5,
                              ),
                              borderRadius:
                                  isToday ? BorderRadius.circular(8) : null,
                            ),
                            padding: const EdgeInsets.all(3),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '$dayNum',
                                  style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: isToday
                                        ? FontWeight.w800
                                        : FontWeight.w500,
                                    color: isToday
                                        ? const Color(0xFFB57F50)
                                        : const Color(0xFF6D4C41),
                                  ),
                                ),
                                ...dayEvents.take(3).map((item) =>
                                    _cozyMonthDot(item, onItemTap: onItemTap)),
                                if (dayEvents.length > 3)
                                  Text(
                                    '+${dayEvents.length - 3}',
                                    style: const TextStyle(
                                      fontSize: 9,
                                      color: Color(0xFF8D6E63),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        );
                      }),
                    );
                  }),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _cozyMonthDot(SchedulableEntity item,
      {Function(SchedulableEntity)? onItemTap}) {
    final completed = isCompletedItem(item);
    return GestureDetector(
      onTap: onItemTap != null ? () => onItemTap(item) : null,
      child: Container(
        margin: const EdgeInsets.only(top: 2),
        padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: completed
                ? [const Color(0xFFE8F5E9), const Color(0xFFC8E6C9)]
                : [const Color(0xFFFFF8E1), const Color(0xFFFFF3E0)],
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          titleForItem(item),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 9,
            fontWeight: FontWeight.w600,
            color: const Color(0xFF6D4C41),
            decoration: completed ? TextDecoration.lineThrough : null,
          ),
        ),
      ),
    );
  }
}

@Deprecated('Use ModernMinimalTheme directly')
class DefaultThemeConfig extends ModernMinimalTheme {}
