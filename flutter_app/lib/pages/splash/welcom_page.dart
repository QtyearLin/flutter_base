import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/config/app_keys.dart';
import 'package:flutter_app/localization/default_localizations.dart';
import 'package:flutter_app/pages/home_index.dart';
import 'package:flutter_app/route/route_util.dart';
import 'package:flutter_app/style/app_theme.dart';
import 'package:flutter_app/utils/storage.dart';
import 'package:flutter_app/widget/image.dart';
import 'package:flutter_swiper_null_safety/flutter_swiper_null_safety.dart';

class WelcomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return WelcomPageState();
  }
}

class WelcomPageState extends State<WelcomPage> {

  final List _guideList = [
    ImageUtils.getImgPath('guide1'),
    ImageUtils.getImgPath('guide2'),
    ImageUtils.getImgPath('guide3'),
    ImageUtils.getImgPath('guide4'),
  ];

  final List<Widget> _bannerList = [];

  int _status = 2; //关闭splash
  bool showJoin = false;
  int _count = 3;

  @override
  void initState() {
    super.initState();

    _initBannerData();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    DateTime time = DateTime.now();
    print("didChangeDependencies:time:" + time.toIso8601String());
  }

  void _initBannerData() {
    for (int i = 0, length = _guideList.length; i < length; i++) {
      _bannerList.add(Image.asset(
        _guideList[i],
        fit: BoxFit.fill,
        width: double.infinity,
        height: double.infinity,
      ));
    }
  }

  void _goLogin() {
    StorageUtil().setBool(AppDataKeys.is_first_key_guide, false);
    RouteUtils.goLogin(context);
  }

  Widget _buildCorver() {
    return Stack(
      children: <Widget>[
         Positioned(
            right: 16,
            top: 50,
            child:  InkWell(
              onTap: _goLogin,
              child:  Text(
                AppLocalizations.i18n(context)!.jump,
                textAlign: TextAlign.end,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                ),
              ),
            )),
         Positioned(
            right: 16,
            bottom: 10,
            child:  Offstage(
              offstage: !showJoin,
              child:  RaisedButton(
                onPressed: () {
                  _goLogin();
                },
                padding: const EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
                color: AppColors.primaryValue,
                shape: const StadiumBorder(),
                child:  Text(
                  AppLocalizations.i18n(context)!.jump_now,
                  style: const TextStyle(color: Colors.white, fontSize: 10.0),
                ),
              ),
            ))
      ],
    );
  }

  void _onIndexChanged(int index) {
    setState(() {
      showJoin = (index == _bannerList.length - 1);
    });
  }

  @override
  Widget build(BuildContext context) {
    DateTime time =  DateTime.now();
    print("build:time:" + time.toIso8601String());

    return  Scaffold(
      body: Stack(
        children: <Widget>[
          _buildSwiper(),
          _buildCorver(),
        ],
      ),
    );
  }

  Widget _buildSwiper() {
    return  Swiper(
      loop: false,
      pagination:  const SwiperPagination(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.all(20),
          builder: DotSwiperPaginationBuilder(
            size: 5,
            space: 3,
          )),
      // control: null,
      onIndexChanged: _onIndexChanged,
      itemBuilder: (BuildContext context, int index) {
        return _bannerList[index];
      },
      itemCount: _bannerList.length,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
