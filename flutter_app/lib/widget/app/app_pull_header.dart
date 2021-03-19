import 'package:flutter_easyrefresh/easy_refresh.dart';

class AppPullHeader extends ClassicalHeader {
  AppPullHeader(
      {String refreshText = "下拉刷新",
      String refreshFailedText = "刷新失败",
      String refreshReadyText = "释放刷新",
      String refreshingText = "正在刷新",
      String refreshedText = "刷新完成"})
      : super(
            refreshText: refreshedText,
            refreshFailedText: refreshFailedText,
            refreshReadyText: refreshReadyText,
            refreshingText: refreshingText,
            refreshedText: refreshedText) {}
}
