import 'dart:convert';
import 'package:common_utils/common_utils.dart';
import 'package:dio/dio.dart';
import 'package:flutter_module/config/app_config.dart';

class LogsInterceptors extends InterceptorsWrapper {
  static const String TAG = "LogsInterceptors  ";
  static List<Map> sHttpResponses = new List<Map>();
  static List<String> sResponsesHttpUrl = new List<String>();

  static List<Map<String, dynamic>> sHttpRequest =
      new List<Map<String, dynamic>>();
  static List<String> sRequestHttpUrl = new List<String>();

  static List<Map<String, dynamic>> sHttpError =
      new List<Map<String, dynamic>>();
  static List<String> sHttpErrorUrl = new List<String>();

  @override
  onRequest(RequestOptions options) async {
    if (AppConfig.DEBUG) {
      LogUtil.v(TAG + ",url：${options.path}");
      LogUtil.v(TAG + '请求头: ' + options.headers.toString());
      if (options.data != null) {
        LogUtil.v(TAG + '请求参数: ' + options.data.toString());
      }
    }
    try {
      addLogic(sRequestHttpUrl, options.path ?? "");
      var data;
      if (options.data is Map) {
        data = options.data;
      } else {
        data = Map<String, dynamic>();
      }
      var map = {
        "header:": {...options.headers},
      };
      if (options.method == "POST") {
        map["data"] = data;
      }
      addLogic(sHttpRequest, map);
    } catch (e) {
      print(e);
    }
    return options;
  }

  @override
  onResponse(Response response) async {
    if (AppConfig.DEBUG) {
      if (response != null) {
        LogUtil.v(TAG + '返回参数: ' + response.toString());
      }
    }
    if (response.data is Map || response.data is List) {
      try {
        var data = Map<String, dynamic>();
        data["data"] = response.data;
        addLogic(sResponsesHttpUrl, response?.request?.uri?.toString() ?? "");
        addLogic(sHttpResponses, data);
      } catch (e) {
        print(e);
      }
    } else if (response.data is String) {
      try {
        var data = Map<String, dynamic>();
        data["data"] = response.data;
        addLogic(sResponsesHttpUrl, response?.request?.uri.toString() ?? "");
        addLogic(sHttpResponses, data);
      } catch (e) {
        print(e);
      }
    } else if (response.data != null) {
      try {
        String data = response.data.toJson();
        addLogic(sResponsesHttpUrl, response?.request?.uri.toString() ?? "");
        addLogic(sHttpResponses, json.decode(data));
      } catch (e) {
        print(e);
      }
    }
    return response; // continue
  }

  @override
  onError(DioError err) async {
    if (AppConfig.DEBUG) {
      LogUtil.v(TAG + '请求异常: ' + err.toString());
      LogUtil.v(TAG + '请求异常信息: ' + (err.response?.toString() ?? ""));
    }
    try {
      addLogic(sHttpErrorUrl, err.request.path ?? "null");
      var errors = Map<String, dynamic>();
      errors["error"] = err.message;
      addLogic(sHttpError, errors);
    } catch (e) {
      print(e);
    }
    return err; // continue;
  }

  static addLogic(List list, data) {
    if (list.length > 100) {
      list.removeAt(0);
    }
    list.add(data);
  }
}
