import 'package:event_bus/event_bus.dart';

class EventBusUtils {
  static late EventBus _instance;

  static EventBus getInstance() {
    if (null == _instance) {
      _instance = new EventBus();
      init();
    }
    return _instance;
  }

  static void init() {
    _instance
        .on()
        .listen((event) => print('event fired:  ${event.runtimeType}'));
  }
}
