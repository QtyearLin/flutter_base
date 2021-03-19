class BaseResponse {
  int code;
  String msg;
  dynamic data;

  static BaseResponse fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    BaseResponse childrenBean = BaseResponse();
    childrenBean.code = map['code'];
    childrenBean.msg = map['msg'];
    childrenBean.data = map['data'];
    return childrenBean;
  }

  Map<String, dynamic> toJson() => {
        "data": data,
        "code": code,
        "msg": msg,
      };
}
