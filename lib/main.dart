import 'package:finance_web/page/wap/vault_wap_page.dart';
import 'package:finance_web/provider/index_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluro/fluro.dart'as fluro;
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import 'common/platform.dart';
import 'page/pc/vault_pc_page.dart';
import 'router/application.dart';
import 'router/router.dart';

void main() {
  final router = fluro.Router();
  Routes.configure(router);
  Application.router = router;

  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider(create: (_) => IndexProvider()..init()),
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {


  @override
  Widget build(BuildContext context) {
    final isNotMobile = !PlatformDetector().isMobile();
    return isNotMobile ? MaterialApp(
      title: 'Flash Finance',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router.generator,
      home:VaultPcPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'zh'),
      ],
    ) : MaterialApp(
      title: 'Flash Finance',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router.generator,
      home: VaultWapPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('en', 'zh'),
      ],
    );
  }
}
