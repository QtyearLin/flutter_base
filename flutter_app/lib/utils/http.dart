import 'dart:async';
import 'dart:convert';
import 'dart:core';

import 'package:cookie_jar/cookie_jar.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/apis/app_apis.dart';
import 'package:flutter_app/bean/base_response.dart';
import 'package:flutter_app/config/app_config.dart';

import 'interceptors/header.dart';
import 'interceptors/log.dart';
import 'interceptors/token.dart';

class HttpUtil {
  static HttpUtil _instance = HttpUtil._internal();

  factory HttpUtil() => _instance;

  late Dio dio;

  // CancelToken cancelToken = new CancelToken();

  HttpUtil._internal() {
    // BaseOptions、Options、RequestOptions 都可以配置参数，优先级别依次递增，且可以根据优先级别覆盖参数
    BaseOptions options = new BaseOptions(
      // 请求基地址,可以包含子路径
      // baseUrl: SERVER_API_URL,
      //连接服务器超时时间，单位是毫秒.
      connectTimeout: AppConfig.CONNEC_TOUT,
      // 响应流上前后两次接受到数据的间隔，单位为毫秒。
      receiveTimeout: AppConfig.RECEIVE_TOUT,

      contentType: 'application/x-www-form-urlencoded; charset=utf-8',
      //ajax:contentType: "application/x-www-form-urlencoded")//multipart/form-data//application/json
      responseType: ResponseType.json,
    );

    dio = new Dio(options);
    final TokenInterceptors _tokenInterceptors = new TokenInterceptors();
    // Cookie管理
    CookieJar cookieJar = CookieJar();
    // 添加拦截器
    // dio.interceptors.add(CookieManager(cookieJar));
    dio.interceptors.add(new HeaderInterceptors());
    dio.interceptors.add(_tokenInterceptors);
    dio.interceptors.add(new LogsInterceptors());
    // dio.interceptors.add(new ErrorInterceptors(dio));
    // dio.interceptors.add(new NetCacheInterceptor());
    // 加内存缓存
  }

  /*
   * 取消请求
   *
   * 同一个cancel token 可以用于多个请求，当一个cancel token取消时，所有使用该cancel token的请求都会被取消。
   * 所以参数可选
   */
  void cancelRequests(CancelToken token) {
    token.cancel("cancelled");
  }

  Future<BaseResponse> getAsync(String url,
      {Map<String, dynamic>? data,
      required Map<String, dynamic> headers}) async {
    // 数据拼接
    if (data != null && data.isNotEmpty) {
      StringBuffer options = new StringBuffer('?');
      data.forEach((key, value) {
        options.write('${key}=${value}&');
      });
      String optionsStr = options.toString();
      optionsStr = optionsStr.substring(0, optionsStr.length - 1);
      url += optionsStr;
    }

    // 发送get请求
    return _sendRequestAsync(url, 'get', headers: headers);
  }

