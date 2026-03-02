import 'package:flutter/material.dart';
import 'package:pluc/core/domain/entities/task.dart';
import 'package:pluc/features/journal/domain/entities/journal_entry.dart';
import 'package:pluc/core/entities.dart';

/// Abstract theme configuration that controls the entire UI structure.
/// 
/// This architecture allows complete visual restructuring by implementing
/// different theme configurations. Themes control not just colors/fonts,
/// but the actual widget structure, layout patterns, and visual hierarchy.
/// 
/// Example use cases:
/// - Switch between card-based and list-based layouts
/// - Change from horizontal to vertical calendar views
/// - Alternate between minimal and detailed task displays
/// - Support accessibility-focused layouts (high contrast, large touch targets)
abstract class AppThemeConfig {
  /// Visual styling - colors used throughout the app
  ColorScheme get colorScheme;

  /// Visual styling - typography system
  TextTheme get textTheme;

  /// Build the main home screen layout structure.
  /// 
  /// Controls how the main content area is presented:
  /// - Could wrap in a custom container with shadows
  /// - Could add background patterns or gradients
  /// - Could control padding and margins
  /// - Could add decorative UI elements
  /// 
  /// [child] is the actual screen content (Calendar, Tasks, etc.)
  Widget buildHomeLayout({required Widget child});

  /// Build a task display widget.
  /// 
  /// Controls how individual tasks are rendered:
  /// - Card vs ListTile vs custom widget
  /// - Dense vs spacious layouts
  /// - Show/hide different task properties
  /// - Custom interaction patterns
  /// 
  /// [task] is the task entity to display
  /// [onDelete] callback for delete action
  Widget buildTaskCard(
    Task task, {
    required VoidCallback onDelete,
  });

  /// Build a journal entry display widget.
  /// 
  /// Controls how journal entries are rendered:
  /// - Diary-style vs note-style cards
  /// - Compact vs expanded views
  /// - Different typography for content
  /// - Custom timestamp formatting
  /// 
  /// [entry] is the journal entry to display
  /// [onDelete] callback for delete action
  Widget buildJournalCard(
    JournalEntry entry, {
    required VoidCallback onDelete,
  });

  /// Build the calendar view structure.
  /// 
  /// Controls the entire calendar rendering approach:
  /// - Traditional grid calendar
  /// - Timeline/agenda view
  /// - Week view vs month view
  /// - Compact list of upcoming items
  /// - Visual density and spacing
  /// 
  /// [items] are the schedulable entities to display
  Widget buildCalendarView(List<SchedulableEntity> items);
}

/// Default theme implementation - maintains current visual structure.
/// 
/// This temporary implementation preserves the existing UI while
/// establishing the theme architecture. Future themes can dramatically
/// change the visual structure while maintaining compatibility.
class DefaultThemeConfig implements AppThemeConfig {
  @override
  ColorScheme get colorScheme => ColorScheme.fromSeed(
        seedColor: Colors.blue,
        brightness: Brightness.light,
      );

  @override
  TextTheme get textTheme => const TextTheme(
        headlineMedium: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.bold,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          color: Colors.grey,
        ),
      );

  @override
  Widget buildHomeLayout({required Widget child}) {
    // Default: simple container with standard padding
    return Container(
      color: Colors.grey.shade50,
      child: child,
    );
  }

  @override
  Widget buildTaskCard(
    Task task, {
    required VoidCallback onDelete,
  }) {
    // Default: ListTile with status icon, title, description, and delete button
    return ListTile(
      leading: Icon(
        task.status == 'completed'
            ? Icons.check_circle
            : Icons.radio_button_unchecked,
        color: task.status == 'completed' ? Colors.green : Colors.grey,
      ),
      title: Text(
        task.title,
        style: TextStyle(
          decoration: task.status == 'completed'
              ? TextDecoration.lineThrough
              : null,
        ),
      ),
      subtitle: task.description != null
          ? Text(
              task.description!,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            )
          : (task.startDate != null
              ? Text(
                  '📅 ${task.startDate!.toString().split(' ')[0]}',
                )
              : null),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (task.startDate != null && task.description != null)
            Text(
              task.startDate!.toString().split(' ')[0],
              style: const TextStyle(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
          IconButton(
            icon: const Icon(Icons.delete, color: Colors.red),
            onPressed: onDelete,
          ),
        ],
      ),
    );
  }

  @override
  Widget buildJournalCard(
    JournalEntry entry, {
    required VoidCallback onDelete,
  }) {
    // Default: Card with colored avatar, content preview, timestamp, and delete button
    return Card(
      margin: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: Colors.blue.shade100,
          child: Icon(
            Icons.article,
            color: Colors.blue.shade700,
          ),
        ),
        title: Text(
          entry.content,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
        subtitle: entry.startDate != null
            ? Text(
                '📅 ${_formatDate(entry.startDate!)}',
                style: const TextStyle(fontSize: 12),
              )
            : null,
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (entry.startDate != null)
              Text(
                _formatTime(entry.startDate!),
                style: const TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: onDelete,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget buildCalendarView(List<SchedulableEntity> items) {
    // Default: Simple list view of calendar items
    if (items.isEmpty) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.calendar_today, size: 64, color: Colors.grey),
            SizedBox(height: 16),
            Text(
              'No events this week',
              style: TextStyle(color: Colors.grey, fontSize: 16),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      itemCount: items.length,
      itemBuilder: (context, index) {
        final item = items[index];

        // Determine if it's a task or journal entry based on type
        if (item is Task) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.check_box, color: Colors.blue),
              title: Text(item.title),
              subtitle: item.startDate != null
                  ? Text(item.startDate!.toString().split(' ')[0])
                  : null,
            ),
          );
        } else if (item is JournalEntry) {
          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: ListTile(
              leading: const Icon(Icons.book, color: Colors.green),
              title: Text(
                item.content,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              subtitle: item.startDate != null
                  ? Text(item.startDate!.toString().split(' ')[0])
                  : null,
            ),
          );
        }

        // Fallback for unknown types
        return const SizedBox.shrink();
      },
    );
  }

  // Helper methods for date/time formatting
  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
