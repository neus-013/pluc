import 'package:flutter/material.dart';
import 'package:pluc/core/domain/entities/task.dart';
import 'package:pluc/features/journal/domain/entities/journal_entry.dart';
import 'package:pluc/core/entities.dart';

/// App-wide theme contract that controls structure and styling.
///
/// The goal is structural theming: each implementation can reshape layout,
/// card architecture, spacing density, and section composition.
abstract class AppThemeConfig {
  ColorScheme get colorScheme;
  TextTheme get textTheme;

  Widget buildHomeLayout({required Widget child});

  Widget buildTaskCard(
    Task task, {
    required VoidCallback onDelete,
  });

  Widget buildJournalCard(
    JournalEntry entry, {
    required VoidCallback onDelete,
  });

  Widget buildCalendarView(List<SchedulableEntity> items);
}

abstract class _BaseThemeConfig implements AppThemeConfig {
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
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  String formatTime(DateTime date) =>
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';

  IconData iconForItem(SchedulableEntity item) {
    if (item is Task) return Icons.check_circle_outline;
    if (item is JournalEntry) return Icons.menu_book_outlined;
    return Icons.event_note;
  }

  String titleForItem(SchedulableEntity item) {
    if (item is Task) return item.title;
    if (item is JournalEntry) return item.content;
    return 'Event';
  }

  Widget buildCalendarItemRow(
    SchedulableEntity item, {
    required Color iconColor,
    required TextStyle titleStyle,
    required TextStyle timeStyle,
    EdgeInsetsGeometry? padding,
    BoxDecoration? decoration,
  }) {
    return Container(
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

  Widget buildEmptyState({
    required IconData icon,
    required String label,
    required Color color,
  }) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 56, color: color),
          const SizedBox(height: 12),
          Text(label, style: TextStyle(color: color, fontSize: 14)),
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
    required VoidCallback onDelete,
  }) {
    return Container(
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
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
        leading: Icon(
          task.status == 'completed'
              ? Icons.check_circle
              : Icons.radio_button_unchecked,
          color: task.status == 'completed'
              ? const Color(0xFF4CAF50)
              : const Color(0xFF90A4AE),
        ),
        title: Text(
          task.title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            decoration:
                task.status == 'completed' ? TextDecoration.lineThrough : null,
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
    );
  }

  @override
  Widget buildJournalCard(
    JournalEntry entry, {
    required VoidCallback onDelete,
  }) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFE6E9EF)),
      ),
      child: ListTile(
        dense: true,
        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
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
                style: const TextStyle(fontSize: 11, color: Color(0xFF7A869A)),
              )
            : null,
        trailing: IconButton(
          icon: const Icon(Icons.delete_outline, color: Color(0xFFD84315)),
          onPressed: onDelete,
        ),
      ),
    );
  }

  @override
  Widget buildCalendarView(List<SchedulableEntity> items) {
    final grouped = groupByDay(items);
    if (grouped.isEmpty) {
      return buildEmptyState(
        icon: Icons.calendar_view_day,
        label: 'No events this period',
        color: const Color(0xFF9EADB8),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      children: grouped.entries.map((entry) {
        final day = entry.key;
        final dayItems = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE6E9EF)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: double.infinity,
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: const BoxDecoration(
                  color: Color(0xFFF1F4F8),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(8)),
                ),
                child: Text(
                  formatDate(day),
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 13,
                    color: Color(0xFF455A64),
                  ),
                ),
              ),
              ...dayItems.map((item) => buildCalendarItemRow(
                    item,
                    iconColor: const Color(0xFF78909C),
                    titleStyle: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                    timeStyle: const TextStyle(
                      fontSize: 11,
                      color: Color(0xFF7A869A),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 10,
                    ),
                  )),
            ],
          ),
        );
      }).toList(),
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
    required VoidCallback onDelete,
  }) {
    return Container(
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
                Icon(
                  task.status == 'completed'
                      ? Icons.check_circle
                      : Icons.radio_button_unchecked,
                  color: task.status == 'completed'
                      ? const Color(0xFF6D9F71)
                      : const Color(0xFFBCAAA4),
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
                style: const TextStyle(fontSize: 14, color: Color(0xFF6D4C41)),
              ),
            ],
            if (task.startDate != null) ...[
              const SizedBox(height: 8),
              Text(
                '${formatDate(task.startDate!)} • ${formatTime(task.startDate!)}',
                style: const TextStyle(fontSize: 13, color: Color(0xFF8D6E63)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget buildJournalCard(
    JournalEntry entry, {
    required VoidCallback onDelete,
  }) {
    return Container(
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
                style: const TextStyle(fontSize: 13, color: Color(0xFF8D6E63)),
              ),
            ],
          ],
        ),
      ),
    );
  }

  @override
  Widget buildCalendarView(List<SchedulableEntity> items) {
    final grouped = groupByDay(items);
    if (grouped.isEmpty) {
      return buildEmptyState(
        icon: Icons.calendar_month_outlined,
        label: 'No cozy plans yet',
        color: const Color(0xFFC5A58A),
      );
    }

    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
      children: grouped.entries.map((entry) {
        final day = entry.key;
        final dayItems = entry.value;

        return Container(
          margin: const EdgeInsets.only(bottom: 14),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFFFF6E9), Color(0xFFFFFDF8)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                color: Color(0x17000000),
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
                Row(
                  children: [
                    Container(
                      width: 34,
                      height: 34,
                      decoration: BoxDecoration(
                        color: const Color(0xFFF7D9C4),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Icon(
                        Icons.wb_sunny_outlined,
                        size: 20,
                        color: Color(0xFFB57F50),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      formatDate(day),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF6D4C41),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                ...dayItems.map((item) => buildCalendarItemRow(
                      item,
                      iconColor: const Color(0xFFA1887F),
                      titleStyle: const TextStyle(
                        fontSize: 14,
                        color: Color(0xFF5D4037),
                      ),
                      timeStyle: const TextStyle(
                        fontSize: 12,
                        color: Color(0xFF8D6E63),
                      ),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFAF1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                    )),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }
}

@Deprecated('Use ModernMinimalTheme directly')
class DefaultThemeConfig extends ModernMinimalTheme {}
