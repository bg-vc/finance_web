import 'dart:async';

import 'package:finance_web/common/color.dart';
import 'package:finance_web/provider/common_provider.dart';
import 'package:finance_web/provider/index_provider.dart';
import 'package:finance_web/router/application.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/screenutil.dart';
import 'package:google_fonts/google_fonts.dart';
import 'dart:js' as js;

import 'package:provider/provider.dart';

class SwapWapPage extends StatefulWidget {
  @override
  _SwapWapPageState createState() => _SwapWapPageState();
}

class _SwapWapPageState extends State<SwapWapPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  bool tronFlag = false;
  Timer _timer;


  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(1);
      });
    }
    _reloadAccount();
  }

  @override
  void dispose() {
    if (_timer != null) {
      if (_timer.isActive) {
        _timer.cancel();
      }
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.init(context, designSize: Size(750, 1334), allowFontScaling: false);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: MyColors.white,
      appBar: _appBarWidget(context),
      drawer: _drawerWidget(context),
      body: Column(
        children: <Widget>[
          Expanded(
            child: _mainWidget(context),
          ),
          //FooterPage(),
        ],
      ),
    );
  }

  Widget _mainWidget(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(left: 0, top: 0, right: 0),
      color: MyColors.white,
      child: Column(
        children: <Widget>[
          Expanded(
            child: _bodyWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: Center(
        child: Text(
          'Swap of Flash Finance',
        ),
      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    return AppBar(
      backgroundColor:  MyColors.lightBg,
      elevation: 0,
      titleSpacing: 0.0,
      title: Container(
        child: Text(
          'Flash Finance',
          style: GoogleFonts.lato(
            fontSize: ScreenUtil().setSp(38),
            color: Colors.black,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.0,
            fontStyle: FontStyle.italic,
          ),
        ),
      ),
      leading: IconButton(
        hoverColor: MyColors.white,
        icon: Container(
          margin: EdgeInsets.only(top: ScreenUtil().setHeight(5)),
          child: Icon(Icons.menu, size: ScreenUtil().setWidth(53), color: Colors.black87),
        ),
        onPressed: () {
          _scaffoldKey.currentState.openDrawer();
        },
      ),
      centerTitle: true,
    );
  }

  Widget _drawerWidget(BuildContext context) {
    int _homeIndex = CommonProvider.homeIndex;
    return Drawer(
      child: Container(
        color: MyColors.white,
        child: ListView(
          padding: EdgeInsets.all(20),
          children: <Widget>[
            ListTile(
              title: Text(
                '机枪池',
                style: GoogleFonts.lato(
                  fontSize: ScreenUtil().setSp(32),
                  color: _homeIndex == 0 ? Colors.black : Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  CommonProvider.changeHomeIndex(0);
                });
                Application.router.navigateTo(context, 'wap/vault', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.assistant,
                color: _homeIndex == 0 ? Colors.black87 : Colors.grey[700],
              ),
            ),
            ListTile(
              title:  Text(
                '交易',
                style: GoogleFonts.lato(
                  fontSize: ScreenUtil().setSp(32),
                  color: _homeIndex == 1 ? Colors.black : Colors.grey[700],
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              onTap: () {
                setState(() {
                  CommonProvider.changeHomeIndex(1);
                });
                Application.router.navigateTo(context, 'wap/swap', transition: TransitionType.fadeIn);
              },
              leading: Icon(
                Icons.broken_image,
                color: _homeIndex == 1 ? Colors.black87 : Colors.grey[700],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _reloadAccount() async {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      tronFlag = js.context.hasProperty('tronWeb');
      if (tronFlag) {
        var result = js.context["tronWeb"]["defaultAddress"]["base58"];
        if (result.toString() != 'false') {
          Provider.of<IndexProvider>(context, listen: false).changeAccount(result.toString());
        } else {
          Provider.of<IndexProvider>(context, listen: false).changeAccount('');
        }
      } else {
        Provider.of<IndexProvider>(context, listen: false).changeAccount('');
      }
    });
  }

}
