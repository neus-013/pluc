# Event System & Preset Service: Architectural Risk Reduction

## Summary of Improvements

### 1. Event System: String-Based → Strongly Typed

**Before:**

```dart
eventBus.on('task_created', (payload) {
  final taskId = payload['taskId']; // What type is this?
});
eventBus.emit('task_created', {'taskId': '123'}); // Easy to misspell
```

**After:**

```dart
eventBus.on<TaskCreatedEvent>((event) {
  final taskId = event.taskId; // IDE knows the type
});
eventBus.emit(TaskCreatedEvent(taskId: '123', ...));
```

### 2. EventBus: Static Singleton → Injected Instance

**Before:**

```dart
// ❌ Global state - hard to test, race conditions
class EventBus {
  static final _instance = EventBus._internal();
}
```

**After:**

```dart
// ✅ Injected per context - testable, isolated
final eventBusProvider = Provider<EventBus>((ref) {
  return EventBus();
});
```

### 3. Feature Toggle Logic: Scattered → Centralized

**Before:**

- Preset logic scattered across modules
- No audit trail
- Mutable state modifications

**After:**

```dart
// PresetService encapsulates all logic
final updated = await presetService.applyPreset(preset, toggles);
// Emits PresetAppliedEvent for audit trail
```

---

## Architectural Risks Reduced

| Risk                           | Impact                               | Reduction                      |
| ------------------------------ | ------------------------------------ | ------------------------------ |
| **Event name typos**           | Silent failures, debugging nightmare | ✅ Compile-time checked        |
| **Type casting errors**        | Runtime exceptions                   | ✅ Strongly typed properties   |
| **Global state**               | Race conditions, untestable          | ✅ Dependency injection        |
| **Listener isolation**         | One error stops all listeners        | ✅ Error handling per listener |
| **Feature toggle consistency** | Scattered logic bugs                 | ✅ Centralized service         |
| **Event audit trail**          | No way to track changes              | ✅ Event emission              |
| **Testing complexity**         | Hard to mock global state            | ✅ Injectable providers        |

---

## Event Files Structure

```
lib/core/events/
├── app_events.dart      # All strongly typed event classes
├── event_bus.dart       # Type-safe, injectable event bus
└── README.md            # Complete event documentation
```

## Preset Service Structure

```
lib/core/services/
└── preset_service.dart  # Centralized preset application logic
```

## Dependency Injection

```
Core Providers (lib/core/providers.dart)
├── databaseProvider
├── authRepositoryProvider
├── taskRepositoryProvider
├── journalRepositoryProvider
├── calendarRepositoryProvider
├── eventBusProvider          [NEW]
└── presetServiceProvider     [NEW]
```

---

## Usage Examples

### Listening to Events

```dart
final eventBus = ref.read(eventBusProvider);

// With cleanup
final unsubscribe = eventBus.on<TaskCreatedEvent>((event) {
  print('Task: ${event.title} created by ${event.userId}');
});

// Clean up when done
unsubscribe();
```

### Emitting Events

```dart
await eventBus.emit(
  TaskCreatedEvent(
    taskId: 'task_123',
    title: 'Complete refactoring',
    userId: 'user_42',
  ),
);
```

### Applying Presets

```dart
final presetService = ref.read(presetServiceProvider);
final preset = PresetService.getPreset('minimal', 'tasks');
final updated = await presetService.applyPreset(preset!, toggles);
// PresetAppliedEvent automatically emitted
```

---

## Scalability Benefits

**Adding New Event:** Just extend `AppEvent` in `app_events.dart`  
**Adding New Preset:** Update `createDefaultPresets()` in `PresetService`  
**Testing:** Mock `EventBus` and `PresetService` per test  
**Monitoring:** Listen to events like `PresetAppliedEvent` for analytics

---

## Next Steps

1. Modules can now emit typed events for cross-module communication
2. UI can react to events without direct database coupling
3. Preset changes automatically audited via event emission
4. Easy to add monitoring/analytics by listening to events
