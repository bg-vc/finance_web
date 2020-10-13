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

    router.define('/farm', handler: farmPcHandler);
    router.define('/swap', handler: swapPcHandler);
    router.define('/about', handler: aboutPcHandler);

    router.define('/wap/farm', handler: farmWapHandler);
    router.define('/wap/swap', handler: swapWapHandler);
    router.define('/wap/about', handler: aboutWapHandler);

  }
}
