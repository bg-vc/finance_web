class CommonProvider {
  static int _homeIndex = 0;

  static int get homeIndex => _homeIndex;

  static changeHomeIndex(int value) {
    _homeIndex = value;
  }

  /*static List<String> _homeList = [
    '挖矿',
    '交易',
    '关于',
    '连接钱包',
    '简体中文',
  ];
  static List<String> get homeList => _homeList;
*/
}
