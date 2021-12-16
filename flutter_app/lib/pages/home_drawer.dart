import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_app/localization/default_localizations.dart';
import 'package:flutter_app/provider/user_provider.dart';
import 'package:flutter_app/style/app_theme.dart';
import 'package:provider/provider.dart';

class AppHomeDrawer extends StatefulWidget {
  const AppHomeDrawer({Key? key, required this.callBackIndex})
      : super(key: key);

  final Function(DrawerIndex) callBackIndex;

  @override
  _AppHomeDrawerState createState() => _AppHomeDrawerState();
}

class _AppHomeDrawerState extends State<AppHomeDrawer> {
  late List<DrawerList> drawerList;

  late DrawerList lastedSelectedDrawList;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    setDrawerListArray(context);
  }

  void setDrawerListArray(BuildContext context) {
    drawerList = <DrawerList>[
      DrawerList(
        isSelected: true,
        index: DrawerIndex.HOME,
        labelName: AppLocalizations.i18n(context)!.draw_course,
        icon: Icon(Icons.home),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: AppLocalizations.i18n(context)!.draw_activity,
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.FeedBack,
        labelName: AppLocalizations.i18n(context)!.draw_favor,
        icon: Icon(Icons.feedback),
      ),
      DrawerList(
        index: DrawerIndex.Help,
        labelName: AppLocalizations.i18n(context)!.draw_help,
        icon: Icon(Icons.help),
      ),
      DrawerList(
        index: DrawerIndex.Share,
        labelName: AppLocalizations.i18n(context)!.share,
        icon: Icon(Icons.share),
      ),
      DrawerList(
        index: DrawerIndex.About,
        labelName: AppLocalizations.i18n(context)!.about,
        icon: Icon(Icons.info),
      ),
    ];
    lastedSelectedDrawList = drawerList[0];
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: double.infinity,
            padding: const EdgeInsets.only(top: 50.0),
            child: Container(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Container(
                    height: 120,
                    width: 120,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                            color: AppColors.grey.withOpacity(0.6),
                            offset: const Offset(2.0, 4.0),
                            blurRadius: 8),
                      ],
                    ),
                    child: ClipRRect(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(60.0)),
                      child: Image.asset(AppICons.DEFAULT_USER_DEFAULT_HEAD),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10, left: 4),
                    child: Text(
                      Provider.of<UserProvider>(context, listen: false)
                          .get()!
                          .phone,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.grey,
                        fontSize: 18,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          // Divider(
          //   height: 1,
          // ),
          Expanded(
            child: Container(
                alignment: Alignment.center,
                child: ListView.builder(
                  physics: const BouncingScrollPhysics(),
                  padding: const EdgeInsets.only(right: 6.0),
                  itemCount: drawerList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return inkwell(drawerList[index]);
                  },
                )),
          ),
          Divider(
            height: 1,
            color: AppColors.grey.withOpacity(0.6),
          ),
          Column(
            children: <Widget>[
              ListTile(
                title: Text(
                  AppLocalizations.i18n(context)!.Login_out,
                  style: TextStyle(
                    fontFamily: AppConstant.fontName,
                    fontWeight: FontWeight.w600,
                    fontSize: 16,
                    color: AppColors.darkText,
                  ),
                  textAlign: TextAlign.left,
                ),
                trailing: Icon(
                  Icons.power_settings_new,
                  color: Colors.red,
                ),
                onTap: () {
                  _quit(context);
                },
              ),
              SizedBox(
                height: MediaQuery.of(context).padding.bottom,
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget inkwell(DrawerList listData) {
    return InkWell(
      splashColor: Colors.grey.withOpacity(0.1),
      highlightColor: Colors.transparent,
      onTap: () {
        navigationtoScreen(listData, listData.index);
      },
      child: Stack(
        children: <Widget>[
          Container(
            padding: const EdgeInsets.only(top: 8.0, bottom: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Container(
                  width: 6.0,
                  height: 40.0,
                ),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                ),
                listData.isAssetsImage
                    ? Container(
                        width: 24,
                        height: 24,
                        child: Image.asset(listData.imageName,
                            color: listData.isSelected!
                                ? AppColors.primaryValue
                                : AppColors.nearlyBlack),
                      )
                    : Icon(listData.icon!.icon,
                        color: listData.isSelected!
                            ? AppColors.primaryValue
                            : AppColors.nearlyBlack),
                const Padding(
                  padding: EdgeInsets.all(4.0),
                ),
                Text(
                  listData.labelName,
                  style: TextStyle(
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                    color: listData.isSelected!
                        ? AppColors.primaryValue
                        : AppColors.nearlyBlack,
                  ),
                  textAlign: TextAlign.left,
                ),
              ],
            ),
          ),
          _renderItemCover(listData),
        ],
      ),
    );
  }

  Future<void> navigationtoScreen(
      DrawerList drawerList, DrawerIndex? index) async {
    if (lastedSelectedDrawList != null) {
      if (drawerList != lastedSelectedDrawList) {
        setState(() {
          print("selected is :$drawerList");
          lastedSelectedDrawList.isSelected = false;
          drawerList.isSelected = true;
          lastedSelectedDrawList = drawerList;
        });
      }
    } else {
      setState(() {
        print("selected is :$drawerList");
        drawerList.isSelected = true;
        lastedSelectedDrawList = drawerList;
      });
    }
    widget.callBackIndex(index!);
  }

  _renderItemCover(DrawerList listData) {
    print("_renderItemCover:" + listData.isSelected.toString());
    return listData.isSelected!
        ? Padding(
            padding: EdgeInsets.only(top: 8, bottom: 8),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.5,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.primaryValue.withOpacity(0.2),
                borderRadius: new BorderRadius.only(
                  topLeft: Radius.circular(0),
                  topRight: Radius.circular(28),
                  bottomLeft: Radius.circular(0),
                  bottomRight: Radius.circular(28),
                ),
              ),
            ),
          )
        : const SizedBox();
  }
}

Future<bool?> _quit(BuildContext context) {
  return showDialog<bool>(
    context: context,
    builder: (context) {
      return AlertDialog(
        title: Text("提示"),
        content: Text("您确定要退出么?"),
        actions: <Widget>[
          FlatButton(
            child: Text("取消"),
            onPressed: () => Navigator.of(context).pop(), // 关闭对话框
          ),
          FlatButton(
            child: Text("退出"),
            onPressed: () {
              //关闭对话框并返回true
              Navigator.of(context).pop(true);
              // CommonUtils.pop();
              exit(0);
            },
          ),
        ],
      );
    },
  );
}

enum DrawerIndex {
  HOME,
  FeedBack,
  Help,
  Share,
  About,
  Invite,
  Testing,
}

class DrawerList {
  DrawerList({
    this.isAssetsImage = false,
    this.labelName = '',
    this.icon,
    this.index,
    this.isSelected = false,
    this.imageName = '',
  });

  var labelName;
  Icon? icon;
  bool? isSelected;
  bool isAssetsImage;
  var imageName;
  DrawerIndex? index;
}
