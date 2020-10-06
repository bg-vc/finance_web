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
        drawer: null,
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
            child: Container(
              child: Center(
                child: Text('Vault BG-Finance'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appBarWidget(BuildContext context) {
    return AppBar(
      titleSpacing: 0.0,
      title: Container(
        margin:
            EdgeInsets.only(left: LocalScreenUtil.getInstance().setWidth(10)),
        child: Row(
          children: [
            Container(
              child: Image.asset('images/aaa.png',
                  fit: BoxFit.contain, width: 60, height: 60),
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
    int _homeIndex = CommonProvider.homeIndex;
    List<String> _homeList = CommonProvider.homeList;
    return InkWell(
      child: Container(
          color: MyColors.bg,
          child: Container(
            alignment: Alignment.center,
            padding: EdgeInsets.only(left: 15, right: 15),
            child: Text(
              '${_homeList[index]}',
              style: GoogleFonts.lato(
                fontSize: 15.8,
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
          Application.router.navigateTo(context, 'vault', transition: TransitionType.fadeIn);
        }
      },
    );
  }
}
