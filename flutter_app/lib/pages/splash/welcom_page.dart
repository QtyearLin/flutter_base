import 'package:cached_network_image/cached_network_image.dart';
import 'package:common_utils/common_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_module/config/app_keys.dart';
import 'package:flutter_module/localization/default_localizations.dart';
import 'package:flutter_module/pages/home_index.dart';
import 'package:flutter_module/route/route_util.dart';
import 'package:flutter_module/style/app_theme.dart';
import 'package:flutter_module/utils/storage.dart';
import 'package:flutter_module/widget/image.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';

class WelcomPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new WelcomPageState();
  }
}

class WelcomPageState extends State<WelcomPage> {
  TimerUtil _timerUtil;

  List _guideList = [
    ImageUtils.getImgPath('guide1'),
    ImageUtils.getImgPath('guide2'),
    ImageUtils.getImgPath('guide3'),
    ImageUtils.getImgPath('guide4'),
  ];

  List<Widget> _bannerList = new List();

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
    DateTime time = new DateTime.now();
    print("didChangeDependencies:time:" + time.toIso8601String());

  }

  void _initBannerData() {
    for (int i = 0, length = _guideList.length; i < length; i++) {
      _bannerList.add(new Image.asset(
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
    return new Stack(
      children: <Widget>[
        new Positioned(
            right: 16,
            top: 50,
            child: new InkWell(
              onTap: _goLogin,
              child: new Text(
                AppLocalizations.i18n(context).jump,
                textAlign: TextAlign.end,
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 10.0,
                ),
              ),
            )),
        new Positioned(
            right: 16,
            bottom: 10,
            child: new Offstage(
              offstage: !showJoin,
              child: new RaisedButton(
                onPressed: () {
                  _goLogin();
                },
                padding: EdgeInsets.only(left: 5, top: 0, right: 5, bottom: 0),
                color: AppColors.primaryValue,
                shape: StadiumBorder(),
                child: new Text(
                  AppLocalizations.i18n(context).jump_now,
                  style: TextStyle(color: Colors.white, fontSize: 10.0),
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
    DateTime time = new DateTime.now();
    print("build:time:" + time.toIso8601String());

    return new Stack(
      children: <Widget>[
        _buildSwiper(),
        _buildCorver(),
      ],
    );
  }

  @override
  void dispose() {
    super.dispose();
    if (_timerUtil != null) _timerUtil.cancel(); //记得在dispose里面把timer cancel。
  }

  Widget _buildSwiper() {
    return new Swiper(
      loop: false,
      pagination: new SwiperPagination(
          alignment: Alignment.bottomCenter,
          margin: EdgeInsets.all(20),
          builder: DotSwiperPaginationBuilder(
            size: 5,
            space: 3,
          )),
      control: null,
      onIndexChanged: _onIndexChanged,
      itemBuilder: (BuildContext context, int index) {
        return _bannerList[index];
      },
      itemCount: _bannerList.length,
    );
  }
}
