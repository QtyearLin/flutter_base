import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter_app/config/app_config.dart';
import 'package:logger/logger.dart';

class LogsInterceptors extends InterceptorsWrapper {
  static const String TAG = "LogsInterceptors  ";
  static List<Map> sHttpResponses = [];
  static List<String> sResponsesHttpUrl = [];

  static List<Map<String, dynamic>> sHttpRequest = [];
  static List<String> sRequestHttpUrl = [];

  static List<Map<String, dynamic>> sHttpError = [];
  static List<String> sHttpErrorUrl = [];
  var logger = Logger();

  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) {
    if (AppConfig.DEBUG) {
      logger.v(TAG + ",url：${options.path}");
      logger.v(TAG + '请求头: ' + options.headers.toString());
      if (options.data != null) {
        logger.v(TAG + '请求参数: ' + options.data.toString());
      }
    }
    try {
      addLogic(sRequestHttpUrl, options.path);
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
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (AppConfig.DEBUG) {
      if (response != null) {
        logger.v(TAG + '返回参数: ' + response.toString());
      }
    }
    if (response.data is Map || response.data is List) {
      try {
        var data = Map<String, dynamic>();
        data["data"] = response.data;
        addLogic(sResponsesHttpUrl, response.requestOptions.uri);
        addLogic(sHttpResponses, data);
      } catch (e) {
        print(e);
      }
    } else if (response.data is String) {
      try {
        var data = Map<String, dynamic>();
        data["data"] = response.data;
        addLogic(sResponsesHttpUrl, response.requestOptions.uri);
        addLogic(sHttpResponses, data);
      } catch (e) {
        print(e);
      }
    } else if (response.data != null) {
      try {
        String data = response.data.toJson();
        addLogic(sResponsesHttpUrl, response.requestOptions.uri);
        addLogic(sHttpResponses, json.decode(data));
      } catch (e) {
        print(e);
      }
    }
  }

  @override
  onError(
    DioError err,
    ErrorInterceptorHandler handler,
  ) async {
    if (AppConfig.DEBUG) {
      String? c = "f";
      logger.v(TAG + '请求异常: ' + err.toString());
      logger.v(TAG + '请求异常信息: ' + err.response.toString());
    }
    try {
      addLogic(sHttpErrorUrl, err.requestOptions.path);
      var errors = Map<String, dynamic>();
      errors["error"] = err.message;
      addLogic(sHttpError, errors);
    } catch (e) {
      print(e);
    }
  }

  static addLogic(List list, data) {
    if (list.length > 100) {
      list.removeAt(0);
    }
    list.add(data);
  }
}
