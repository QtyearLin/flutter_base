import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/bean/app_eventbus_event.dart';
import 'package:flutter_app/bean/user_bean.dart';
import 'package:flutter_app/config/app_channel_methods.dart';
import 'package:flutter_app/localization/default_localizations.dart';
import 'package:flutter_app/pages/tabs/index_activity.dart';
import 'package:flutter_app/provider/user_provider.dart';
import 'package:flutter_app/route/route_util.dart';
import 'package:flutter_app/style/app_theme.dart';
import 'package:flutter_app/utils/bus_utils.dart';
import 'package:flutter_app/widget/base_will_pop_scope_route.dart';
import 'package:provider/provider.dart';

import 'home_drawer.dart';

class HomeIndex extends StatefulWidget {
  HomeIndex({Key? key}) : super(key: key);

  @override
  _HomeIndexState createState() => _HomeIndexState();
}

class _HomeIndexState extends State<HomeIndex>
    with SingleTickerProviderStateMixin {
  int _currentIndex = 0;
  var _title = null;
  late UserBean _userBean;
  late PageController _controller;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: _currentIndex, keepPage: true);
    _initPlatEvent();
  }

  List<Widget> _pageList = [
    IndexActivityPage(),
    IndexActivityPage(),
    IndexActivityPage(),
    IndexActivityPage(),
  ];

  late List<BottomNavigationBarItem> _bottomTabs;

  List<BottomNavigationBarItem> _createBottomTabs(BuildContext context) {
    if (null == _bottomTabs) {
      _bottomTabs = [
        BottomNavigationBarItem(
            icon: Icon(Icons.home),
            title: Text(AppLocalizations.i18n(context)!.index_tab_home)),
        BottomNavigationBarItem(
            icon: Icon(Icons.book),
            title: Text(AppLocalizations.i18n(context)!.index_tab_3)),
        BottomNavigationBarItem(
            icon: Icon(Icons.access_alarm_rounded),
            title: Text(AppLocalizations.i18n(context)!.index_tab_live)),
        BottomNavigationBarItem(
            icon: Icon(Icons.add_a_photo_sharp),
            title: Text(AppLocalizations.i18n(context)!.index_tab_4)),
      ];
    }
    return _bottomTabs;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _title = AppLocalizations.i18n(context)!.index_tab_home;
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }

  // var _course_drawer_key = new GlobalKey<ScaffoldState>(); //将Scaffold设置为全局变量
  @override
  Widget build(BuildContext context) {
    //init
    return BaseWillPopScopeRoute(
      child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: NetworkImage(
                  'https://img.zcool.cn/community/0372d195ac1cd55a8012062e3b16810.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Scaffold(
            backgroundColor: Colors.transparent,
            key: _scaffoldKey,
            appBar: AppBar(
              elevation: 0,
              leading: IconButton(
                icon: Icon(
                  Icons.menu,
                  color: ((_currentIndex != 4 && _currentIndex != 0)
                      ? Colors.black
                      : Colors.white),
                ),
                onPressed: () {
                  _handleDrawer(context);
                },
                tooltip: MaterialLocalizations.of(context).openAppDrawerTooltip,
              ),
              backgroundColor: (_currentIndex != 4 && _currentIndex != 0)
                  ? Colors.white
                  : Colors.transparent,
              title: Text(
                _title,
                style: TextStyle(
                  color: (_currentIndex != 4 && _currentIndex != 0)
                      ? Colors.black
                      : Colors.white,
                ),
              ),
              centerTitle: false,
              actions: _build_actions(),
            ),
            body: PageView(
              scrollDirection: Axis.horizontal,
              controller: _controller,
              children: this._pageList,
              physics: NeverScrollableScrollPhysics(),
            ),
            drawer: AppHomeDrawer(
              callBackIndex: (DrawerIndex indexType) {
                Navigator.pop(context);
                switch (indexType) {
                  case DrawerIndex.HOME:
                    // TODO: Handle this case.
                    break;
                  case DrawerIndex.FeedBack:
                    // TODO: Handle this case.
                    break;
                  case DrawerIndex.Help:
                    // TODO: Handle this case.
                    break;
                  case DrawerIndex.Share:
                    // TODO: Handle this case.
                    break;
                  case DrawerIndex.About:
                    // TODO: Handle this case.
                    break;
                  case DrawerIndex.Invite:
                    // TODO: Handle this case.
                    break;
                  case DrawerIndex.Testing:
                    // TODO: Handle this case.
                    break;
                }
              },
            ),
            bottomNavigationBar: BottomNavigationBar(
              currentIndex: this._currentIndex,
              selectedItemColor: AppColors.selected,
              //配置对应的索引值选中
              onTap: (index) {
                // if (index != 2) return;
                // _controller.animateToPage(index,
                //     curve: Curves.easeIn, duration: Duration(milliseconds: 200));'
                _controller.jumpToPage(index);
                setState(() {
                  _currentIndex = index;
                  Text text = _bottomTabs[index].title as Text;
                  _title = text.data;
                });
              },
              // iconSize: 24.0,
              //icon的大小
              //选中的颜色
              type: BottomNavigationBarType.fixed,
              //配置底部tabs可以有多个按钮
              items: _createBottomTabs(context),
            ),
          )),
    );
  }

  // @override
  // // TODO: implement wantKeepAlive
  // bool get wantKeepAlive => true;

  void _drawCallback(bool isOpened) {}

  void _initPlatEvent() {
    RouteUtils.methodPlatForm.setMethodCallHandler(_platformCallHandler);
    RouteUtils.eventPlatForm.receiveBroadcastStream().listen(
        _onEventListenerPlatForm,
        onError: _onError,
        onDone: null,
        cancelOnError: null);

    _userBean = Provider.of<UserProvider>(context, listen: false).get()!;
    //call native init IM socket
    RouteUtils.jumpToNativeWithValue(ChannelMethodConstants.initIMSocket, map: {
      "user_id": _userBean.id.toString(),
    });
  }

  // called by natvie
  Future<dynamic> _platformCallHandler(MethodCall call) async {
    switch (call.method) {
      case "getFlutterName":
        return "Flutter name flutter";
        break;
      case ChannelMethodConstants.nUpdateLiveStatus:
        EventBusUtils.getInstance().fire(
            new AppEventBusEvent(EventKey.udpate_live_status, call.arguments));
        break;
    }
  }

  Future _onEventListenerPlatForm(dynamic event) async {
    setState(() {});
    var result =
        await RouteUtils.methodPlatForm.invokeMethod('echoEvent', event);
    print("__onEventListenerPlatForm:callback:" + result);
  }

  void _onError(Object error) {
    setState(() {});
  }

  void _handleDrawer(BuildContext context) {
    // Scaffold.of(context).openDrawer();
    if (_scaffoldKey.currentState != null &&
        _scaffoldKey.currentState!.isDrawerOpen) {
      Navigator.pop(context);
    } else {
      _scaffoldKey.currentState!.openDrawer();
    }
  }

  _build_actions() {
    if (_currentIndex == 0) {
      return [
        IconButton(icon: Icon(Icons.search), onPressed: () {}),
        GestureDetector(
          onTap: () {},
          child: Row(
            children: <Widget>[
              Text(
                "A",
                style: TextStyle(color: Colors.white),
              ),
            ],
          ),
        ),
      ];
    } else if (_currentIndex == 1) {
      return [
        IconButton(
            icon: Icon(
              Icons.filter_alt,
              color: Colors.black,
            ),
            onPressed: () {}),
      ];
    } else if (_currentIndex == 4) {
      return [
        IconButton(icon: Icon(Icons.add), onPressed: () {}),
      ];
    } else {
      return null;
    }
  }
}
