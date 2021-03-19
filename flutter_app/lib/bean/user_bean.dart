import 'package:common_utils/common_utils.dart';
import 'package:flutter/cupertino.dart' as prefix0;


class UserBean {
  int id;
  String phone;
  String realName;
  String nickname;
  String icon;
  String createTime;
  String token;
  String roleName; //角色
  String depName; //角色
  String name;
  int role; //dingyi  0 xues 1 teacher

  static UserBean fromMap(Map<String, dynamic> map) {
    if (map == null) return null;
    UserBean userBeanBean = UserBean();
    userBeanBean.id = map['id'];
    userBeanBean.phone = map['phone'];
    userBeanBean.realName = map['real_name'];
    userBeanBean.nickname = map['nickname'];
    userBeanBean.icon = map['icon'];
    userBeanBean.createTime = map['create_time'];
    userBeanBean.token = map['token'];
    userBeanBean.roleName = map['role_name'];
    userBeanBean.depName = map['dep_name'];
    userBeanBean.name = map['name'];
    userBeanBean.role = map['role'];
    return userBeanBean;
  }

  Map toJson() => {
        "id": id,
        "phone": phone,
        "real_name": realName,
        "nickname": nickname,
        "icon": icon,
        "create_time": createTime,
        "token": token,
        "role_name": roleName,
        "dep_name": depName,
        "role": role,
      };

  bool isTeacher() {
    return role == 1;
  }

  @override
  String toString() {
    return 'UserBean{id: $id, phone: $phone, realName: $realName, nickname: $nickname, icon: $icon, createTime: $createTime, token: $token, roleName: $roleName, depName: $depName}';
  }

  static String showName(UserBean userBean) {
    if (null == userBean) return "";
    if (userBean.name == null) {
      return userBean.phone;
    } else if (userBean.name.isEmpty) {
      return userBean.phone;
    } else {
      return userBean.name;
    }
  }

  static String showId(UserBean userBean) {
    if (null == userBean) return "";
    return userBean.id.toString();
  }
}
