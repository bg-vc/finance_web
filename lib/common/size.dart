import 'package:finance_web/util/screen_util.dart';
import 'package:finance_web/widget/resp_widget.dart';
import 'package:flutter/material.dart';

SizedBox heightBoxBig = SizedBox(
  height: 20,
);
SizedBox heightBoxMid = SizedBox(
  height: 10,
);
SizedBox heightBoxSmall = SizedBox(
  height: 5,
);

EdgeInsetsGeometry padding(context) => EdgeInsets.symmetric(
    horizontal: !RespWidget.isSmallScreen(context)
        ? (LocalScreenUtil.getInstance().setWidth(50))
        : (LocalScreenUtil.getInstance().setWidth(0)));

class Sizes {
  static const double large = 1200;

  static const double mid = 800;

  static const double small = 500;
}
