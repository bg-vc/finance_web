import 'package:finance_web/page/pc/home_pc_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

Handler homePcHandler =
    Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return HomePcPage();
});
