import 'dart:async';
import 'app_events.dart';

typedef EventListener<T extends AppEvent> = FutureOr<void> Function(T event);

/// Strongly typed, broadcast-safe event bus.
/// Not a static singleton - instantiated per context via dependency injection.
/// Allows modules to emit and listen to domain events.
class EventBus {
  final Map<Type, List<Function>> _listeners = {};

  /// Register a listener for a specific event type.
  /// Returns an unsubscribe function for cleanup.
  void Function() on<T extends AppEvent>(EventListener<T> callback) {
    _listeners.putIfAbsent(T, () => []).add(callback);

    // Return unsubscribe function
    return () => off<T>(callback);
  }

  /// Unregister a listener.
  void off<T extends AppEvent>([EventListener<T>? callback]) {
    if (callback == null) {
      _listeners.remove(T);
    } else {
      _listeners[T]?.removeWhere((listener) => listener == callback);
    }
  }

  /// Emit an event to all subscribers.
  /// Safe for broadcast - listeners can emit other events.
  Future<void> emit<T extends AppEvent>(T event) async {
    final listeners = _listeners[T];
    if (listeners == null || listeners.isEmpty) return;

    // Create a copy to allow listeners to modify the list during iteration
    for (var listener in List<Function>.from(listeners)) {
      try {
        (listener as EventListener<T>)(event);
      } catch (e) {
        // Log error but don't stop other listeners
        print('EventBus: Error in listener for ${T.toString()}: $e');
      }
    }
  }

  /// Emit and await all listeners asynchronously.
  Future<void> emitAsync<T extends AppEvent>(T event) async {
    final listeners = _listeners[T];
    if (listeners == null || listeners.isEmpty) return;

    await Future.wait(
      List<Function>.from(listeners).map<Future<void>>((listener) async {
        try {
          await (listener as EventListener<T>)(event);
        } catch (e) {
          print('EventBus: Error in async listener for ${T.toString()}: $e');
        }
      }),
    );
  }

  /// Clear all listeners (useful for testing).
  void clearAllListeners() {
    _listeners.clear();
  }

  /// Get count of listeners for a specific event type (for testing).
  int getListenerCount<T extends AppEvent>() {
    return _listeners[T]?.length ?? 0;
  }
}
