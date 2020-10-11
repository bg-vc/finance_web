import 'dart:async';

import 'package:finance_web/common/color.dart';
import 'package:finance_web/config/service_config.dart';
import 'package:finance_web/provider/common_provider.dart';
import 'package:finance_web/provider/index_provider.dart';
import 'package:finance_web/router/application.dart';
import 'package:finance_web/util/screen_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'dart:js' as js;

import 'package:url_launcher/url_launcher.dart';


class SwapPcPage extends StatefulWidget {
  @override
  _SwapPcPageState createState() => _SwapPcPageState();
}

class _SwapPcPageState extends State<SwapPcPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool tronFlag = false;
  Timer _timer;

  @override
  void initState() {
    print('FarmPcPage 000');
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
    LocalScreenUtil.instance = LocalScreenUtil.getInstance()..init(context);
    return Material(
      color: MyColors.white,
      child: Scaffold(
        backgroundColor: MyColors.white,
        key: _scaffoldKey,
        appBar: _appBarWidget(context),
        body: Column(
          children: <Widget>[
            Expanded(
              child: _mainWidget(context),
            ),
            //FooterPage(),
          ],
        ),
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
            child: Container(
              child: Center(
                child: Text('Farm BG-Finance'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      titleSpacing: 0.0,
      leading: _leadingWidget(context),
      title: Container(
        margin:
        EdgeInsets.only(left: LocalScreenUtil.getInstance().setWidth(20)),
        child: Row(
          children: [
            Container(
              child: Image.asset('images/aaa.png', fit: BoxFit.contain, width: 80, height: 80),
            ),
          ],
        ),
      ),
      backgroundColor: MyColors.white,
      elevation: 2.5,
      centerTitle: false,
      actions: _actionWidget(context),
    );
  }

  Widget _leadingWidget(BuildContext context) {
    return Container(
      width: 0,
      child: InkWell(
        onTap: () {},
        child: Container(
          color: MyColors.white,
          child: null,
        ),
      ),
    );
  }

  List<Widget> _actionWidget(BuildContext context) {
    List<String> _homeList = CommonProvider.homeList;
    List<Widget> _widgetList = [];
    for (int i = 0; i < _homeList.length; i++) {
      _widgetList.add(_actionItemWidget(context, i));
    }
    _widgetList
        .add(SizedBox(width: LocalScreenUtil.getInstance().setWidth(50)));
    return _widgetList;
  }

  Widget _actionItemWidget(BuildContext context, int index) {
    String account = Provider.of<IndexProvider>(context).account;
    int _homeIndex = CommonProvider.homeIndex;
    List<String> _homeList = CommonProvider.homeList;
    return InkWell(
      child: index != 2 ? Container(
          color: MyColors.white,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 20, right: 20),
            child: Text(
              '${_homeList[index]}',
              style: GoogleFonts.lato(
                fontSize: 16.0,
                letterSpacing: 1,
                color: _homeIndex == index ? MyColors.black : MyColors.grey700,
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ))
          : Container(
        color: MyColors.white,
        child: Chip(
          padding:
          EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
          backgroundColor: MyColors.blue500,
          label: Text(
            account == '' ? '连接钱包' : account.substring(0, 4) + '...' + account.substring(account.length - 4, account.length),
            style: GoogleFonts.lato(
              letterSpacing: 0.5,
              color: MyColors.white,
              fontSize: 15,
            ),
          ),
        ),
      ),
      onTap: () async {
        if (index != 2) {
          setState(() {
            CommonProvider.changeHomeIndex(index);
          });
        }
        if (index == 0) {
          Application.router
              .navigateTo(context, 'vault', transition: TransitionType.fadeIn);
        } else if (index == 1) {
          Application.router
              .navigateTo(context, 'swap', transition: TransitionType.fadeIn);
        } else if (index == 2 && account == '') {
          showDialog(
            context: context,
            child: AlertDialog(
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(30.0))
              ),
              content: Container(
                width: 300,
                height: 150,
                decoration: BoxDecoration(
                  shape: BoxShape.rectangle,
                  color: Color(0xFFFFFF),
                  borderRadius: BorderRadius.all(Radius.circular(32.0)),
                ),
                child: Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        child: Text(
                          '请使用TronLink钱包登录',
                          style: GoogleFonts.lato(
                            fontSize: 18.0,
                            letterSpacing: 0.2,
                            color: MyColors.black,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      InkWell(
                          onTap: () {
                            launch(tronLinkChrome).catchError((error) {
                              print('launch error:$error');
                            });
                          },
                          child: Container(
                            child: Text(
                              '还没安装TronLink？ 请点击此处>>',
                              style: GoogleFonts.lato(
                                fontSize: 15.0,
                                letterSpacing: 0.2,
                                color: MyColors.black87,
                                //decoration: TextDecoration.underline,
                              ),
                            ),
                          )),
                    ],
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }

  _reloadAccount() async {
    _timer = Timer.periodic(Duration(milliseconds: 1000), (timer) async {
      tronFlag = js.context.hasProperty('tronWeb');
      print('_reloadAccount 222 ' + tronFlag.toString());
      if (tronFlag) {
        var result = js.context["tronWeb"]["defaultAddress"]["base58"];
        if (result.toString() != 'false') {
          Provider.of<IndexProvider>(context, listen: false).changeAccount(
              result.toString());
        } else {
          Provider.of<IndexProvider>(context, listen: false).changeAccount('');
        }
      } else {
        Provider.of<IndexProvider>(context, listen: false).changeAccount('');
      }
    });
  }
}
