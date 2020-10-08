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
      title: 'Vault BG-Finance',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router.generator,
      home:VaultPcPage(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
      ],
    ) : MaterialApp(
      title: 'Vault BG-Finance',
      debugShowCheckedModeBanner: false,
      onGenerateRoute: Application.router.generator,
      home: Container(),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        const FallbackCupertinoLocalisationsDelegate(),
      ],
      supportedLocales: [
        const Locale('zh', 'CH'),
      ],
    );
  }
}

class FallbackCupertinoLocalisationsDelegate extends LocalizationsDelegate<CupertinoLocalizations> {
  const FallbackCupertinoLocalisationsDelegate();

  @override
  bool isSupported(Locale locale) => true;

  @override
  Future<CupertinoLocalizations> load(Locale locale) =>
      DefaultCupertinoLocalizations.load(locale);

  @override
  bool shouldReload(FallbackCupertinoLocalisationsDelegate old) => false;
}
