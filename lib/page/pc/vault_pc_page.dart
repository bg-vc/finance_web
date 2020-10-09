import 'dart:async';

import 'package:finance_web/common/color.dart';
import 'package:finance_web/config/service_config.dart';
import 'package:finance_web/provider/common_provider.dart';
import 'package:finance_web/provider/index_provider.dart';
import 'package:finance_web/router/application.dart';
import 'package:finance_web/util/screen_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:provider/provider.dart';
import 'dart:js' as js;

import 'package:url_launcher/url_launcher.dart';

class VaultPcPage extends StatefulWidget {
  @override
  _VaultPcPageState createState() => _VaultPcPageState();
}

class _VaultPcPageState extends State<VaultPcPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  bool _layoutFlag = false;
  bool tronFlag = false;
  Timer _timer;

  @override
  void initState() {
    print('VaultPcPage 111');
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(0);
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
      color: MyColors.bg,
      child: Scaffold(
        backgroundColor: MyColors.bg,
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
      color: MyColors.bg,
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
      color: MyColors.bg,
      child: ListView(
        children: <Widget>[
          SizedBox(height: 50),
          !_layoutFlag ? _oneWidget(context) : _twoWidget(context),
        ],
      ),
    );
  }

  Widget _oneWidget(BuildContext context) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 1200,
            height: 120,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _topBizWidget(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _twoWidget(BuildContext context) {
    return InkWell(
      onTap: () {
      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 1200,
            height: 360,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _topBizWidget(context),
                  SizedBox(height: 50),
                  _bottomBizWidget(context),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBizWidget(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          _layoutFlag = !_layoutFlag;
        });
      },
      child: Container(
        color: MyColors.white,
        width: 1200,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              padding: EdgeInsets.only(left: 10),
              child: ClipOval(
                child: Image.asset(
                  'images/usdt.png',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 30),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      'USDT',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      'USDT',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 150),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '66.6126 USDT',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '余额',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 220),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '20.5600 USDT',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '已存入',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 100),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '11.68%',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '回报率',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 100),
            Container(
              child: Card(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _layoutFlag = !_layoutFlag;
                    });
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    color: MyColors.blue500,
                    alignment: Alignment.center,
                    child: Icon(
                      !_layoutFlag
                          ? CupertinoIcons.down_arrow
                          : CupertinoIcons.up_arrow,
                      size: 23,
                      color: MyColors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _bottomBizWidget(BuildContext context) {
    return Container(
      width: 1200,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 500,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '余额: 66.6126 USDT',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    border: Border.all(width: 1.0, color: Colors.blue[800]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: MaterialButton(
                    color: MyColors.white,
                    disabledColor: MyColors.white,
                    child: Container(
                      width: 500,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10),
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        cursorColor: MyColors.black87,
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.grey[500],
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.lato(
                          color: MyColors.black87,
                          fontSize: 16,
                        ),
                        onChanged: (String value) {},
                        onSaved: (String value) {},
                        onEditingComplete: () {},
                      ),
                    ),
                    shape:
                        StadiumBorder(side: BorderSide(color: MyColors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _rateWidget(context, 25),
                      SizedBox(width: 25),
                      _rateWidget(context, 50),
                      SizedBox(width: 25),
                      _rateWidget(context, 75),
                      SizedBox(width: 25),
                      _rateWidget(context, 100),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      padding: EdgeInsets.only(
                          left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: Text(
                        '存入',
                        style: GoogleFonts.lato(
                          letterSpacing: 0.5,
                          color: MyColors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
          ),
          SizedBox(width: 60),
          Container(
            width: 500,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '20.5600 iUSDT',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: MyColors.white,
                    border: Border.all(width: 1.0, color: Colors.blue[800]),
                    borderRadius: BorderRadius.circular(30),
                  ),
                  child: MaterialButton(
                    color: MyColors.white,
                    disabledColor: MyColors.white,
                    child: Container(
                      width: 500,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 10),
                      child: TextFormField(
                        enableInteractiveSelection: false,
                        cursorColor: MyColors.black87,
                        decoration: InputDecoration(
                          hintText: '',
                          hintStyle: GoogleFonts.lato(
                            color: Colors.grey[500],
                            fontSize: 16,
                            letterSpacing: 0.5,
                          ),
                          border: InputBorder.none,
                        ),
                        style: GoogleFonts.lato(
                          color: MyColors.black87,
                          fontSize: 16,
                        ),
                        onChanged: (String value) {},
                        onSaved: (String value) {},
                        onEditingComplete: () {},
                      ),
                    ),
                    shape:
                        StadiumBorder(side: BorderSide(color: MyColors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _rateWidget(context, 25),
                      SizedBox(width: 25),
                      _rateWidget(context, 50),
                      SizedBox(width: 25),
                      _rateWidget(context, 75),
                      SizedBox(width: 25),
                      _rateWidget(context, 100),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      padding: EdgeInsets.only(
                          left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: Text(
                        '提取',
                        style: GoogleFonts.lato(
                          letterSpacing: 0.5,
                          color: MyColors.white,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _rateWidget(BuildContext context, value) {
    return Container(
      color: MyColors.white,
      child: InkWell(
        onTap: () {
          print('111');
        },
        child: Container(
          decoration: BoxDecoration(
            color: MyColors.white,
            border: Border.all(width: 0.8, color: Colors.blue[800]),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Container(
            padding: EdgeInsets.only(left: 20, top: 8, bottom: 8, right: 20),
            child: Text(
              '$value%',
              style: GoogleFonts.lato(
                letterSpacing: 0.5,
                color: MyColors.grey700,
                fontSize: 14,
              ),
            ),
          ),
        ),
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
              child: Image.asset('images/aaa.png',
                  fit: BoxFit.contain, width: 80, height: 80),
            ),
          ],
        ),
      ),
      backgroundColor: MyColors.bg,
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
          color: MyColors.bg,
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
    _widgetList.add(SizedBox(width: LocalScreenUtil.getInstance().setWidth(50)));
    return _widgetList;
  }

  Widget _actionItemWidget(BuildContext context, int index) {
    String account = Provider.of<IndexProvider>(context).account;
    int _homeIndex = CommonProvider.homeIndex;
    List<String> _homeList = CommonProvider.homeList;
    return InkWell(
      child: index != 2 ? Container(
              color: MyColors.bg,
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.only(left: 30, right: 30),
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
              color: MyColors.bg,
              child: Chip(
                padding: EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
                backgroundColor: MyColors.blue500,
                label: Text(
                  account == ''
                      ? '连接钱包' : account.substring(0, 4) + '...' + account.substring(account.length - 4, account.length),
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
          Application.router.navigateTo(context, 'vault', transition: TransitionType.fadeIn);
        } else if (index == 1) {
          Application.router.navigateTo(context, 'farm', transition: TransitionType.fadeIn);
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
      print('_reloadAccount 111 ' + tronFlag.toString());
      if (tronFlag) {
        var result = js.context["tronWeb"]["defaultAddress"]["base58"];
        if (result.toString() != 'false') {
          Provider.of<IndexProvider>(context, listen: false)
              .changeAccount(result.toString());
        } else {
          Provider.of<IndexProvider>(context, listen: false).changeAccount('');
        }
      } else {
        Provider.of<IndexProvider>(context, listen: false).changeAccount('');
      }
    });
  }
}
