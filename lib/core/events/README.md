# Event System & Preset Service Refactoring

## Overview

The event system and preset logic have been refactored for type safety, scalability, and dependency injection.

### Key Changes

1. **EventBus**: String-based → Strongly typed event classes
2. **EventBus Scope**: Static singleton → Injected instance per context
3. **PresetService**: New service for managing feature toggles

---

## Event System: Strongly Typed Architecture

### The Problem (Before)

String-based events were error-prone and lacked type safety:

```dart
// ❌ Old approach - no type safety
eventBus.on('task_created', (payload) {
  // payload is dynamic, what's inside?
  final taskId = payload['taskId']; // String or int?
});

eventBus.emit('task_created', {'taskId': '123', 'title': 'My Task'});
```

**Issues:**

- Typos in event names silent fail
- No IDE autocomplete for event payloads
- Runtime errors if payload structure changes
- Hard to trace event flow

### The Solution (After)

Strongly typed event classes extending `AppEvent`:

```dart
/// Base event class - all events inherit from this
abstract class AppEvent {
  final DateTime timestamp;
  AppEvent({DateTime? timestamp})
    : timestamp = timestamp ?? DateTime.now();
}

/// Specific event with typed properties
class TaskCreatedEvent extends AppEvent {
  final String taskId;
  final String title;
  final String userId;

  TaskCreatedEvent({
    required this.taskId,
    required this.title,
    required this.userId,
    DateTime? timestamp,
  }) : super(timestamp: timestamp);
}
```

**Benefits:**

- Compile-time type checking
- IDE autocomplete and navigation
- Self-documenting event structure
- Easy to refactor

### Usage: Listening to Events

```dart
// ✅ Type-safe listener registration
final unsubscribe = eventBus.on<TaskCreatedEvent>((event) {
  print('Task created: ${event.title} by ${event.userId}');
  // 'event' is strongly typed - IDE knows all properties
});

// Cleanup
unsubscribe();
```

### Usage: Emitting Events

```dart
// ✅ Create typed event with all required fields
final event = TaskCreatedEvent(
  taskId: '123',
  title: 'Buy milk',
  userId: 'user_42',
);

// Emit to all listeners
await eventBus.emit(event);
```

### EventBus Design: Broadcast-Safe, Not a Singleton

**Key Principle:** EventBus is injected per context, not a static singleton.

```dart
// ✅ Correct: Injected via Riverpod
final eventBusProvider = Provider<EventBus>((ref) {
  return EventBus(); // New instance
});

// In widget:
final eventBus = ref.read(eventBusProvider);
eventBus.emit(TaskCreatedEvent(...));

// ❌ Wrong: Static singleton
class EventBus {
  static final _instance = EventBus._internal();
  // Global state - hard to test, causes race conditions
}
```

**Why This Matters:**

- **Testability**: Mock eventBus per test
- **Widget Tree Isolation**: Different parts of app can have independent event flows
- **Broadcast Safety**: Listeners can emit events without causing infinite loops
- **Concurrency**: Async listeners don't block other listeners

### Broadcast-Safe Implementation

```dart
Future<void> emit<T extends AppEvent>(T event) async {
  final listeners = _listeners[T];
  if (listeners == null || listeners.isEmpty) return;

  // Create a copy to allow listeners to modify list during iteration
  for (var listener in List<Function>.from(listeners)) {
    try {
      // Each listener runs independently
      (listener as EventListener<T>)(event);
    } catch (e) {
      // Error in one listener doesn't stop others
      print('EventBus: Error in listener: $e');
    }
  }
}
```

### Available Events

```
AppEvent (base)
├── TaskCreatedEvent
├── TaskCompletedEvent
├── TaskUpdatedEvent
├── JournalEntryCreatedEvent
├── JournalEntryUpdatedEvent
├── ModuleEnabledEvent
├── ModuleDisabledEvent
├── PresetAppliedEvent
├── UserSignedInEvent
├── UserSignedOutEvent
└── CalendarRefreshEvent
```

---

## PresetService: Feature Toggle Management

### The Problem (Before)

No centralized way to apply presets. Logic scattered across modules:

```dart
// ❌ Before - manual feature toggling
for (final toggle in featureToggles) {
  if (preset == 'minimal') {
    toggle.enabled = false; // Mutable - dangerous
  }
}
// No event emission, no audit trail
```

### The Solution (After)

`PresetService` encapsulates preset application logic:

```dart
class PresetService {
  final EventBus eventBus;

  Future<List<FeatureToggle>> applyPreset(
    PresetDefinition preset,
    List<FeatureToggle> currentToggles,
  ) async {
    // Apply preset, return new list (immutable)
    final updated = <FeatureToggle>[];

    for (final toggle in currentToggles) {
      if (preset.enabledFeatures.contains(toggle.name)) {
        updated.add(toggle.copyWith(enabled: true));
      } else if (preset.disabledFeatures.contains(toggle.name)) {
        updated.add(toggle.copyWith(enabled: false));
      } else {
        updated.add(toggle);
      }
    }

    // Emit event for logging/monitoring
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
}
```

### The Three Presets

