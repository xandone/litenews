import 'package:event_bus/event_bus.dart';

class EventBusUtils {
  static EventBus? _instance;

  static EventBus getDefault() {
    _instance ??= EventBus();
    return _instance!;
  }
}
