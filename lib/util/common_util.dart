import 'package:common_utils/common_utils.dart';

class Util {
  static String removeDecimalZeroFormat(double x){
    int i = x.truncate() ;
    if(x == i){
      return i.toString();
    }
    return x.toString();
  }

  static String formatNumber4CN(double n) {
    if (n >= 10000 && n < 100000000) {
      double d = n / 10000;
      return '${formatNumberSub(d, 3)}万';
    } else if (n >= 100000000) {
      double d = n / 100000000;
      return '${formatNumberSub(d, 3)}亿';
    }
    return formatNumberSub(n, 3);
  }

  static String formatNumber(double n, position) {
    if (n >= 1000 && n < 1000000) {
      double d = n / 1000;
      return '${formatNumberSub(d, position)}K';
    } else if (n >= 1000000 && n < 1000000000) {
      double d = n / 1000000;
      return '${formatNumberSub(d, position)}M';
    } else if (n >= 1000000000) {
      double d = n / 1000000000;
      return '${formatNumberSub(d, position)}B';
    }
    return formatNumberSub(n, position);
  }

  static String formatNumberSub(double num, int position) {
    if ((num.toString().length - num.toString().lastIndexOf(".") - 1) < position) {
      return num.toStringAsFixed(position).substring(0, num.toString().lastIndexOf(".") + position + 1).toString();
    } else {
      return num.toString().substring(0, num.toString().lastIndexOf(".") + position + 1).toString();
    }
  }

  static int getDayTime(DateTime dateTime) {
    String dateStr = DateUtil.formatDateMs(dateTime.millisecondsSinceEpoch, format: DateFormats.y_mo_d);
    DateTime dt = DateUtil.getDateTime(dateStr);
    int dtInt = int.parse((dt.millisecondsSinceEpoch / 1000).toString().split('.')[0]);
    return dtInt;
  }

  static bool isEmpty(String value) {
    return value == null || value.trim() == '';
  }

}
