import 'package:finance_web/page/pc/about_pc_page.dart';
import 'package:finance_web/page/pc/swap_pc_page.dart';
import 'package:finance_web/page/pc/vault_pc_page.dart';
import 'package:finance_web/page/wap/about_wap_page.dart';
import 'package:finance_web/page/wap/swap_wap_page.dart';
import 'package:finance_web/page/wap/vault_wap_page.dart';
import 'package:fluro/fluro.dart';
import 'package:flutter/material.dart';

Handler vaultPcHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return VaultPcPage();
});

Handler swapPcHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return SwapPcPage();
});

Handler aboutPcHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return AboutPcPage();
});


Handler vaultWapHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return VaultWapPage();
});

Handler swapWapHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return SwapWapPage();
});

Handler aboutWapHandler =
Handler(handlerFunc: (BuildContext context, Map<String, dynamic> params) {
  return AboutWapPage();
});