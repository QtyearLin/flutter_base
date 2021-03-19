import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';

/// 本地存储
class StorageUtil {


  static StorageUtil _instance = new StorageUtil._();

  factory StorageUtil() => _instance;
  static SharedPreferences _prefs;

  StorageUtil._();

  static Future<void> init() async {
    if (_prefs == null) {
      _prefs = await SharedPreferences.getInstance();
    }
  }

  Future<bool> setJSON(String key, dynamic jsonVal) {
    String jsonString = jsonEncode(jsonVal);
    return _prefs.setString(key, jsonString);
  }

  Future<bool> setString(String key, dynamic val) {
    return _prefs.setString(key, val);
  }

  String getString(String key) {
    return _prefs.getString(key);
  }

  dynamic getJSON(String key) {
    String jsonString = _prefs.getString(key);
    return jsonString == null ? null : jsonDecode(jsonString);
  }

  Future<bool> setBool(String key, bool val) {
    print("setBool :key:"+ key + "value:"+ val.toString() );
    return _prefs.setBool(key, val);
  }

  bool getBool(String key) {
    bool val = _prefs.getBool(key);
    return val == null ? false : val;
  }

  bool getBoolDefault(String key,bool value) {
    if(_prefs==null) {
      print("getBoolDefault: _prefs is null");
      return value;
    }
    bool val = _prefs.getBool(key);
    print("key:"+ key + "value:"+ val.toString() );
    return val == null ? value : val;
  }

  Future<bool> remove(String key) {
    return _prefs.remove(key);
  }

  /// get obj.
   T getObj<T>(String key, T f(Map v), {T defValue}) {
    Map map = getObject(key);
    return map == null ? defValue : f(map);
  }

  /// get object.
   Map getObject(String key) {
    if (_prefs == null) return null;
    String _data = _prefs.getString(key);
    return (_data == null || _data.isEmpty) ? null : json.decode(_data);
  }

  /// put object list.
   Future<bool> putObjectList(String key, List<Object> list) {
    if (_prefs == null) return null;
    List<String> _dataList = list?.map((value) {
      return json.encode(value);
    })?.toList();
    return _prefs.setStringList(key, _dataList);
  }

  /// get obj list.
   List<T> getObjList<T>(String key, T f(Map v),
      {List<T> defValue = const []}) {
    List<Map> dataList = getObjectList(key);
    List<T> list = dataList?.map((value) {
      return f(value);
    })?.toList();
    return list ?? defValue;
  }

  /// get object list.
   List<Map> getObjectList(String key) {
    if (_prefs == null) return null;
    List<String> dataLis = _prefs.getStringList(key);
    return dataLis?.map((value) {
      Map _dataMap = json.decode(value);
      return _dataMap;
    })?.toList();
  }


  // static Future<SharedPreferences> getInstance() {
  //   return SharedPreferences.getInstance();
  // }
  //
  // static Future<bool> setString(String key, dynamic val) async {
  //   return await getInstance().then((value) {
  //     return value.setString(key, val);
  //   });
  // }

}
