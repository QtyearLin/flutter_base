import 'package:dio/dio.dart';
import 'package:flutter_module/config/app_config.dart';
import 'package:flutter_module/utils/storage.dart';


class TokenInterceptors extends InterceptorsWrapper {
  String _token;

  @override
  onRequest(RequestOptions options) async {
    //授权码
    if (_token == null) {
      var authorizationCode = await getAuthorization();
      if (authorizationCode != null) {
        _token = authorizationCode;
      }
    }
    options.headers["Authorization"] = _token;
    return options;
  }

  @override
  onResponse(Response response) async {
    try {
      var responseJson = response.data;
      if (response.statusCode == 201 && responseJson["token"] != null) {
        _token = 'token ' + responseJson["token"];
         StorageUtil().setJSON(AppConfig.TOKEN_KEY, _token);
      }
    } catch (e) {
      print(e);
    }
    return response;
  }

  ///清除授权
  clearAuthorization() {
    this._token = null;
    StorageUtil().remove(AppConfig.TOKEN_KEY);
  }

  ///获取授权token
  getAuthorization()  {
    String token =  StorageUtil().getJSON(AppConfig.TOKEN_KEY);
    if (token!= null) {
      this._token = token;
      return token;
    }
    return token;
  }
}
