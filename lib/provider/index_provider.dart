import 'package:finance_web/generated/l10n.dart';
import 'package:finance_web/model/lang_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class IndexProvider with ChangeNotifier {

  void init() {
    SharedPreferences.getInstance().then((prefs) {
      if (prefs.getInt(_langTypeKey) != null) {
        int temp = prefs.getInt(_langTypeKey);
        _langType = temp;
      }
      if (_langType == 0) {
        S.load(Locale('zh', ''));
      } else if (_langType == 1) {
        S.load(Locale('en', ''));
      }
      notifyListeners();
    });
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

  String _langTypeKey =  'langTypeKey';

  changeLangType(int value) async {
    _langType = value;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setInt(_langTypeKey, _langType);
    if (_langType == 0) {
      S.load(Locale('zh', ''));
    } else if (_langType == 1) {
      S.load(Locale('en', ''));
    }
    notifyListeners();
  }

  List<LangModel> _langModels = List<LangModel>()
    ..add(LangModel(id: 0, name: '简体中文'))
    ..add(LangModel(id: 1, name: 'English'));

  List<LangModel> get langModels => _langModels;


}
