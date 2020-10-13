import 'dart:async';

import 'package:common_utils/common_utils.dart';
import 'package:finance_web/common/color.dart';
import 'package:finance_web/config/service_config.dart';
import 'package:finance_web/generated/l10n.dart';
import 'package:finance_web/model/asset_model.dart';
import 'package:finance_web/model/lang_model.dart';
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

class FarmPcPage extends StatefulWidget {
  @override
  _FarmPcPageState createState() => _FarmPcPageState();
}

class _FarmPcPageState extends State<FarmPcPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();
  int _layoutIndex = -1;
  bool _layoutFlag = false;
  bool tronFlag = false;
  Timer _timer;
  String _depositAmount = '';
  String _withdrawAmount = '';
  String _harvestAmount = '';

  TextEditingController _depositAmountController;
  TextEditingController _withdrawAmountController;
  TextEditingController _harvestAmountController;

  int _selectAssetFilterIndex = 0;

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
    _getAssetData();
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
    _harvestAmountController =  TextEditingController.fromValue(TextEditingValue(text: _harvestAmount,
        selection: TextSelection.fromPosition(TextPosition(affinity: TextAffinity.downstream, offset: _harvestAmount.length))));

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
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Container(
                padding: EdgeInsets.only(top: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _topBizWidget(context, item, index, 1),
                  ],
                ),
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
            child: Card(
              elevation: 3,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))),
              child: Container(
                padding: EdgeInsets.only(top: 25, bottom: 25),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    _topBizWidget(context, item, index, 2),
                    SizedBox(height: 30),
                    _bottomBizWidget(context, item),
                  ],
                ),
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
          _harvestAmount = '';
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
                        fontSize: 19,
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
                        fontSize: 19,
                        color: MyColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '${S.of(context).vaultBalance}',
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
                        fontSize: 19,
                        color: MyColors.black,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '${S.of(context).vaultDeposited}',
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
                        fontSize: 19,
                        color: MyColors.black,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Container(
                    child: Text(
                      '${S.of(context).vaultApy}',
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
                      _depositAmount = '';
                      _withdrawAmount = '';
                      _harvestAmount = '';
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
                    '${S.of(context).vaultBalance}:   66.6126 ${item.depositTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.grey700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                SizedBox(height: 20),
                InkWell(
                  onTap: () {},
                  child: Container(
                    color: MyColors.white,
                    child: Chip(
                      elevation: 2,
                      padding: EdgeInsets.only(left: 50, top: 15, bottom: 15, right: 50),
                      backgroundColor: MyColors.blue500,
                      label: Text(
                        '${S.of(context).vaultDeposit}',
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
                    '${S.of(context).vaultDeposited}:   20.5600 ${item.depositTokenName}',
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      color: MyColors.grey700,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
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
                SizedBox(height: 20),
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
                        '${S.of(context).vaultWithdraw}',
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
                InkWell(
                  hoverColor: MyColors.white,
                  onTap: () {
                    _showAssetFilterDialLog();
                  },
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Container(
                        width: 70,
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        decoration: BoxDecoration(
                          color: MyColors.blue500,
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                        child: Container(
                          width: 70,
                          alignment: Alignment.center,
                          child: Text(
                            '${_assetModels[_selectAssetFilterIndex].tokenName}',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 10),
                      Container(
                        child: Text(
                          '20.5600 ${_assetModels[_selectAssetFilterIndex].tokenName}',
                          style: GoogleFonts.lato(
                            fontSize: 15,
                            color: MyColors.grey700,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      )
                    ],
                  ),
                ),
                SizedBox(height: 3),
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
                        controller: _harvestAmountController,
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
                            _harvestAmount = value;
                          } else {
                            _harvestAmount = '';
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
                      _rateWidget(context, 3, 20.5600, 25),
                      SizedBox(width: 0),
                      _rateWidget(context, 3, 20.5600, 50),
                      SizedBox(width: 0),
                      _rateWidget(context, 3, 20.5600, 75),
                      SizedBox(width: 0),
                      _rateWidget(context, 3, 20.5600, 100),
                    ],
                  ),
                ),
                SizedBox(height: 20),
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
                        '${S.of(context).vaultHarvest}',
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
              } else if (type == 2) {
                _withdrawAmount = value.toString();
              } else if (type == 3) {
                _harvestAmount = value.toString();
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
        color: MyColors.white,
        margin: EdgeInsets.only(left: LocalScreenUtil.getInstance().setWidth(20)),
        child: Row(
          children: [
            Container(
              child: Image.asset('images/aaa.png', fit: BoxFit.contain, width: 80, height: 80),
            ),
          ],
        ),
      ),
      backgroundColor: MyColors.white,
      elevation: 0.0,
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
    List<Widget> _widgetList = [];
    for (int i = 0; i < 5; i++) {
      _widgetList.add(_actionItemWidget(context, i));
    }
    _widgetList.add(SizedBox(width: LocalScreenUtil.getInstance().setWidth(50)));
    return _widgetList;
  }

  Widget _actionItemWidget(BuildContext context, int index) {
    String account = Provider.of<IndexProvider>(context).account;
    int _homeIndex = CommonProvider.homeIndex;
    String actionTitle = '';
    switch(index) {
      case 0:
        actionTitle = S.of(context).actionTitle0;
        break;
      case 1:
        actionTitle = S.of(context).actionTitle1;
        break;
      case 2:
        actionTitle = S.of(context).actionTitle2;
        break;
      case 3:
        actionTitle = S.of(context).actionTitle3;
        break;
    }
    int langType = Provider.of<IndexProvider>(context).langType;
    return Container(
      color: MyColors.white,
      child: InkWell(
        child: index != 3 && index != 4 ?
        Container(
            color: MyColors.white,
            child: Container(
              alignment: Alignment.center,
              padding: EdgeInsets.only(left: 20, right: 20),
              child: Text(
                '$actionTitle',
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
            : index != 4 ?
        Container(
          color: MyColors.white,
          child: Chip(
            elevation: 3,
            padding: EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
            backgroundColor: MyColors.blue500,
            label: Text(
              account == '' ? '$actionTitle' : account.substring(0, 4) + '...' + account.substring(account.length - 4, account.length),
              style: GoogleFonts.lato(
                letterSpacing: 0.5,
                color: MyColors.white,
                fontSize: 15,
              ),
            ),
          ),
        ) : Container(
          margin: EdgeInsets.only(left: 15),
          color: MyColors.white,
          child: Chip(
            elevation: 3,
            padding: EdgeInsets.only(left: 20, top: 12, bottom: 12, right: 20),
            backgroundColor: MyColors.white,
            label: Text(
              langType == 1 ? 'English' : '简体中文',
              style: GoogleFonts.lato(
                letterSpacing: 0.5,
                color: MyColors.grey700,
                fontSize: 15,
              ),
            ),
          ),
        ),
        onTap: () async {
          if (index != 3 && index != 4) {
            CommonProvider.changeHomeIndex(index);
          }
          if (index == 0) {
            Application.router.navigateTo(context, 'farm', transition: TransitionType.fadeIn);
          } else if (index == 1) {
            Application.router.navigateTo(context, 'swap', transition: TransitionType.fadeIn);
          } else if (index == 2) {
            Application.router.navigateTo(context, 'about', transition: TransitionType.fadeIn);
          } else if (index == 3 && account == '') {
            _showConnectWalletDialLog();
          } else if (index == 4) {
            _showLangTypeDialLog();
          }
        },
      ),
    );
  }

  _showConnectWalletDialLog() {
    showDialog(
      context: context,
      child: AlertDialog(
        elevation: 3,
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(20.0))
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

  _showLangTypeDialLog() {
    List<LangModel> langModels = Provider.of<IndexProvider>(context, listen: false).langModels;
    showDialog(
      context: context,
      child: AlertDialog(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        content: Container(
          width: 300,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: langModels.length,
            itemBuilder: (context, index) {
              return _selectLangTypeItemWidget(context, index, langModels[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _selectLangTypeItemWidget(BuildContext context, int index, LangModel item) {
    int langType = Provider.of<IndexProvider>(context, listen: false).langType;
    bool flag = index == langType ? true : false;
    return InkWell(
      onTap: () {
        Provider.of<IndexProvider>(context, listen: false).changeLangType(index);
        Navigator.pop(context);
      },
      child: Container(
        width: 300,
        //color: MyColors.white,
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 200,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                '${item.name}',
                style: TextStyle(
                  color: !flag ? Colors.black87 : Colors.blue[800],
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 100,
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              alignment: Alignment.centerRight,
              child: !flag ? Container() : Icon(
                Icons.check,
                color: Colors.blue[800],
                size: 20,
              ),
            ),
          ],
        ),
      ),
    );
  }

  _showAssetFilterDialLog() {
    showDialog(
      context: context,
      child: AlertDialog(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(20.0))
        ),
        content: Container(
          width: 300,
          decoration: BoxDecoration(
            shape: BoxShape.rectangle,
            color: Color(0xFFFFFF),
            borderRadius: BorderRadius.all(Radius.circular(32.0)),
          ),
          child: ListView.builder(
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: _assetModels.length,
            itemBuilder: (context, index) {
              return _selectAssetItemWidget(context, index, _assetModels[index]);
            },
          ),
        ),
      ),
    );
  }

  Widget _selectAssetItemWidget(BuildContext context, int index, AssetModel item) {
    bool flag = index == _selectAssetFilterIndex ? true : false;
    return InkWell(
      onTap: () {
        setState(() {
          _selectAssetFilterIndex = index;
          Navigator.pop(context);
        });
      },
      child: Container(
        width: 300,
        //color: MyColors.white,
        padding: EdgeInsets.only(top: 6, bottom: 6),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            Container(
              width: 200,
              padding: EdgeInsets.fromLTRB(10, 0, 0, 0),
              alignment: Alignment.centerLeft,
              child: Text(
                '${item.tokenName}',
                style: TextStyle(
                  color: !flag ? Colors.black87 : Colors.blue[800],
                  fontSize: 15,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            Container(
              width: 100,
              padding: EdgeInsets.fromLTRB(0, 0, 10, 0),
              alignment: Alignment.centerRight,
              child: !flag ? Container() : Icon(
                Icons.check,
                color: Colors.blue[800],
                size: 20,
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

  List<VaultRows> _vaultRows = List<VaultRows>();

  _getVaultData() async {
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
    setState(() {});
  }

  List<AssetModel> _assetModels = List<AssetModel>();
  _getAssetData() {
    _assetModels.add(AssetModel(id: 0, tokenName: 'SUN', tokenType: 2, precision: 18, tokenAddress: ''));
    _assetModels.add(AssetModel(id: 1, tokenName: 'TRX', tokenType: 1, precision: 6, tokenAddress: ''));
    _assetModels.add(AssetModel(id: 2, tokenName: 'USDT', tokenType: 2, precision: 6, tokenAddress: ''));
  }


}
