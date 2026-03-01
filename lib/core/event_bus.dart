typedef EventCallback = void Function(dynamic payload);

class EventBus {
  EventBus._internal();
  static final EventBus _instance = EventBus._internal();
  factory EventBus() => _instance;

  final Map<String, List<EventCallback>> _listeners = {};

  void on(String eventName, EventCallback callback) {
    _listeners.putIfAbsent(eventName, () => []).add(callback);
  }

  void off(String eventName, [EventCallback? callback]) {
    if (callback == null) {
      _listeners.remove(eventName);
    } else {
      _listeners[eventName]?.remove(callback);
    }
  }

  void emit(String eventName, [dynamic payload]) {
    final listeners = _listeners[eventName];
    if (listeners == null) return;
    for (var listener in List<EventCallback>.from(listeners)) {
      listener(payload);
    }
  }
}
