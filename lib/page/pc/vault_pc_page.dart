import 'package:finance_web/common/color.dart';
import 'package:finance_web/provider/common_provider.dart';
import 'package:finance_web/router/application.dart';
import 'package:finance_web/util/screen_util.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class VaultPcPage extends StatefulWidget {
  @override
  _VaultPcPageState createState() => _VaultPcPageState();
}

class _VaultPcPageState extends State<VaultPcPage> {
  var _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    if (mounted) {
      setState(() {
        CommonProvider.changeHomeIndex(0);
      });
    }
  }

  @override
  void dispose() {
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
          _oneWidget(context),
        ],
      ),
    );
  }

  Widget _oneWidget(BuildContext context) {
    return InkWell(
      onTap: () {

      },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 1200,
            height: 120,
            child: Card(
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(8.0))),
              child: Container(
                child: Center(
                  child: Text('Value Finance'),
                ),
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
      child: Container(

      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    return AppBar(
      toolbarHeight: 60,
      titleSpacing: 0.0,
      leading: _leadingWidget(context),
      title: Container(
        margin: EdgeInsets.only(left: LocalScreenUtil.getInstance().setWidth(20)),
        child: Row(
          children: [
            Container(
              child: Image.asset('images/aaa.png', fit: BoxFit.contain, width: 80, height: 80),
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
    int _homeIndex = CommonProvider.homeIndex;
    List<String> _homeList = CommonProvider.homeList;
    return InkWell(
      child: Container(
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
          )),
      onTap: () async {
        if (mounted) {
          setState(() {
            CommonProvider.changeHomeIndex(index);
          });
        }
        if (index == 0) {
          Application.router.navigateTo(context, 'vault', transition: TransitionType.fadeIn);
        } else if (index == 1) {
          Application.router.navigateTo(context, 'farm', transition: TransitionType.fadeIn);
        }
      },
    );
  }

}
