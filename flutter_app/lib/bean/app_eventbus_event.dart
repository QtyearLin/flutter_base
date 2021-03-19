//app event bus  flutter page 通信
class AppEventBusEvent {
  String key = "default";
  var value;

  AppEventBusEvent(this.key, this.value);
}

class EventKey {
  static const String udpate_live_status = "udpate_live_status";
  static const String notify_course_draw_open_or_close = "notify_course_draw_open_or_close";
  static const String notify_index_course_refreshpage = "notify_index_course_refreshpage";
}
