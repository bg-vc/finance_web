import 'package:finance_web/model/lang_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IndexProvider with ChangeNotifier {
  //深色模式 0: 关闭 1:开启
  int _darkMode = 0;

  int get darkMode => _darkMode;

  String _darkModeKey = 'darkMode';

  void init() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getInt(_darkModeKey) != null) {
        int temp = prefs.getInt(_darkModeKey);
        _darkMode = temp;
      }
      notifyListeners();
    });
  }

  void changeMode(int darkMode) async {
    _darkMode = darkMode;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_darkModeKey, _darkMode);
    notifyListeners();
  }

  bool _tronFlag = false;

  bool get tronFlag => _tronFlag;

  String _account = '';

  String get account => _account;

  void changeAccount(String value) {
    _account = value;
    notifyListeners();
  }

  int _langType = 0;

  int get langType => _langType;

  changeLangType(int value) {
    _langType = value;
  }

  List<LangModel> _langModels = List<LangModel>()
    ..add(LangModel(id: 0, name: '简体中文'))
    ..add(LangModel(id: 1, name: 'English'));

  List<LangModel> get langModels => _langModels;


  /*String _depositAmount = '';
  String get depositAmount => _depositAmount;

  changeDepositAmount(String value) {
    _depositAmount = value;
    notifyListeners();
  }

  String _withdrawAmount = '';
  String get withdrawAmount => _withdrawAmount;

  changeWithdrawAmount(String value) {
    _withdrawAmount = value;
    notifyListeners();
  }*/

}
