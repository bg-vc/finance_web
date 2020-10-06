import 'dart:html' as html;

class PlatformDetector {
  //var _iOS = ['iPad Simulator', 'iPhone Simulator', 'iPod Simulator', 'iPad', 'iPhone', 'iPod'];
  var _iOS = ['iPhone Simulator', 'iPod Simulator', 'iPhone', 'iPod'];


  bool isIOS() {
    var matches = false;
    _iOS.forEach((name) {
      if (html.window.navigator.platform.contains(name) || html.window.navigator.userAgent.contains(name)) {
        matches = true;
      }
    });
    return matches;
  }

  bool isAndroid() => html.window.navigator.platform == "Android" || html.window.navigator.userAgent.contains("Android");

  bool isMobile() => isAndroid() || isIOS();

  bool isWeiXin() => html.window.navigator.userAgent.toLowerCase().contains("micromessenger");

  String name() {
    var name = "";
    if (isAndroid()) {
      name = "Android";
    } else if (isIOS()) {
      name = "iOS";
    }
    return name;
  }

  void openStore(String url) {
    if (isAndroid()) {
      html.window.location.href = url;
    } else {
      html.window.location.href = url;
    }
  }
}