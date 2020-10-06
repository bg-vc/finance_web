import 'package:fluro/fluro.dart' as fluro;
import 'package:flutter/material.dart';

import 'handler.dart';

class Routes {
  static String root = '/';

  static void configure(fluro.Router router) {
    router.notFoundHandler = fluro.Handler(
        handlerFunc: (BuildContext context, Map<String, List<String>> params) {
      print('error => route was not found');
      return null;
    });

    router.define('/vault', handler: vaultPcHandler);
  }
}
