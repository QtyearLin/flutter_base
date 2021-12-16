
class UserBean {
  late int id;
  late String phone;
  late String realName;
  late String nickname;
  late String icon;
  late String createTime;
  late String token;
  late String roleName; //角色
  late String depName; //角色
  late String name;
  late int role; //dingyi  0 xues 1 teacher

  static UserBean? fromMap(Map<dynamic, dynamic> map) {
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
