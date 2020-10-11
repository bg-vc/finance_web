import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:finance_web/common/color.dart';
import 'package:finance_web/config/service_config.dart';
import 'package:finance_web/model/vault_model.dart';
import 'package:finance_web/provider/common_provider.dart';
import 'package:finance_web/provider/index_provider.dart';
import 'package:finance_web/router/application.dart';
import 'package:finance_web/util/common_util.dart';
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
  int _layoutIndex = -1;
  bool _layoutFlag = false;
  bool tronFlag = false;
  Timer _timer;
  String _depositAmount = '';
  String _withdrawAmount = '';

  TextEditingController _depositAmountController;
  TextEditingController _withdrawAmountController;


  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(0);
      });
    }
    _reloadAccount();
    _getVaultData();
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
    _depositAmountController =  TextEditingController.fromValue(TextEditingValue(text: _depositAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _depositAmount.length))));
    _withdrawAmountController =  TextEditingController.fromValue(TextEditingValue(text: _withdrawAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _withdrawAmount.length))));

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
            child: _bodyWidget(context),
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget(BuildContext context) {
    return Container(
      color: MyColors.white,
      child: ListView.builder(
        shrinkWrap: true,
        scrollDirection: Axis.vertical,
        itemCount: _vaultRows.length,
        itemBuilder: (context, index) {
          return _bizWidget(context, _vaultRows[index], index);
        },
      ),
    );
  }

  Widget _bizWidget(BuildContext context, VaultRows item, int index) {
    return Container(
      child: Column(
        children: <Widget>[
          SizedBox(height: index == 0 ? 50 : 0),
          !_layoutFlag ? _oneWidget(context, item, index) : (_layoutIndex == index ? _twoWidget(context, item, index) : _oneWidget(context, item, index)),
          SizedBox(height: 10),
          SizedBox(height: index == _vaultRows.length - 1 ? 50 : 0),
        ],
      ),
    );
  }

  Widget _oneWidget(BuildContext context, VaultRows item, int index) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 1000,
            height: 120,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _topBizWidget(context, item, index, 1),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _twoWidget(BuildContext context, VaultRows item, int index) {
    return InkWell(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 1000,
            height: 360,
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  _topBizWidget(context, item, index, 2),
                  SizedBox(height: 50),
                  _bottomBizWidget(context, item),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _topBizWidget(BuildContext context, VaultRows item, int index, int type) {
    return InkWell(
      onTap: () {
        setState(() {
          _layoutIndex = index;
          if (type == 1) {
            _layoutFlag = true;
          } else {
            _layoutFlag = false;
          }
          _depositAmount = '';
          _withdrawAmount = '';
        });
      },
      child: Container(
        color: MyColors.white,
        width: 1000,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Container(
              child: ClipOval(
                child: Image.asset(
                  '${item.pic1}',
                  width: 50,
                  height: 50,
                  fit: BoxFit.cover,
                ),
              ),
            ),
            SizedBox(width: 50),
            Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${item.depositTokenName}',
                      style: GoogleFonts.lato(
                        fontSize: 20,
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '${item.depositTokenName}',
                      style: GoogleFonts.lato(
                        fontSize: 14,
                        color: MyColors.grey700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(width: 50),
            Container(
              width: 200,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '66.6126 ${item.depositTokenName}',
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
            SizedBox(width: 50),
            Container(
              width: 150,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '20.5600 ${item.depositTokenName}',
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
            SizedBox(width: 50),
            Container(
              width: 100,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  Container(
                    child: Text(
                      '${item.apy * 100}%',
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
            SizedBox(width: 50),
            Container(
              child: Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(10.0))),
                child: InkWell(
                  onTap: () {
                    setState(() {
                      _layoutIndex = index;
                      if (type == 1) {
                        _layoutFlag = true;
                      } else {
                        _layoutFlag = false;
                      }
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
                          : (_layoutIndex == index ? CupertinoIcons.up_arrow : CupertinoIcons.down_arrow),
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

  Widget _bottomBizWidget(BuildContext context, VaultRows item) {
    return Container(
      width: 1000,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 300,
            child: Column(
              children: <Widget>[
                Container(
                  width: 300,
                  alignment: Alignment.center,
                  child: Text(
                    '余额:   66.6126 ${item.depositTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1.5, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: MaterialButton(
                    color: MyColors.white,
                    disabledColor: MyColors.white,
                    child: Container(
                      width: 300,
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _depositAmountController,
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
                        //inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                        inputFormatters: [MyNumberTextInputFormatter(digit:6)],
                        onChanged: (String value) {
                          if (value != null && value != '') {
                            _depositAmount = value;
                          } else {
                            _depositAmount = '';
                          }
                          setState(() {});
                        },
                        onSaved: (String value) {},
                        onEditingComplete: () {},
                      ),
                    ),
                    shape: StadiumBorder(side: BorderSide(color: MyColors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _rateWidget(context, 1, 66.6126, 25),
                      SizedBox(width: 5),
                      _rateWidget(context, 1, 66.6126, 50),
                      SizedBox(width: 5),
                      _rateWidget(context, 1, 66.6126, 75),
                      SizedBox(width: 5),
                      _rateWidget(context, 1, 66.6126, 100),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      elevation: 2,
                      padding: EdgeInsets.only(left: 50, top: 15, bottom: 15, right: 50),
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
          SizedBox(width: 15),
          Container(
            width: 300,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '已存入:   20.5600 ${item.depositTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1.5, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: MaterialButton(
                    elevation: 3,
                    color: MyColors.white,
                    disabledColor: MyColors.white,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _withdrawAmountController,
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
                        //inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                        inputFormatters: [MyNumberTextInputFormatter(digit:6)],
                        onChanged: (String value) {
                          if (value != null && value != '') {
                            _withdrawAmount = value;
                          } else {
                            _withdrawAmount = '';
                          }
                          setState(() {});
                        },
                        onSaved: (String value) {},
                        onEditingComplete: () {},
                      ),
                    ),
                    shape: StadiumBorder(side: BorderSide(color: MyColors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _rateWidget(context, 2, 20.5600, 25),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, 20.5600, 50),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, 20.5600, 75),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, 20.5600, 100),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      elevation: 2,
                      padding: EdgeInsets.only(
                          left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: Text(
                        '赎回',
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
          SizedBox(width: 15),
          Container(
            width: 300,
            child: Column(
              children: <Widget>[
                Container(
                  alignment: Alignment.center,
                  child: Text(
                    '20.5600 ${item.depositTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.grey700,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Card(
                  elevation: 0,
                  shape: RoundedRectangleBorder(side: BorderSide(width: 1.5, color: Colors.grey[300]), borderRadius: BorderRadius.all(Radius.circular(30.0))),
                  child: MaterialButton(
                    elevation: 3,
                    color: MyColors.white,
                    disabledColor: MyColors.white,
                    child: Container(
                      alignment: Alignment.center,
                      padding: EdgeInsets.only(left: 20),
                      child: TextFormField(
                        controller: _withdrawAmountController,
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
                        //inputFormatters: [FilteringTextInputFormatter.allow(RegExp("[0-9.]"))],
                        inputFormatters: [MyNumberTextInputFormatter(digit:6)],
                        onChanged: (String value) {
                          if (value != null && value != '') {
                            _withdrawAmount = value;
                          } else {
                            _withdrawAmount = '';
                          }
                          setState(() {});
                        },
                        onSaved: (String value) {},
                        onEditingComplete: () {},
                      ),
                    ),
                    shape: StadiumBorder(side: BorderSide(color: MyColors.white)),
                  ),
                ),
                SizedBox(height: 10),
                Container(
                  width: 300,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      _rateWidget(context, 2, 20.5600, 25),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, 20.5600, 50),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, 20.5600, 75),
                      SizedBox(width: 0),
                      _rateWidget(context, 2, 20.5600, 100),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      elevation: 2,
                      padding: EdgeInsets.only(
                          left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: Text(
                        '收获',
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

  Widget _rateWidget(BuildContext context, int type, double balance, int rate) {
    return Material(
      color: Colors.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: InkWell(
        hoverColor: Colors.white,
        splashColor: Color(0x802196F3),
        highlightColor: Color(0x802196F3),
        onTap: () {
          String account = Provider.of<IndexProvider>(context, listen: false).account;
          double rateDouble = NumUtil.divide(rate, 100);
          if(account != '') {
            double value = NumUtil.multiply(balance, rateDouble);
            setState(() {
              if (type == 1) {
                _depositAmount = value.toString();
              } else {
                _withdrawAmount = value.toString();
              }
            });
          }
        },
        child: Container(
          padding: EdgeInsets.only(left: 15, top: 8, bottom: 8, right: 15),
          child: Text(
            '$rate%',
            style: GoogleFonts.lato(
              letterSpacing: 0.5,
              color: Colors.blue[800],
              fontSize: 14,
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
    _widgetList.add(SizedBox(width: LocalScreenUtil.getInstance().setWidth(50)));
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
                elevation: 3,
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
          Application.router.navigateTo(context, 'swap', transition: TransitionType.fadeIn);
        } else if (index == 2 && account == '') {
          showDialog(
            context: context,
            child: AlertDialog(
              elevation: 3,
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

  List<VaultRows> _vaultRows;

  _getVaultData() async {
    _vaultRows = List<VaultRows>();
    _vaultRows.add(VaultRows(
        id: 0,
        mineType: 1,
        depositTokenName: 'USDT',
        depositTokenType: 2,
        pic1: 'images/usdt.png',
        pic2: 'images/usdt.png',
        contractAddress: 'TPSrDszrQoHj1Ehekz52RCCB7r5jT3KBTY',
        apy: 0.1234));
    _vaultRows.add(VaultRows(
        id: 1,
        mineType: 1,
        depositTokenName: 'TRX',
        depositTokenType: 1,
        pic1: 'images/trx.png',
        pic2: 'images/trx.png',
        contractAddress: 'TPSrDszrQoHj1Ehekz52RCCB7r5jT3KBTY',
        apy: 0.2411));
    _vaultRows.add(VaultRows(
        id: 2,
        mineType: 1,
        depositTokenName: 'USDJ',
        depositTokenType: 2,
        pic1: 'images/usdj.png',
        pic2: 'images/usdj.png',
        contractAddress: 'TPSrDszrQoHj1Ehekz52RCCB7r5jT3KBTY',
        apy: 0.3611));
    _vaultRows.add(VaultRows(
        id: 3,
        mineType: 1,
        depositTokenName: 'SUN',
        depositTokenType: 2,
        pic1: 'images/sun.png',
        pic2: 'images/sun.png',
        contractAddress: 'TPSrDszrQoHj1Ehekz52RCCB7r5jT3KBTY',
        apy: 0.7956));
    _vaultRows.add(VaultRows(
        id: 4,
        mineType: 1,
        depositTokenName: 'JST',
        depositTokenType: 2,
        pic1: 'images/jst.png',
        pic2: 'images/jst.png',
        contractAddress: 'TPSrDszrQoHj1Ehekz52RCCB7r5jT3KBTY',
        apy: 0.5632));
    _vaultRows.add(VaultRows(
        id: 5,
        mineType: 1,
        depositTokenName: 'WBTT',
        depositTokenType: 2,
        pic1: 'images/wbtt.png',
        pic2: 'images/wbtt.png',
        contractAddress: 'TPSrDszrQoHj1Ehekz52RCCB7r5jT3KBTY',
        apy: 0.6512));

    _vaultRows.add(VaultRows(
        id: 4,
        mineType: 1,
        depositTokenName: 'JST',
        depositTokenType: 2,
        pic1: 'images/jst.png',
        pic2: 'images/jst.png',
        contractAddress: 'TPSrDszrQoHj1Ehekz52RCCB7r5jT3KBTY',
        apy: 0.5632));
    _vaultRows.add(VaultRows(
        id: 5,
        mineType: 1,
        depositTokenName: 'WBTT',
        depositTokenType: 2,
        pic1: 'images/wbtt.png',
        pic2: 'images/wbtt.png',
        contractAddress: 'TPSrDszrQoHj1Ehekz52RCCB7r5jT3KBTY',
        apy: 0.6512));
    setState(() {});
  }
}