  void get(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      Function? success,
      Function? error}) async {
    // 数据拼接
    if (data != null && data.isNotEmpty) {
      StringBuffer options = new StringBuffer('?');
      data.forEach((key, value) {
        options.write('${key}=${value}&');
      });
      String optionsStr = options.toString();
      optionsStr = optionsStr.substring(0, optionsStr.length - 1);
      url += optionsStr;
    }

    // 发送get请求
    _sendRequest(url, 'get', success!, headers: headers, error: error);
  }

  void post(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      Function? success,
      Function? error}) async {
    // 发送post请求
    _sendRequest(url, 'post', success,
        data: data, headers: headers, error: error);
  }

  void postJson(String url,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      Function? success,
      Function? error}) async {
    // 发送post请求
    _sendRequest(url, 'post', success,
        data: data,
        headers: headers,
        error: error,
        options: Options(contentType: "application/json"));
  }

  // 请求处理
  Future<BaseResponse> _sendRequestAsync(String url, String method,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      Options? options}) async {
    int _code;
    String _msg;
    var _backData;

    // 检测请求地址是否是完整地址
    if (!url.startsWith('http')) {
      url = SERVER_API_URL + url;
    }

    Map<String, dynamic> dataMap = data == null ? new Map() : data;
    Map<String, dynamic> headersMap = headers == null ? new Map() : headers;

    // 配置dio请求信息
    dio.options.headers.addAll(headersMap); // 添加headers,如需设置统一的headers信息也可在此添加

    BaseResponse baseResponse = new BaseResponse();
    if (method == 'get') {
      return dio.get(url).then((response) {
        if (response.statusCode != 200) {
          _msg = '网络请求错误,状态码:' + response.statusCode.toString();
          baseResponse.code = response.statusCode!;
          baseResponse.msg = response.statusMessage!;
          baseResponse.data = response.data;
          return baseResponse;
        } else {
          Map<String, dynamic> resCallbackMap;
          if (response.data is String) {
            print("response is string:");
            resCallbackMap = jsonDecode(response.data);
          } else {
            print("response is not  string:");
            resCallbackMap = response.data;
          }
          _code = resCallbackMap['status'];
          _msg = resCallbackMap['message'];

          baseResponse.code = _code;
          baseResponse.msg = _msg;
          baseResponse.data = resCallbackMap['data'];
          return baseResponse;
        }
      });
    } else {
      return dio.post(url, data: dataMap, options: options).then((response) {
        if (response.statusCode != 200) {
          _msg = '网络请求错误,状态码:' + response.statusCode.toString();
          baseResponse.code = response.statusCode!;
          baseResponse.msg = response.statusMessage!;
          baseResponse.data = response.data;
          return baseResponse;
        } else {
          Map<String, dynamic> resCallbackMap;
          if (response.data is String) {
            print("response is string:");
            resCallbackMap = jsonDecode(response.data);
          } else {
            print("response is not  string:");
            resCallbackMap = response.data;
          }
          _code = resCallbackMap['status'];
          _msg = resCallbackMap['message'];

          baseResponse.code = _code;
          baseResponse.msg = _msg;
          baseResponse.data = resCallbackMap['data'];
          return baseResponse;
        }
      });
    }
  }

  // 请求处理
  void _sendRequest(String url, String method, Function? success,
      {Map<String, dynamic>? data,
      Map<String, dynamic>? headers,
      Options? options,
      Function? error}) async {
    int _code;
    String _msg;

    var _backData;
    // 检测请求地址是否是完整地址
    if (!url.startsWith('http')) {
      url = SERVER_API_URL + url;
    }

    try {
      Map<String, dynamic> dataMap = data == null ? new Map() : data;
      Map<String, dynamic> headersMap = headers == null ? new Map() : headers;

      // 配置dio请求信息
      Response response;
      dio.options.headers
          .addAll(headersMap); // 添加headers,如需设置统一的headers信息也可在此添加

      if (method == 'get') {
        response = await dio.get(url);
      } else {
        response = await dio.post(url, data: dataMap, options: options);
      }

      if (response.statusCode != 200) {
        _msg = '网络请求错误,状态码:' + response.statusCode.toString();
        _handError(error, response.statusCode, _msg);
        return;
      }
      Map<String, dynamic> resCallbackMap;
      // 返回结果处理
      if (response.data is String) {
        print("response is string:");
        resCallbackMap = jsonDecode(response.data);
      } else {
        print("response is not  string:");
        resCallbackMap = response.data;
      }
      _code = resCallbackMap['status'];
      _msg = resCallbackMap['message'];

      if (resCallbackMap.containsKey("data")) {
        _backData = resCallbackMap['data'];
      }
      if (success != null) {
        if (_code == 1) {
          print("success:" + _backData.toString());
          success(_backData);
        } else {
          // String errorMsg = _code.toString() + ':' + _msg;
          _handError(error, _code, _msg);
        }
      }
    } catch (exception) {
      print("_handError:" + exception.toString());
      _handError(error, -1, '数据请求错误：' + exception.toString());
    }
  }

  // 返回错误信息
  void _handError(Function? errorCallback, int? code, String errorMsg) {
    if (errorCallback != null) {
      errorCallback(code, errorMsg);
    }
  }
}