```dart
// Structured: All features enabled (power users)
PresetDefinition(
  id: 'structured',
  moduleId: 'tasks',
  enabledFeatures: ['reminders', 'recurring', 'scheduling', 'notifications', 'collaboration'],
  disabledFeatures: [],
)

// Flexible: Core features (default users)
PresetDefinition(
  id: 'flexible',
  moduleId: 'tasks',
  enabledFeatures: ['reminders', 'recurring', 'scheduling'],
  disabledFeatures: ['collaboration'],
)

// Minimal: Essential only (distraction-free)
PresetDefinition(
  id: 'minimal',
  moduleId: 'tasks',
  enabledFeatures: [],
  disabledFeatures: ['reminders', 'recurring', 'scheduling', ...],
)
```

### Usage: Applying a Preset

```dart
// Get preset service
final presetService = ref.read(presetServiceProvider);

// Get current toggles
final currentToggles = [
  FeatureToggle(id: '1', moduleId: 'tasks', name: 'reminders', enabled: true),
  FeatureToggle(id: '2', moduleId: 'tasks', name: 'recurring', enabled: false),
];

// Get preset definition
final preset = PresetService.getPreset('minimal', 'tasks');

// Apply preset (immutable operation)
final updated = await presetService.applyPreset(preset!, currentToggles);

// Result: All features disabled per 'minimal' preset
// Event emitted for audit trail
```

### Dependency Injection

```dart
// In providers.dart
final presetServiceProvider = Provider<PresetService>((ref) {
  final eventBus = ref.read(eventBusProvider);
  return PresetService(eventBus: eventBus);
});

// In UI
final service = ref.read(presetServiceProvider);
```

---

## Architecture Improvements

### Type Safety

| Before                             | After                                |
| ---------------------------------- | ------------------------------------ |
| `eventBus.on('task_created', ...)` | `eventBus.on<TaskCreatedEvent>(...)` |
| Typos fail at runtime              | Typos caught at compile time         |
| Payload type unknown               | Event structure visible to IDE       |
| Hard to refactor                   | Easy cross-reference                 |

### Separation of Concerns

| Concern                  | Before                    | After                                     |
| ------------------------ | ------------------------- | ----------------------------------------- |
| **Event Names**          | Strings scattered in code | Single source of truth: `app_events.dart` |
| **Feature Toggle Logic** | Scattered across modules  | Centralized: `PresetService`              |
| **Preset Application**   | Manual, error-prone       | Safe, immutable operations                |
| **Event Audit**          | No logging                | `PresetAppliedEvent` emitted              |

### Testability

```dart
// Easy to mock
final mockEventBus = _MockEventBus();
final service = PresetService(eventBus: mockEventBus);

// Track events emitted during test
expect(mockEventBus.emittedEvents, contains(isA<PresetAppliedEvent>()));
```

### Scalability

**Adding New Event:**

1. Create class extending `AppEvent`
2. Add to `app_events.dart`
3. Use immediately with full type safety

```dart
class HabitCompletedEvent extends AppEvent {
  final String habitId;
  final DateTime completionDate;

  HabitCompletedEvent({...});
}

// Immediately available
eventBus.on<HabitCompletedEvent>((event) { ... });
```

**Adding New Preset:**

```dart
static Map<String, PresetDefinition> createDefaultPresets(String moduleId) {
  return {
    'advanced': PresetDefinition(...), // New preset
  };
}
```

---

## Architectural Risks Reduced

### 1. **Event Name Typos** ❌ → ✅

- **Risk**: Silent failures, debugging nightmare
- **Reduced**: Compile-time checks + IDE support

### 2. **Global State Mutation** ❌ → ✅

- **Risk**: Race conditions, hard to test, memory leaks
- **Reduced**: Injected instances, scoped to widget tree

### 3. **Unchecked Event Payloads** ❌ → ✅

- **Risk**: Type casting errors, null pointer exceptions
- **Reduced**: Strongly typed properties

### 4. **Feature Toggling Scattered Logic** ❌ → ✅

- **Risk**: Inconsistent behavior, hard to audit
- **Reduced**: Centralized `PresetService` with event emission

### 5. **Listener Side Effects** ❌ → ✅

- **Risk**: One broken listener stops event propagation
- **Reduced**: Error handling, independent listener execution

### 6. **Event Flow Debugging** ❌ → ✅

- **Risk**: Hard to trace which listeners respond to events
- **Reduced**: Strong typing makes event flow obvious

### 7. **Testing Event System** ❌ → ✅

- **Risk**: Global singleton hard to isolate
- **Reduced**: Dependency injection enables clean mocks

---

## Migration Path

### Old Code (Unsupported)

```dart
// Don't use - kept for reference
eventBus.on('task_created', (payload) { ... });
```

### New Code (Standard)

```dart
final eventBus = ref.read(eventBusProvider);
eventBus.on<TaskCreatedEvent>((event) { ... });
```

---

## Summary

| Aspect              | Improvement                        |
| ------------------- | ---------------------------------- |
| **Type Safety**     | 100% compile-time checked          |
| **Testability**     | Injectable, mockable               |
| **Maintainability** | Self-documenting, no magic strings |
| **Scalability**     | Easy to add events/presets         |
| **Reliability**     | Error handling, broadcast-safe     |
| **Auditability**    | Preset changes emitted as events   |
