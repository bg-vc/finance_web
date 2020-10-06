import 'package:finance_web/common/size.dart';
import 'package:flutter/material.dart';

class RespWidget extends StatelessWidget {
  final Widget largeScreen;
  final Widget mediumScreen;
  final Widget smallScreen;

  const RespWidget(
      {Key key,
        @required this.largeScreen,
        this.mediumScreen,
        this.smallScreen})
      : super(key: key);

  static bool isSmallScreen(BuildContext context) {
    return MediaQuery.of(context).size.width < Sizes.mid;
  }

  static bool isLargeScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= Sizes.large;
  }

  static bool isMediumScreen(BuildContext context) {
    return MediaQuery.of(context).size.width >= Sizes.mid &&
        MediaQuery.of(context).size.width < Sizes.large;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth >= 1200) {
          return largeScreen;
        } else if (constraints.maxWidth < 1200 && constraints.maxWidth > 768) {
          return mediumScreen ?? largeScreen;
        } else {
          return smallScreen ?? largeScreen;
        }
      },
    );
  }
}
